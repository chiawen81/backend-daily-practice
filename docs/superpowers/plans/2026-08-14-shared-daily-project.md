# 共用 Daily 專案實作計畫

> **給代理工作者：** 必須使用子技能：建議使用 `superpowers:subagent-driven-development`，或使用 `superpowers:executing-plans`，依序實作本計畫中的每一項任務。各步驟使用核取方塊（`- [ ]`）追蹤。

**目標：** 將各 Daily 的 Console 專案改為一個根目錄 Console 專案，而且只編譯今天的 `Program.cs`；`$daily` 負責建立下一個程式碼與筆記檔案，並執行共用專案完成驗證。

**架構：** `backend-daily-practice.csproj` 是唯一專案，並停用預設的程式碼自動收集。它唯一的 `Compile` 項目指向最新的 `dayXX/Program.cs`；較早的 Daily 程式碼保留供閱讀，但不參與編譯。Repository 內的 PowerShell script 會建立下一組檔案、切換明確指定的編譯項目，然後執行根目錄專案。

**技術堆疊：** PowerShell 7、.NET 10 Console 專案、MSBuild 專案 XML、Git 唯讀驗證。

## 全域限制

- 完整保留既有的 `day01/Program.cs`、`day02/Program.cs` 與 `day02/doc.md` 內容。
- 不建立題目、答案、課綱、進度紀錄、solution 或各 Daily 專案。
- 不自動停止 VS Code 或 C# Dev Kit。
- 不 commit 或 push。
- 使用者已刪除 `day03`；最後的實際 `$daily` 驗證必須重新建立 `day03/Program.cs` 與 `day03/doc.md`。
- 允許根目錄的 `bin/` 與 `obj/` 作為工作快取；舊 Daily 目錄不得包含 `bin/`、`obj/` 或 `.csproj`。

---

## 檔案結構

- 建立：`backend-daily-practice.csproj` — 唯一的 Console 專案，以及目前程式碼的明確選擇器。
- 建立：`.agents/skills/daily/tests/Test-New-DailyExercise.ps1` — 共用專案 `$daily` 流程的隔離行為測試。
- 修改：`.agents/skills/daily/scripts/New-DailyExercise.ps1` — 建立程式碼／筆記檔案、更新根目錄專案並執行。
- 修改：`.agents/skills/daily/SKILL.md` — 說明共用專案行為與回報契約。
- 刪除：`day01/day01.csproj` — 移除已不再使用的各 Daily 專案。
- 刪除：`day02/day02.csproj` — 移除已不再使用的各 Daily 專案。
- 在最後驗證時建立：`day03/Program.cs`、`day03/doc.md` — 由更新後的 `$daily` script 產生。
- 保留：`day01/Program.cs`、`day02/Program.cs`、`day02/doc.md` — 歷史練習內容。

### 任務 1：加入隔離且預期失敗的流程測試

**檔案：**
- 建立：`.agents/skills/daily/tests/Test-New-DailyExercise.ps1`
- 測試：`.agents/skills/daily/tests/Test-New-DailyExercise.ps1`

**介面：**
- 輸入：`.agents/skills/daily/scripts/New-DailyExercise.ps1 -RepositoryRoot <path>`。
- 輸出：只有在 script 建立 `day03/Program.cs` 與 `day03/doc.md`、將根目錄專案切換到 day03、保留舊內容、不建立各 Daily 專案且成功執行時，才回傳結束碼零。

- [ ] **步驟 1：撰寫隔離行為測試**

建立一個最後一層目錄名稱恰好為 `backend-daily-practice` 的暫存目錄。將受測 script 複製到測試環境，建立 `day01/Program.cs`、`day02/Program.cs`、`day02/doc.md`，以及下列根目錄專案：

```xml
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
```

執行複製後的 script、擷取所有輸出，並驗證：

