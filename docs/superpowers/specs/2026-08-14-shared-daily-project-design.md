# 共用 Daily 專案設計

## 目標

整個 repository 共用一個 .NET Console 專案。每次執行 `$daily` 時，只建立下一個 Daily 的程式碼與筆記檔案。只有今天的程式碼會參與編譯；較早的 Daily 檔案保留為可閱讀的歷史紀錄，不需要能夠獨立執行。

## 完成後的結構

```text
backend-daily-practice/
├─ backend-daily-practice.csproj
├─ day01/
│  ├─ Program.cs
│  └─ doc.md                 # 原本存在時才保留
├─ day02/
│  ├─ Program.cs
│  └─ doc.md
└─ day03/
   ├─ Program.cs
   └─ doc.md
```

保留既有的 `day01/Program.cs`、`day02/Program.cs` 與既有筆記。共用專案準備完成後，移除各 Daily 原有的 `.csproj`。

## 共用專案

根目錄的 `backend-daily-practice.csproj` 是唯一專案。它保留既有的 Console 設定，並透過 `EnableDefaultCompileItems=false` 停用預設的程式碼自動收集。

專案只包含一個明確的 `Compile` 項目，指向最新的 Daily：

```xml
<ItemGroup>
  <Compile Include="day03\Program.cs" />
</ItemGroup>
```

因此，較早的 `Program.cs` 仍是可供閱讀的一般 C# 檔案，但不會參與編譯。

## `$daily` 行為

Script 會繼續驗證目前操作的是 `backend-daily-practice` repository，並確認 Daily 路徑是根目錄下的直接子目錄，而且不是 reparse point。

每次執行時，script 會：

1. 找出編號最大的直接子目錄 `dayXX`。
2. 如果計算出的下一個 Daily 已經存在，拒絕覆寫。
3. 建立下一個 `dayXX` 目錄。
4. 建立包含 Console 範本輸出的最小 `Program.cs`。
5. 建立空白的 `doc.md`。
6. 將共用專案唯一的 `Compile Include` 更新為新的 `Program.cs`。
7. 執行共用專案，並要求結束碼為零。
8. 回報建立的檔案與執行結果。

它不會建立題目、答案、進度紀錄、各 Daily 專案、solution、commit 或 push。

## 建置產物

只有根目錄的共用專案能產生 `bin/` 與 `obj/`。舊 Daily 目錄不再包含專案，因此 C# Dev Kit 無法重新建立 `day01/bin`、`day02/obj` 等各 Daily 的建置產物。

根目錄的 `bin/` 與 `obj/` 是目前共用專案的正常工作快取，並會繼續由 Git 忽略。`$daily` 不保證 C# Dev Kit 會讓這些共用快取維持不存在。

遷移期間，舊 Daily 目錄中既有的 `bin/` 與 `obj/`，會使用與目前 script 相同的路徑及 reparse-point 防護後再移除。

## 失敗處理

- 移除舊的各 Daily 專案檔案前，先驗證所有路徑與共用專案。
- 如果下一個 Daily 已經存在，停止執行且不修改共用專案。
- 如果建立檔案或更新專案失敗，回報錯誤，而且不自行改用其他 Daily 編號。
- 如果 `dotnet run` 失敗，保留已建立的 Daily 並回報完整錯誤，讓使用者能夠檢查。
- 絕不自動停止 VS Code 或 C# Dev Kit。

## 驗證

驗證必須證明：

1. PowerShell script 沒有語法解析錯誤。
2. 既有 Daily 的程式碼與筆記內容維持不變。
3. Repository 內只剩一個 `.csproj`。
4. 共用專案只編譯最新 Daily 的程式碼。
5. 一開始沒有 `day03` 時，`$daily` 會建立 `day03/Program.cs` 與 `day03/doc.md`。
6. `dotnet run` 會印出 `Hello, World!` 並成功結束。
7. 等待一段時間後，舊 Daily 目錄仍然沒有 `bin/` 或 `obj/`。
8. Git 變更只包含預期的遷移、script、skill、文件與產生的 day03 檔案；不執行 commit 或 push。
