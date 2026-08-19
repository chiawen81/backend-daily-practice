[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$failures = [Collections.Generic.List[string]]::new()

function Add-Result {
    param(
        [Parameter(Mandatory)][bool]$Passed,
        [Parameter(Mandatory)][string]$Message
    )

    if ($Passed) {
        Write-Host "PASS: $Message"
        return
    }

    Write-Host "FAIL: $Message"
    $failures.Add($Message)
}

function Assert-True {
    param(
        [Parameter(Mandatory)][bool]$Condition,
        [Parameter(Mandatory)][string]$Message
    )

    Add-Result -Passed $Condition -Message $Message
}

function Assert-False {
    param(
        [Parameter(Mandatory)][bool]$Condition,
        [Parameter(Mandatory)][string]$Message
    )

    Add-Result -Passed (-not $Condition) -Message $Message
}

function Assert-Equal {
    param(
        [AllowNull()][object]$Expected,
        [AllowNull()][object]$Actual,
        [Parameter(Mandatory)][string]$Message
    )

    Add-Result -Passed ($Expected -ceq $Actual) -Message "$Message (expected: '$Expected'; actual: '$Actual')"
}

function Assert-Match {
    param(
        [Parameter(Mandatory)][string]$Pattern,
        [AllowEmptyString()][string]$Actual,
        [Parameter(Mandatory)][string]$Message
    )

    Add-Result -Passed ($Actual -match $Pattern) -Message $Message
}

$scriptUnderTest = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\scripts\New-DailyExercise.ps1')).Path
$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar)
$testContainer = Join-Path $tempBase ("daily-skill-test-{0}" -f [guid]::NewGuid().ToString('N'))
$repositoryRoot = Join-Path $testContainer 'backend-daily-practice'

try {
    New-Item -ItemType Directory -Path (Join-Path $repositoryRoot 'day01') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $repositoryRoot 'day02') -Force | Out-Null

    [IO.File]::WriteAllText(
        (Join-Path $repositoryRoot 'day01\Program.cs'),
        'Console.WriteLine("day01 history");' + [Environment]::NewLine
    )
    [IO.File]::WriteAllText(
        (Join-Path $repositoryRoot 'day02\Program.cs'),
        'Console.WriteLine("day02 history");' + [Environment]::NewLine
    )
    [IO.File]::WriteAllText(
        (Join-Path $repositoryRoot 'day02\doc.md'),
        'day02 notes' + [Environment]::NewLine
    )

    $projectXml = @'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="day02\Program.cs" />
  </ItemGroup>
</Project>
'@
    [IO.File]::WriteAllText(
        (Join-Path $repositoryRoot 'backend-daily-practice.csproj'),
        $projectXml + [Environment]::NewLine
    )

    $scriptFailed = $false
    $output = @()
    try {
        $output = @(& $scriptUnderTest -RepositoryRoot $repositoryRoot 2>&1)
    }
    catch {
        $scriptFailed = $true
        $output += $_
    }

    Assert-False -Condition $scriptFailed -Message 'script exits successfully'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $repositoryRoot 'day03\Program.cs') -PathType Leaf) -Message 'day03 Program.cs exists'
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $repositoryRoot 'day03\doc.md') -PathType Leaf) -Message 'day03 doc.md exists'
    Assert-False -Condition (Test-Path -LiteralPath (Join-Path $repositoryRoot 'day03\day03.csproj')) -Message 'no per-Day project exists'
    Assert-Equal -Expected 'Console.WriteLine("day01 history");' -Actual ((Get-Content -LiteralPath (Join-Path $repositoryRoot 'day01\Program.cs') -Raw).Trim()) -Message 'day01 source is preserved'
    Assert-Equal -Expected 'Console.WriteLine("day02 history");' -Actual ((Get-Content -LiteralPath (Join-Path $repositoryRoot 'day02\Program.cs') -Raw).Trim()) -Message 'day02 source is preserved'
    Assert-Equal -Expected 'day02 notes' -Actual ((Get-Content -LiteralPath (Join-Path $repositoryRoot 'day02\doc.md') -Raw).Trim()) -Message 'day02 notes are preserved'

    [xml]$updatedProject = Get-Content -LiteralPath (Join-Path $repositoryRoot 'backend-daily-practice.csproj') -Raw
    $compileNodes = @($updatedProject.SelectNodes('/Project/ItemGroup/Compile'))
    Assert-Equal -Expected 1 -Actual $compileNodes.Count -Message 'shared project has one Compile item'
    if ($compileNodes.Count -eq 1) {
        Assert-Equal -Expected 'day03\Program.cs' -Actual $compileNodes[0].GetAttribute('Include') -Message 'shared project selects day03'
    }

    Assert-Match -Pattern 'Hello, World!' -Actual ($output -join [Environment]::NewLine) -Message 'new Daily runs successfully'

    # 迴歸測試：建立環境時必須連帶刷新 INDEX.md（排除當天新建的 Daily）
    $indexPath = Join-Path $repositoryRoot 'INDEX.md'
    Assert-True -Condition (Test-Path -LiteralPath $indexPath -PathType Leaf) -Message 'INDEX.md is refreshed by the creation script'
    if (Test-Path -LiteralPath $indexPath -PathType Leaf) {
        $indexText = [IO.File]::ReadAllText($indexPath)
        Assert-Match -Pattern '\[01\]\(day01/\)' -Actual $indexText -Message 'INDEX.md lists day01'
        Assert-Match -Pattern '\[02\]\(day02/\)' -Actual $indexText -Message 'INDEX.md lists day02'
        Assert-False -Condition ($indexText -match '\[03\]\(day03/\)') -Message 'INDEX.md omits the newly created day03'
    }

    if ($failures.Count -gt 0) {
        throw "Daily workflow test failed with $($failures.Count) assertion(s)."
    }

    Write-Host 'Daily workflow test passed.'
}
finally {
    $normalizedContainer = [IO.Path]::GetFullPath($testContainer).TrimEnd([IO.Path]::DirectorySeparatorChar)
    $expectedPrefix = $tempBase + [IO.Path]::DirectorySeparatorChar + 'daily-skill-test-'
    if (-not $normalizedContainer.StartsWith($expectedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Unsafe test cleanup path: $normalizedContainer"
    }

    if (Test-Path -LiteralPath $normalizedContainer) {
        Remove-Item -LiteralPath $normalizedContainer -Recurse -Force
    }
}