```powershell
Assert-True ($exitCode -eq 0) 'script exits successfully'
Assert-True (Test-Path "$repoRoot\day03\Program.cs" -PathType Leaf) 'day03 Program.cs exists'
Assert-True (Test-Path "$repoRoot\day03\doc.md" -PathType Leaf) 'day03 doc.md exists'
Assert-False (Test-Path "$repoRoot\day03\day03.csproj") 'no per-Day project exists'
Assert-Equal 'Console.WriteLine("day01 history");' (Get-Content "$repoRoot\day01\Program.cs" -Raw).Trim() 'day01 is preserved'
Assert-Equal 'Console.WriteLine("day02 history");' (Get-Content "$repoRoot\day02\Program.cs" -Raw).Trim() 'day02 is preserved'
Assert-Equal 'day02 notes' (Get-Content "$repoRoot\day02\doc.md" -Raw).Trim() 'day02 notes are preserved'
Assert-Equal 'day03\Program.cs' $compileNode.Include 'shared project selects day03'
Assert-Match 'Hello, World!' ($output -join [Environment]::NewLine) 'new Daily runs successfully'
```

在 `finally` 中，先確認正規化後的路徑位於 `[IO.Path]::GetTempPath()` 下，再只刪除具有唯一名稱的暫存測試根目錄。

- [ ] **步驟 2：執行測試，確認目前實作會失敗**

執行：

```powershell
pwsh -NoProfile -File .agents\skills\daily\tests\Test-New-DailyExercise.ps1
```

預期：結束碼非零，因為目前 script 會建立 `day03/day03.csproj`、不會建立 `day03/doc.md`，也不會切換共用根目錄專案。

### 任務 2：實作並記錄共用專案的 `$daily` 流程

**檔案：**
- 修改：`.agents/skills/daily/scripts/New-DailyExercise.ps1`
- 修改：`.agents/skills/daily/SKILL.md`
- 測試：`.agents/skills/daily/tests/Test-New-DailyExercise.ps1`

**介面：**
- 輸入：`-RepositoryRoot`、根目錄的 `backend-daily-practice.csproj`，以及直接位於根目錄下的 `dayXX` 目錄。
- 輸出：下一個 `dayXX/Program.cs`、`dayXX/doc.md`、根目錄專案唯一的明確 `Compile Include`、`dotnet run` 的主控台輸出，以及結束碼零。

- [ ] **步驟 1：異動前先驗證共用專案**

解析 `backend-daily-practice.csproj`，要求它是 repository 根目錄下直接存在的一般檔案；將它解析為 XML；要求 `EnableDefaultCompileItems` 等於 `false`；並要求恰好只有一個 `/Project/ItemGroup/Compile` 節點，而且其 `Include` 等於最新 Daily 的相對 `Program.cs` 路徑。

路徑比較使用不區分大小寫的 ordinal 比較，並拒絕 project reparse point。如果驗證失敗，必須在建立下一個 Daily 前拋出錯誤。

- [ ] **步驟 2：將各專案建立流程改為只建立兩個檔案**

建立已驗證的下一個 Daily 目錄，然後將以下內容原樣寫入 `Program.cs`：

```csharp
Console.WriteLine("Hello, World!");
```

同時建立長度為零、UTF-8 編碼的 `doc.md`。不得呼叫 `dotnet new`，也不得在 Daily 目錄內建立 `.csproj`。

- [ ] **步驟 3：切換共用專案並執行**

將唯一編譯節點的 `Include` 屬性設為 `dayXX\Program.cs`，儲存根目錄專案，然後執行：

```powershell
dotnet run --project "$repositoryPath\backend-daily-practice.csproj"
```

要求 `$LASTEXITCODE -eq 0`。回報建立的程式碼檔案、筆記檔案、選取的程式碼、執行輸出與最後的 Daily 目錄。

- [ ] **步驟 4：更新 skill 契約**

