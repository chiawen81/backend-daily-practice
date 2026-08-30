---
name: daily
description: Use when initializing the next Daily source and note files in the shared .NET Console project in the backend-daily-practice repository, or when refreshing the INDEX.md table of Daily topics.
---

# Daily Exercise Initialization

The scripts are shared with the Codex-side skill and live in `.agents/skills/daily/scripts/`. Never duplicate or reimplement them here.

Initialize only the next coding environment. Do not generate an exercise, syllabus, learning progress, solution, per-Day project, commit, or push.

1. Resolve the Git repository root and confirm it is `backend-daily-practice`.
2. Run the shared script from the repository root:

```powershell
$repoRoot = (git rev-parse --show-toplevel).Trim()
& (Join-Path $repoRoot '.agents\skills\daily\scripts\New-DailyExercise.ps1') -RepositoryRoot $repoRoot
```

3. Let the script exclusively determine the latest `dayXX`, validate the shared root project, create the next `Program.cs` and `doc.md`, switch the project's single `Compile` item, run the shared project, and refresh `INDEX.md`. The refresh deliberately excludes the Daily just created — its files are still templates, so it is picked up the next time an environment is created.
4. Stop and report the script error without guessing, deleting additional files, or modifying an existing Daily.
5. Report the created source and note files, selected shared-project source, `dotnet run` result, and any Daily whose topic is still missing from `INDEX.md`.

Never pass `-ExcludeDaily` when the request is a plain index refresh; it exists only for the creation path above.

## Refreshing the index only

When the request is to update `INDEX.md` without creating a Daily — typically after the day's notes are written, before committing — run only:

```powershell
$repoRoot = (git rev-parse --show-toplevel).Trim()
& (Join-Path $repoRoot '.agents\skills\daily\scripts\Update-DailyIndex.ps1') -RepositoryRoot $repoRoot
```

The script rewrites only the content between the `DAILY-INDEX:BEGIN` / `DAILY-INDEX:END` markers. Never hand-edit that region. A Daily's topic is resolved in this order: a `講義_<主題>.md` file name, a `Daily NN — <主題>` header comment in `Program.cs`, then the first Markdown heading in any note. If all three are absent the row shows `（待補）`, which is a signal to name the note file — not to edit `INDEX.md`.

## Sprint 分區

`INDEX.md` 依 Sprint 分區顯示。Sprint 標題、狀態、起始 Daily 與重點說明全部維護在 `.agents/skills/daily/config/sprints.json`，腳本每次重跑都會依這份設定重建區塊，不會被覆蓋或消失。

每筆 Sprint 的欄位：`name`、`startDay` 為必填，`status`、`completedOn`、`summary`、`note` 為選填。Sprint 的結束日由「下一個 Sprint 的 `startDay`」推得，最後一個 Sprint 永遠開放，所以實際題數增減不需要改設定或腳本。新增下一個 Sprint 時，只要在這個檔案追加一筆並填上它的 `startDay`。

尚無 Daily 的 Sprint 仍會顯示標題、狀態與重點，表格位置改印「目前尚未開始。」。設定檔不存在時，腳本會退回原本的單一表格。
