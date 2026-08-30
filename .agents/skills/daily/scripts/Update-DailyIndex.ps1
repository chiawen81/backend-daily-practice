[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Get-Location).Path,
    [string]$IndexFileName = 'INDEX.md',
    # 剛建立、內容還是樣板的 Daily；排除後才不會在目錄留下一列空白佔位
    [string]$ExcludeDaily,
    # Sprint 分區設定；相對路徑以 repository root 為基準，檔案不存在時退回單一表格
    [string]$SprintFile = '.agents/skills/daily/config/sprints.json'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$beginMarker = '<!-- DAILY-INDEX:BEGIN -->'
$endMarker = '<!-- DAILY-INDEX:END -->'

function ConvertTo-MarkdownCell {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Text)

    # 表格分隔字元與角括號（例如 List<T>）在 Markdown 會壞掉，需先跳脫
    return $Text -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' -replace '\|', '\|'
}

function ConvertTo-MarkdownPath {
    param([Parameter(Mandatory)][string]$Path)

    return ($Path -replace '\\', '/') `
        -replace ' ', '%20' `
        -replace '\(', '%28' `
        -replace '\)', '%29'
}

function Get-DailyTopic {
    param(
        [Parameter(Mandatory)][string]$DailyPath,
        [AllowEmptyCollection()][IO.FileInfo[]]$Notes
    )

    # 1. 講義_主題.md / 延伸補充_主題.md 的檔名即主題
    $lecture = @($Notes | Where-Object { $_.BaseName -like '講義_*' }) | Select-Object -First 1
    if ($null -ne $lecture) {
        return $lecture.BaseName.Substring('講義_'.Length).Trim()
    }

    # 2. Program.cs 開頭的 "Daily 01 — 主題" 標題
    $programPath = Join-Path $DailyPath 'Program.cs'
    if (Test-Path -LiteralPath $programPath -PathType Leaf) {
        $header = @(Get-Content -LiteralPath $programPath -TotalCount 15 -Encoding UTF8)
        foreach ($line in $header) {
            if ($line -match 'Daily\s*\d+\s*[—–-]\s*(?<Topic>.+?)\s*$') {
                return $Matches.Topic
            }
        }
    }

    # 3. 任一筆記的第一個 Markdown 標題
    foreach ($note in $Notes) {
        $lines = @(Get-Content -LiteralPath $note.FullName -TotalCount 20 -Encoding UTF8)
        foreach ($line in $lines) {
            if ($line -match '^\s*#{1,3}\s+(?<Topic>.+?)\s*$') {
                return $Matches.Topic
            }
        }
    }

    return $null
}

function Get-NoteLabels {
    param([AllowEmptyCollection()][IO.FileInfo[]]$Notes)

    $entries = @($Notes | ForEach-Object {
        $stem = $_.BaseName
        $separator = $stem.IndexOf('_')
        if ($separator -gt 0) {
            $prefix = $stem.Substring(0, $separator)
            $rest = $stem.Substring($separator + 1)
        }
        else {
            $prefix = $stem
            $rest = $stem
        }

        [PSCustomObject]@{
            File = $_
            Prefix = $prefix
            Rest = $rest
        }
    })

    $duplicated = @(
        $entries | Group-Object -Property Prefix | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name }
    )

    return @($entries | ForEach-Object {
        $label = if ($duplicated -contains $_.Prefix) { "$($_.Prefix)·$($_.Rest)" } else { $_.Prefix }
        [PSCustomObject]@{
            File = $_.File
            Label = $label
        }
    })
}

function Get-LastCommitDate {
    param(
        [Parameter(Mandatory)][string]$RepositoryPath,
        [Parameter(Mandatory)][string]$RelativePath
    )

    # Windows 上 git 常同時存在 mingw64 與 cmd 兩個入口，只取第一個
    $git = @(Get-Command git -CommandType Application -ErrorAction SilentlyContinue) | Select-Object -First 1
    if ($null -eq $git) {
        return $null
    }

    try {
        $output = & $git.Source -C $RepositoryPath log -1 --format=%ad --date=format:%Y-%m-%d -- $RelativePath 2>$null
    }
    catch {
        return $null
    }

    if ($LASTEXITCODE -ne 0) {
        return $null
    }

    $date = ($output | Select-Object -First 1)
    if ([string]::IsNullOrWhiteSpace($date)) {
        return $null
    }

    return $date.Trim()
}

function Get-OptionalText {
    param(
        [Parameter(Mandatory)][psobject]$Source,
        [Parameter(Mandatory)][string]$Name
    )

    # StrictMode 下不能直接存取不存在的屬性，選填欄位一律走這裡
    if ($Source.PSObject.Properties.Name -notcontains $Name) {
        return $null
    }

    $value = $Source.$Name
    if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
        return $null
    }

    return ([string]$value).Trim()
}

function Get-SprintDefinition {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Path)

    # 沒有設定檔就維持舊行為（單一表格），讓腳本在任何 repository 都能獨立運作
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return @()
    }

    $raw = [IO.File]::ReadAllText($Path)
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    try {
        # 5.1 的 ConvertFrom-Json 會把整個陣列當成單一物件輸出，先落地再展開
        $parsed = ConvertFrom-Json -InputObject $raw
    }
    catch {
        throw "Sprint metadata is not valid JSON: $Path"
    }

    $sprints = @(@($parsed) | ForEach-Object {
        $name = Get-OptionalText -Source $_ -Name 'name'
        if ($null -eq $name) {
            throw "Every sprint in $Path needs a non-empty 'name'."
        }

        if ($_.PSObject.Properties.Name -notcontains 'startDay') {
            throw "Sprint '$name' in $Path needs a 'startDay'."
        }

        $startDay = [long]0
        if (-not [long]::TryParse([string]$_.startDay, [ref]$startDay) -or $startDay -lt 1) {
            throw "Sprint '$name' in $Path has an invalid 'startDay': $($_.startDay)"
        }

        [PSCustomObject]@{
            Name = $name
            Status = Get-OptionalText -Source $_ -Name 'status'
            StartDay = $startDay
            CompletedOn = Get-OptionalText -Source $_ -Name 'completedOn'
            Summary = Get-OptionalText -Source $_ -Name 'summary'
            Note = Get-OptionalText -Source $_ -Name 'note'
        }
    } | Sort-Object -Property StartDay)

    $duplicated = @(
        $sprints | Group-Object -Property StartDay | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Name }
    )
    if ($duplicated.Count -gt 0) {
        throw "Sprint metadata has duplicate startDay values ($($duplicated -join ', ')): $Path"
    }

    return $sprints
}

function New-DailyTable {
    param([AllowEmptyCollection()][string[]]$Rows)

    $table = New-Object System.Collections.Generic.List[string]
    $table.Add('| Day | 完成日 | 主題 | 程式碼 | 筆記 |')
    $table.Add('|:---:|:------:|------|:------:|------|')
    if ($null -ne $Rows -and $Rows.Count -gt 0) {
        $table.AddRange($Rows)
    }
    else {
        $table.Add('| — | — | _尚無 Daily_ | — | — |')
    }

    return $table.ToArray()
}

if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
    throw "Repository root is not a directory: $RepositoryRoot"
}

$repositoryPath = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $RepositoryRoot).Path)
$repositoryName = Split-Path -Leaf $repositoryPath.TrimEnd([char[]]@(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
))
if ($repositoryName -ne 'backend-daily-practice') {
    throw "Expected the backend-daily-practice repository root, but received: $repositoryPath"
}

if ([IO.Path]::GetFileName($IndexFileName) -ne $IndexFileName) {
    throw "Index file name must not contain a path: $IndexFileName"
}

$dailies = @(
    Get-ChildItem -LiteralPath $repositoryPath -Directory -Force | ForEach-Object {
        if ($_.Name -match '^day(?<Number>[0-9]{2,})$') {
            [PSCustomObject]@{
                Directory = $_
                Name = $_.Name
                Number = [long]$Matches.Number
            }
        }
    } | Sort-Object -Property Number
)

if (-not [string]::IsNullOrWhiteSpace($ExcludeDaily)) {
    $excluded = @($dailies | Where-Object { $_.Name -eq $ExcludeDaily })
    $dailies = @($dailies | Where-Object { $_.Name -ne $ExcludeDaily })
    if ($excluded.Count -gt 0) {
        Write-Host "Skipping the newly created Daily: $ExcludeDaily"
    }
}

$entries = New-Object System.Collections.Generic.List[psobject]
$pending = New-Object System.Collections.Generic.List[string]

foreach ($daily in $dailies) {
    $dailyPath = $daily.Directory.FullName

    $notes = @(
        Get-ChildItem -LiteralPath $dailyPath -File -Filter '*.md' -Force |
            Where-Object { $_.Length -gt 0 } |
            Sort-Object -Property Name
    )

    $topic = Get-DailyTopic -DailyPath $dailyPath -Notes $notes
    if ([string]::IsNullOrWhiteSpace($topic)) {
        $topicCell = '_（待補）_'
        $pending.Add($daily.Name)
    }
    else {
        $topicCell = ConvertTo-MarkdownCell -Text $topic
    }

    $programPath = Join-Path $dailyPath 'Program.cs'
    $programCell = if (Test-Path -LiteralPath $programPath -PathType Leaf) {
        "[Program.cs]($(ConvertTo-MarkdownPath "$($daily.Name)/Program.cs"))"
    }
    else {
        '—'
    }

    $noteLinks = @(Get-NoteLabels -Notes $notes | ForEach-Object {
        "[$(ConvertTo-MarkdownCell -Text $_.Label)]($(ConvertTo-MarkdownPath "$($daily.Name)/$($_.File.Name)"))"
    })
    $noteCell = if ($noteLinks.Count -gt 0) { $noteLinks -join ' · ' } else { '—' }

    $date = Get-LastCommitDate -RepositoryPath $repositoryPath -RelativePath $daily.Name
    $dateCell = if ($null -ne $date) { $date } else { '—' }

    $dayLabel = '{0:D2}' -f $daily.Number
    $entries.Add([PSCustomObject]@{
        Number = $daily.Number
        Row = "| [$dayLabel]($(ConvertTo-MarkdownPath $daily.Name)/) | $dateCell | $topicCell | $programCell | $noteCell |"
    })
}

$sprintPath = ''
if (-not [string]::IsNullOrWhiteSpace($SprintFile)) {
    $sprintPath = if ([IO.Path]::IsPathRooted($SprintFile)) {
        $SprintFile
    }
    else {
        Join-Path $repositoryPath $SprintFile
    }
}

$sprints = @(Get-SprintDefinition -Path $sprintPath)

$generated = New-Object System.Collections.Generic.List[string]
$generated.Add($beginMarker)
$generated.Add('')

if ($sprints.Count -eq 0) {
    $generated.AddRange([string[]](New-DailyTable -Rows @($entries | ForEach-Object { $_.Row })))
    $generated.Add('')
}
else {
    # 第一個 Sprint 起始日之前的 Daily 仍要列出，設定調整時才不會讓資料從目錄消失
    $orphans = @($entries | Where-Object { $_.Number -lt $sprints[0].StartDay })
    if ($orphans.Count -gt 0) {
        $generated.Add('## 未分類 Daily')
        $generated.Add('')
        $generated.Add('**Daily：** 第一個 Sprint 起始日之前')
        $generated.Add('')
        $generated.AddRange([string[]](New-DailyTable -Rows @($orphans | ForEach-Object { $_.Row })))
        $generated.Add('')
    }

    for ($i = 0; $i -lt $sprints.Count; $i++) {
        $sprint = $sprints[$i]

        # Sprint 的結束日由「下一個 Sprint 的起始日」推得；最後一個 Sprint 永遠開放，題數調整不必改腳本
        $nextStart = if ($i + 1 -lt $sprints.Count) { $sprints[$i + 1].StartDay } else { $null }

        $members = @($entries | Where-Object {
            $_.Number -ge $sprint.StartDay -and ($null -eq $nextStart -or $_.Number -lt $nextStart)
        })

        $range = if ($null -ne $nextStart) {
            'Day {0:D2}～Day {1:D2}' -f $sprint.StartDay, ($nextStart - 1)
        }
        else {
            'Day {0:D2} 起' -f $sprint.StartDay
        }

        $generated.Add("## $($sprint.Name)")
        $generated.Add('')
        if ($null -ne $sprint.Status) {
            $statusText = if ($null -ne $sprint.CompletedOn) {
                "$($sprint.Status)（$($sprint.CompletedOn)）"
            }
            else {
                $sprint.Status
            }
            # 行尾兩個空白＝Markdown 換行，讓狀態與 Daily 範圍併成一段
            $generated.Add("**狀態：** $statusText  ")
        }
        $generated.Add("**Daily：** $range")
        $generated.Add('')

        if ($null -ne $sprint.Summary) {
            $generated.Add("> $($sprint.Summary)")
            $generated.Add('')
        }

        if ($null -ne $sprint.Note) {
            $generated.Add("_$($sprint.Note)_")
            $generated.Add('')
        }

        if ($members.Count -gt 0) {
            $generated.AddRange([string[]](New-DailyTable -Rows @($members | ForEach-Object { $_.Row })))
        }
        else {
            $generated.Add('目前尚未開始。')
        }

        $generated.Add('')
    }
}

$footer = "共 $($dailies.Count) 個 Daily。此區塊由 ``.agents/skills/daily/scripts/Update-DailyIndex.ps1`` 自動產生，請勿手動編輯標記之間的內容。"
if ($sprints.Count -gt 0) {
    $footer += "Sprint 標題、狀態與說明請改 ``$SprintFile``。"
}

$generated.Add($footer)
$generated.Add('')
$generated.Add($endMarker)

$indexPath = Join-Path $repositoryPath $IndexFileName
$newLine = [Environment]::NewLine
$utf8WithoutBom = [Text.UTF8Encoding]::new($false)

if (Test-Path -LiteralPath $indexPath -PathType Leaf) {
    $existing = [IO.File]::ReadAllText($indexPath)
    $beginIndex = $existing.IndexOf($beginMarker, [StringComparison]::Ordinal)
    $endIndex = $existing.IndexOf($endMarker, [StringComparison]::Ordinal)

    if ($beginIndex -lt 0 -or $endIndex -lt $beginIndex) {
        throw "Index file exists but does not contain the '$beginMarker' / '$endMarker' markers: $indexPath"
    }

    $content = $existing.Substring(0, $beginIndex) +
        ($generated -join $newLine) +
        $existing.Substring($endIndex + $endMarker.Length)
}
else {
    $header = @(
        '# 每日任務目錄',
        '',
        '`backend-daily-practice` 每日練習的主題一覽。詳細流程請見 [README](README.md)。',
        ''
    )
    $content = (($header + $generated) -join $newLine) + $newLine
}

[IO.File]::WriteAllText($indexPath, $content, $utf8WithoutBom)

Write-Host "Daily index updated: $indexPath ($($dailies.Count) dailies)"
if ($pending.Count -gt 0) {
    Write-Host "Topic still missing for: $($pending -join ', ')"
}

if ($sprints.Count -gt 0) {
    Write-Host "Sprint sections rendered: $($sprints.Count) (from $sprintPath)"
}