修改 description 與執行程序，使 skill 明確說明：它會在共用 Console 專案中初始化下一個 Daily，只建立 `Program.cs` 與 `doc.md`，切換唯一的編譯項目，執行根目錄專案，並回報精確結果。保留不得產生題目、solution、commit 與 push 的限制。

- [ ] **步驟 5：執行隔離測試，確認通過**

執行：

```powershell
pwsh -NoProfile -File .agents\skills\daily\tests\Test-New-DailyExercise.ps1
```

預期：結束碼為 0，而且摘要顯示所有驗證皆通過。

- [ ] **步驟 6：解析並靜態檢查 PowerShell 檔案**

使用 PowerShell parser 檢查實作與測試 script。預期：兩個檔案的語法解析錯誤皆為零。

### 任務 3：遷移 repository 並執行真實的 `$daily` 驗收測試

**檔案：**
- 建立：`backend-daily-practice.csproj`
- 刪除：`day01/day01.csproj`
- 刪除：`day02/day02.csproj`
- 透過 `$daily` 建立：`day03/Program.cs`
- 透過 `$daily` 建立：`day03/doc.md`
- 驗證：全域限制中列出的所有檔案

**介面：**
- 輸入：已通過測試的 `$daily` script，以及既有 day01/day02 歷史內容。
- 輸出：選取 day03 且可執行的實際共用專案結構。

- [ ] **步驟 1：記錄內容保留證據並驗證清理目標**

計算 `day01/Program.cs`、`day02/Program.cs` 與 `day02/doc.md` 的 hash。解析舊 Daily 中每個既有 `bin/` 與 `obj/` 的實際路徑，要求它們是直接位於 `dayXX` 子目錄下的一般目錄，並在刪除前拒絕 reparse point。

- [ ] **步驟 2：刪除舊專案前，先建立根目錄共用專案**

使用核准的 XML 結構建立 `backend-daily-practice.csproj`，最初選取 `day02\Program.cs`。執行：

```powershell
dotnet run --project .\backend-daily-practice.csproj
```

預期：結束碼為 0，並顯示既有的 day02 輸出。

- [ ] **步驟 3：移除已不再使用的各 Daily 專案與建置產物**

只刪除 `day01/day01.csproj`、`day02/day02.csproj`，以及通過驗證、直接位於舊 Daily 目錄下的 `bin/` 或 `obj/`。不得刪除或修改其中的程式碼與筆記檔案。

- [ ] **步驟 4：驗證保留內容的 hash 與專案數量**

重新計算三個 hash 並要求完全相同。執行：

```powershell
rg --files -g '*.csproj'
```

預期：結果恰好只有 `backend-daily-practice.csproj`。

- [ ] **步驟 5：執行真實的 `$daily` 指令**

從 repository 根目錄執行 repository 內的 skill 指令：

```powershell
$repoRoot = (git rev-parse --show-toplevel).Trim()
& (Join-Path $repoRoot '.agents\skills\daily\scripts\New-DailyExercise.ps1') -RepositoryRoot $repoRoot
```

預期：建立 `day03/Program.cs` 與 `day03/doc.md`、將根目錄的編譯項目改為 `day03\Program.cs`、印出 `Hello, World!`，並以結束碼零完成。

- [ ] **步驟 6：執行延遲檔案系統與建置驗證**

等待至少八秒後，驗證：

```powershell
Test-Path day01\bin  # False
Test-Path day01\obj  # False
Test-Path day02\bin  # False
Test-Path day02\obj  # False
dotnet run --project .\backend-daily-practice.csproj
```

預期：所有舊建置產物的檢查結果都是 false；最後一次執行會印出 `Hello, World!`，並以結束碼零完成。

- [ ] **步驟 7：在不 commit 的前提下驗證變更範圍**

執行 `git diff --check`、`git status --short`，並檢查完整 diff。確認變更只包含已核准的遷移、skill、script、測試、規格／計畫文件，以及產生的 day03 檔案。不 stage、commit 或 push。
