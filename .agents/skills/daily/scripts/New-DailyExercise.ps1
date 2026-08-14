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

$projectPath = Join-Path $repositoryPath 'backend-daily-practice.csproj'
if (-not (Test-Path -LiteralPath $projectPath -PathType Leaf)) {
    throw "Shared project does not exist: $projectPath"
}

$projectItem = Get-Item -LiteralPath $projectPath -Force
if (($projectItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw "Shared project cannot be a reparse point: $projectPath"
}

$actualProjectPath = Get-NormalizedPath -Path $projectItem.FullName
$projectParent = [IO.Directory]::GetParent($actualProjectPath)
if (
    -not (Test-SamePath -Left $actualProjectPath -Right $projectPath) -or
    $null -eq $projectParent -or
    -not (Test-SamePath -Left $projectParent.FullName -Right $repositoryPath)
) {
    throw "Shared project must be a direct child of the repository root: $actualProjectPath"
}

try {
    [xml]$projectXml = Get-Content -LiteralPath $actualProjectPath -Raw
}
catch {
    throw "Shared project is not valid XML: $actualProjectPath. $($_.Exception.Message)"
}

$defaultCompileNodes = @($projectXml.SelectNodes('/Project/PropertyGroup/EnableDefaultCompileItems'))
if ($defaultCompileNodes.Count -ne 1 -or $defaultCompileNodes[0].InnerText -cne 'false') {
    throw 'Shared project must contain exactly one EnableDefaultCompileItems element set to false.'
}

$compileNodes = @($projectXml.SelectNodes('/Project/ItemGroup/Compile'))
if ($compileNodes.Count -ne 1) {
    throw 'Shared project must contain exactly one Compile item.'
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

    if (($latestDaily.Directory.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "The latest Daily directory cannot be a reparse point: $($latestDaily.Directory.FullName)"
    }

    $latestPath = Get-NormalizedPath -Path $latestDaily.Directory.FullName
    $latestParent = [IO.Directory]::GetParent($latestPath)
    if ($null -eq $latestParent -or -not (Test-SamePath -Left $latestParent.FullName -Right $repositoryPath)) {
        throw "The latest Daily is not a direct child of the repository root: $latestPath"
    }

    $latestProgramPath = Join-Path $latestPath 'Program.cs'
    if (-not (Test-Path -LiteralPath $latestProgramPath -PathType Leaf)) {
        throw "The latest Daily does not contain Program.cs: $latestProgramPath"
    }

    $expectedCompileInclude = "$($latestDaily.Name)\Program.cs"
    $actualCompileInclude = $compileNodes[0].GetAttribute('Include')
    if (-not [string]::Equals($actualCompileInclude, $expectedCompileInclude, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Shared project selects '$actualCompileInclude', but the latest Daily requires '$expectedCompileInclude'."
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

$programPath = Join-Path $nextPath 'Program.cs'
$notePath = Join-Path $nextPath 'doc.md'
$utf8WithoutBom = [Text.UTF8Encoding]::new($false)

Write-Host "Creating $nextName in the shared Console project..."
[void][IO.Directory]::CreateDirectory($nextPath)
[IO.File]::WriteAllText(
    $programPath,
    'Console.WriteLine("Hello, World!");' + [Environment]::NewLine,
    $utf8WithoutBom
)
[IO.File]::WriteAllText($notePath, '', $utf8WithoutBom)

$nextCompileInclude = "$nextName\Program.cs"
$compileNodes[0].SetAttribute('Include', $nextCompileInclude)
$projectXml.Save($actualProjectPath)

$dotnet = Get-Command dotnet -CommandType Application -ErrorAction Stop
Write-Host "Validating $nextName with the shared project..."
& $dotnet.Source run --project $actualProjectPath
if ($LASTEXITCODE -ne 0) {
    throw "dotnet run failed for $nextName with exit code $LASTEXITCODE."
}

Write-Host "Created source: $programPath"
Write-Host "Created notes: $notePath"
Write-Host "Shared project source: $nextCompileInclude"
Write-Host "Daily exercise environment created successfully: $nextPath"
