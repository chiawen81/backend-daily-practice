[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-NormalizedPath {
    param([Parameter(Mandatory)][string]$Path)

    return [IO.Path]::GetFullPath($Path).TrimEnd([char[]]@(
        [IO.Path]::DirectorySeparatorChar,
        [IO.Path]::AltDirectorySeparatorChar
    ))
}

function Test-SamePath {
    param(
        [Parameter(Mandatory)][string]$Left,
        [Parameter(Mandatory)][string]$Right
    )

    return [string]::Equals(
        (Get-NormalizedPath -Path $Left),
        (Get-NormalizedPath -Path $Right),
        [StringComparison]::OrdinalIgnoreCase
    )
}

if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
    throw "Repository root is not a directory: $RepositoryRoot"
}

$repositoryPath = Get-NormalizedPath -Path (Resolve-Path -LiteralPath $RepositoryRoot).Path
$repositoryName = Split-Path -Leaf $repositoryPath
if ($repositoryName -ne 'backend-daily-practice') {
    throw "Expected the backend-daily-practice repository root, but received: $repositoryPath"
}

$dailyDirectories = @(
    Get-ChildItem -LiteralPath $repositoryPath -Directory -Force | ForEach-Object {
        if ($_.Name -match '^day(?<Number>[0-9]{2,})$') {
            $number = 0L
            if (-not [long]::TryParse($Matches.Number, [ref]$number)) {
                throw "Daily number is too large to process safely: $($_.Name)"
            }

            [PSCustomObject]@{
                Directory = $_
                Name = $_.Name
                Number = $number
            }
        }
    }
)

$latestDaily = $null
$nextNumber = 1L

if ($dailyDirectories.Count -gt 0) {
    $maximumNumber = ($dailyDirectories | Measure-Object -Property Number -Maximum).Maximum
    $latestCandidates = @($dailyDirectories | Where-Object { $_.Number -eq $maximumNumber })
    if ($latestCandidates.Count -ne 1) {
        $ambiguousNames = ($latestCandidates.Name | Sort-Object) -join ', '
        throw "Multiple Daily directories represent the maximum number: $ambiguousNames"
    }

    $latestDaily = $latestCandidates[0]
    if ($latestDaily.Number -eq [long]::MaxValue) {
        throw "Cannot increment Daily number beyond $([long]::MaxValue)."
    }

    $nextNumber = $latestDaily.Number + 1
}

$nextName = 'day{0:D2}' -f $nextNumber
$nextPath = Get-NormalizedPath -Path (Join-Path $repositoryPath $nextName)
$nextParent = [IO.Directory]::GetParent($nextPath)
if ($null -eq $nextParent -or -not (Test-SamePath -Left $nextParent.FullName -Right $repositoryPath)) {
    throw "Next Daily path is outside the repository root: $nextPath"
}

if (Test-Path -LiteralPath $nextPath) {
    throw "The next Daily path already exists; refusing to overwrite it: $nextPath"
}

$cleanupTargets = @()
if ($null -ne $latestDaily) {
    if (($latestDaily.Directory.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "The latest Daily directory cannot be a reparse point: $($latestDaily.Directory.FullName)"
    }

    $latestPath = Get-NormalizedPath -Path $latestDaily.Directory.FullName
    $latestParent = [IO.Directory]::GetParent($latestPath)
    if ($null -eq $latestParent -or -not (Test-SamePath -Left $latestParent.FullName -Right $repositoryPath)) {
        throw "The latest Daily is not a direct child of the repository root: $latestPath"
    }

    foreach ($artifactName in @('bin', 'obj')) {
        $candidatePath = Join-Path $latestPath $artifactName
        if (-not (Test-Path -LiteralPath $candidatePath)) {
            continue
        }

        $candidate = Get-Item -LiteralPath $candidatePath -Force
        if (-not $candidate.PSIsContainer) {
            throw "Cleanup target is not a directory: $candidatePath"
        }

        if (($candidate.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "Cleanup target cannot be a reparse point: $candidatePath"
        }

        $actualPath = Get-NormalizedPath -Path $candidate.FullName
        $expectedPath = Get-NormalizedPath -Path $candidatePath
        $actualParent = [IO.Directory]::GetParent($actualPath)
        if (
            -not (Test-SamePath -Left $actualPath -Right $expectedPath) -or
            $null -eq $actualParent -or
            -not (Test-SamePath -Left $actualParent.FullName -Right $latestPath) -or
            (Split-Path -Leaf $actualPath) -notin @('bin', 'obj')
        ) {
            throw "Cleanup target does not match the expected dayXX/bin or dayXX/obj structure: $actualPath"
        }

        $cleanupTargets += $actualPath
    }
}

foreach ($cleanupTarget in $cleanupTargets) {
    Remove-Item -LiteralPath $cleanupTarget -Recurse -Force
    Write-Host "Removed build artifacts: $cleanupTarget"
}

$dotnet = Get-Command dotnet -CommandType Application -ErrorAction Stop
Write-Host "Creating $nextName with the installed .NET SDK..."
& $dotnet.Source new console --name $nextName --output $nextPath
if ($LASTEXITCODE -ne 0) {
    throw "dotnet new failed for $nextName with exit code $LASTEXITCODE."
}

$projectPath = Join-Path $nextPath "$nextName.csproj"
$programPath = Join-Path $nextPath 'Program.cs'
if (-not (Test-Path -LiteralPath $projectPath -PathType Leaf)) {
    throw "dotnet new did not create the expected project file: $projectPath"
}
if (-not (Test-Path -LiteralPath $programPath -PathType Leaf)) {
    throw "dotnet new did not create the expected Program.cs: $programPath"
}

Write-Host "Validating $nextName with dotnet run..."
& $dotnet.Source run --project $nextPath
if ($LASTEXITCODE -ne 0) {
    throw "dotnet run failed for $nextName with exit code $LASTEXITCODE."
}

Write-Host "Daily exercise environment created successfully: $nextPath"
