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

function New-TestDaily {
    param(
        [Parameter(Mandatory)][string]$RepositoryPath,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$ProgramText,
        [hashtable]$Notes = @{}
    )

    $dailyPath = Join-Path $RepositoryPath $Name
    [void][IO.Directory]::CreateDirectory($dailyPath)
    $encoding = [Text.UTF8Encoding]::new($false)
    [IO.File]::WriteAllText((Join-Path $dailyPath 'Program.cs'), $ProgramText, $encoding)

    foreach ($noteName in $Notes.Keys) {
        [IO.File]::WriteAllText((Join-Path $dailyPath $noteName), $Notes[$noteName], $encoding)
    }
}

$scriptPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts\Update-DailyIndex.ps1'
if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
    throw "Script under test does not exist: $scriptPath"
}

$testRoot = Join-Path ([IO.Path]::GetTempPath()) "daily-index-test-$([Guid]::NewGuid().ToString('N'))"
$repositoryPath = Join-Path $testRoot 'backend-daily-practice'
[void][IO.Directory]::CreateDirectory($repositoryPath)

try {
    # 主題來源 1：講義_<主題>.md 檔名
    New-TestDaily -RepositoryPath $repositoryPath -Name 'day01' `
        -ProgramText 'Console.WriteLine("day01");' `
        -Notes @{ '講義_Lambda 運算式.md' = 'notes' }

    # 主題來源 2：Program.cs 的 "Daily NN — <主題>" 標題（含需跳脫的角括號）
    New-TestDaily -RepositoryPath $repositoryPath -Name 'day02' `
        -ProgramText "/*$([Environment]::NewLine)Daily 02 — List<T> + foreach$([Environment]::NewLine)*/"

    # 主題來源 3：筆記的第一個 Markdown 標題；同時測試空檔案要被忽略
    New-TestDaily -RepositoryPath $repositoryPath -Name 'day03' `
        -ProgramText 'Console.WriteLine("day03");' `
        -Notes @{ 'doc.md' = "# Collection$([Environment]::NewLine)"; 'empty.md' = '' }

    # 三種來源皆無 → 待補
    New-TestDaily -RepositoryPath $repositoryPath -Name 'day04' `
        -ProgramText 'Console.WriteLine("day04");'

    # 腳本失敗時會 throw，而 $ErrorActionPreference = 'Stop' 會讓測試直接中止
    & $scriptPath -RepositoryRoot $repositoryPath | Out-Null

    $indexPath = Join-Path $repositoryPath 'INDEX.md'
    Assert-True -Condition (Test-Path -LiteralPath $indexPath -PathType Leaf) -Message 'INDEX.md is created'

    $index = [IO.File]::ReadAllText($indexPath)

    Assert-True -Condition ($index -match '\| \[01\]\(day01/\) \|.+\| Lambda 運算式 \|') `
        -Message 'day01 topic comes from the 講義 file name'
    Assert-True -Condition ($index.Contains('day01/%E8%AC%9B%E7%BE%A9') -or $index.Contains('講義_Lambda%20運算式.md')) `
        -Message 'spaces in note links are percent-encoded'

    Assert-True -Condition ($index -match '\| \[02\]\(day02/\) \|.+\| List&lt;T&gt; \+ foreach \|') `
        -Message 'day02 topic comes from the Program.cs header and escapes angle brackets'

    Assert-True -Condition ($index -match '\| \[03\]\(day03/\) \|.+\| Collection \|') `
        -Message 'day03 topic falls back to the first Markdown heading'
    Assert-True -Condition (-not $index.Contains('empty.md')) `
        -Message 'empty note files are excluded'

    Assert-True -Condition ($index -match '\| \[04\]\(day04/\) \|.+\| _（待補）_ \|') `
        -Message 'day04 without any topic source is marked 待補'

    Assert-True -Condition ($index.Contains('共 4 個 Daily')) -Message 'daily count is reported'

    # -ExcludeDaily：建環境當下不要替剛建立的一天留佔位列
    & $scriptPath -RepositoryRoot $repositoryPath -ExcludeDaily 'day04' | Out-Null
    $excluded = [IO.File]::ReadAllText($indexPath)
    Assert-True -Condition (-not ($excluded -match '\| \[04\]\(day04/\)')) `
        -Message 'ExcludeDaily removes the newly created Daily from the table'
    Assert-True -Condition ($excluded -match '\| \[03\]\(day03/\)') `
        -Message 'ExcludeDaily keeps every other Daily'
    Assert-True -Condition ($excluded.Contains('共 3 個 Daily')) `
        -Message 'the reported count excludes the skipped Daily'

    # 隔天再跑（不帶 -ExcludeDaily）時，前一天要重新出現
    & $scriptPath -RepositoryRoot $repositoryPath | Out-Null
    $index = [IO.File]::ReadAllText($indexPath)
    Assert-True -Condition ($index -match '\| \[04\]\(day04/\)') `
        -Message 'a previously excluded Daily reappears on the next run'

    # 標記外的手寫內容必須保留，且重跑必須是冪等的
    [IO.File]::WriteAllText($indexPath, $index + "$([Environment]::NewLine)## 手寫區塊$([Environment]::NewLine)", [Text.UTF8Encoding]::new($false))
    & $scriptPath -RepositoryRoot $repositoryPath | Out-Null
    $rerun = [IO.File]::ReadAllText($indexPath)

    Assert-True -Condition ($rerun.Contains('## 手寫區塊')) -Message 'hand-written content outside the markers is preserved'

    $markerCount = ([regex]::Matches($rerun, '<!-- DAILY-INDEX:BEGIN -->')).Count
    Assert-True -Condition ($markerCount -eq 1) -Message 'rerun does not duplicate the generated block'

    & $scriptPath -RepositoryRoot $repositoryPath | Out-Null
    Assert-True -Condition ([IO.File]::ReadAllText($indexPath) -ceq $rerun) -Message 'rerun is idempotent'

    # 標記毀損時必須明確失敗，而不是靜默覆蓋
    [IO.File]::WriteAllText($indexPath, 'no markers here', [Text.UTF8Encoding]::new($false))
    $threw = $false
    try {
        & $scriptPath -RepositoryRoot $repositoryPath | Out-Null
    }
    catch {
        $threw = $true
    }
    Assert-True -Condition $threw -Message 'an index without markers is rejected instead of overwritten'

    # 錯誤的 repository root 必須被拒絕
    $wrongRoot = Join-Path $testRoot 'some-other-repo'
    [void][IO.Directory]::CreateDirectory($wrongRoot)
    $threw = $false
    try {
        & $scriptPath -RepositoryRoot $wrongRoot | Out-Null
    }
    catch {
        $threw = $true
    }
    Assert-True -Condition $threw -Message 'a non backend-daily-practice root is rejected'
}
finally {
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
}

if ($failures.Count -gt 0) {
    throw "Daily index test failed: $($failures -join '; ')"
}

Write-Host 'Daily index test passed.'
