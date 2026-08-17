[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Get-Location).Path,
    [string]$IndexFileName = 'INDEX.md',
    # 剛建立、內容還是樣板的 Daily；排除後才不會在目錄留下一列空白佔位
    [string]$ExcludeDaily
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

$rows = New-Object System.Collections.Generic.List[string]
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
    $rows.Add("| [$dayLabel]($(ConvertTo-MarkdownPath $daily.Name)/) | $dateCell | $topicCell | $programCell | $noteCell |")
}

$table = New-Object System.Collections.Generic.List[string]
$table.Add('| Day | 完成日 | 主題 | 程式碼 | 筆記 |')
$table.Add('|:---:|:------:|------|:------:|------|')
if ($rows.Count -gt 0) {
    $table.AddRange($rows)
}
else {
    $table.Add('| — | — | _尚無 Daily_ | — | — |')
}

$generated = New-Object System.Collections.Generic.List[string]
$generated.Add($beginMarker)
$generated.Add('')
$generated.AddRange($table)
$generated.Add('')
$generated.Add("共 $($dailies.Count) 個 Daily。此表由 ``.agents/skills/daily/scripts/Update-DailyIndex.ps1`` 自動產生，請勿手動編輯標記之間的內容。")
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
