# Backend Daily Practice

個人後端工程 coding gym。

📑 **每日任務主題一覽 → [INDEX.md](INDEX.md)**

## 目標

* 每日約 10～15 分鐘實際 coding
* 提升獨立 coding 能力
* 提升 AI-generated code review 能力
* 累積常見 Backend Coding Patterns

## 目前主要學習

* C#
* LINQ
* ASP.NET Core

未來可能加入 SQL、Oracle 等後端主題。

課程 syllabus、每日題目與學習進度由 `.NET系統學習` 系統負責；本 repository 只保存實際 coding exercises。

## 每日流程

1. **拿題目、建立環境**：<br>
  (1) 到 ChatGPT `.NET系統學習` Project 開新 Chat，輸入「今天的題目」。<br>
  (2) 在 VSCode 打 `$daily`（Codex）或 `/daily`（Claude Code）產生專案環境<br>
  (3) 把 (1) 的題目貼到 (2) 生成後的檔案<br>
3. **學習新知**：閱讀今日教學與題目；新語法第一次出現時會先介紹與示範。
4. **實作**：在 VS Code 自己實作並使用 `dotnet run` 驗證結果。
5. **困難處理**：卡住時依序取得 `提示 1` → `提示 2` → 完整答案。<br>
   ※ 請務必在 `.NET系統學習` Project 進行，才能讓 ChatGPT 取得記憶更新 
6. **ChatGPT 驗收**：完成後將程式碼交給 ChatGPT Code Review，依 Review 修正。
7. **命名筆記**：把當天筆記命名成 `講義_<主題>.md`，這個檔名就是 [INDEX.md](INDEX.md) 目錄上顯示的主題。
8. **收工**：確認完成後 commit + push 到 GitHub。

> **目錄不用手動維護。** [INDEX.md](INDEX.md) 在每次建立新環境時自動重建，並會跳過當天剛建立、內容還是樣板的那一天 —— 所以今天的主題會在**隔天建環境時**自動補上。
>
> 想當天就看到，可以打 `$daily 更新目錄`（Codex）或 `/daily 更新目錄`（Claude Code），或直接跑：
>
> ```powershell
> $repoRoot = (git rev-parse --show-toplevel).Trim()
> & (Join-Path $repoRoot '.agents\skills\daily\scripts\Update-DailyIndex.ps1') -RepositoryRoot $repoRoot
> ```
>
> 表格由腳本產生，請勿手動編輯 `DAILY-INDEX` 標記之間的內容（標記外可自由加註）。

```text
         取得題目、建環境
                ↓
             學習新知
                ↓
              實作
                ↓
        Chatgpt 做 Code Review
                ↓
          完成修正、收尾
                ↓
         更新 Github Repo
                ↓
   （隔天建環境時自動更新 INDEX.md）
```
