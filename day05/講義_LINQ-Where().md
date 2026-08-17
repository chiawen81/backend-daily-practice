# Daily 05 — LINQ `Where`：集合篩選

## 今日主題

今天只學一個新東西：

> 使用 LINQ 的 `Where`，從 Collection 中篩選出符合條件的資料。

今天會把昨天學過的 Lambda：

~~~csharp
price => price >= 100
~~~

真正放進 LINQ 使用。

---

# 1. 先看整體流程

假設我們有：

~~~text
prices
[50, 120, 80, 200, 150]
        │
        │ Where(price => price >= 100)
        ▼
[120, 200, 150]
~~~

`Where` 的工作就是：

> 一筆一筆檢查 Collection，只留下條件成立的資料。

---

# 2. `Where` 是什麼？

基本語法：

~~~csharp
collection.Where(x => 條件);
~~~

例如：

~~~csharp
var prices = new List<int>
{
    50,
    120,
    80,
    200
};

var expensivePrices = prices.Where(price => price >= 100);
~~~

這裡可以拆成：

~~~text
prices
  │
  └─ 原始 Collection

.Where(...)
  │
  └─ 我要篩選資料

price => price >= 100
  │
  └─ 昨天學過的 Lambda
~~~

`Where` 會把每一筆資料依序交給 Lambda。

例如第一筆：

~~~text
price = 50

50 >= 100
→ false
→ 不留下
~~~

第二筆：

~~~text
price = 120

120 >= 100
→ true
→ 留下
~~~

---

# 3. 跟昨天的 Lambda 接起來

昨天我們學到：

~~~csharp
price => price >= 100
~~~

它代表一段「可執行的判斷行為」。

今天：

~~~csharp
prices.Where(price => price >= 100)
~~~

可以理解成：

~~~text
Collection
    ↓
Where
    ↓
把每一筆資料交給 Lambda
    ↓
Lambda 回傳 true / false
    ↓
true  → 留下
false → 排除
~~~

所以 Lambda 並不是自己主動去找資料。

是 `Where` 在遍歷 Collection 時，反覆呼叫這個 Lambda。

---

# 4. TypeScript 對照

這跟 TypeScript 的 `filter()` 很接近。

TypeScript：

~~~typescript
const expensivePrices =
    prices.filter(price => price >= 100);
~~~

C#：

~~~csharp
var expensivePrices =
    prices.Where(price => price >= 100);
~~~

可以先建立這個 mapping：

~~~text
TypeScript filter()
        ↓
C# LINQ Where()
~~~

兩者都是：

> 根據條件篩選 Collection。

---

# 5. 最小 Example

~~~csharp
var scores = new List<int>
{
    60,
    85,
    40,
    95
};

var passedScores = scores.Where(score => score >= 60);

foreach (var score in passedScores)
{
    Console.WriteLine(score);
}
~~~

預期輸出：

~~~text
60
85
95
~~~

注意：

今天不需要研究 `Where` 回傳的實際型別。

目前先掌握：

> `Where` 產生一組「篩選後可以繼續遍歷的結果」。

之後遇到 `IEnumerable<T>` 時再正式建立它的心智模型。

---

# 6. Coding Task

## 情境

現在有一組商品價格：

~~~csharp
var prices = new List<int>
{
    45,
    120,
    80,
    250,
    99,
    180
};
~~~

請找出：

> **價格大於等於 100 的所有商品價格**

並把結果逐筆印出來。

---

# 7. 實作要求

請建立今天的 `Program.cs`，自己完成：

1. 建立上面的 `prices`
2. 使用 `Where`
3. Lambda 條件為「價格 >= 100」
4. 把篩選結果存進一個 `var`
5. 使用 `foreach` 印出所有結果

今天請不要使用：

~~~csharp
if
~~~

來自己做篩選。

目標是練習：

~~~text
Collection
    ↓
Where
    ↓
Lambda
    ↓
篩選結果
    ↓
foreach
~~~

---

# 8. 預期結果

執行：

~~~bash
dotnet run --project day05/day05.csproj
~~~

應該看到：

~~~text
120
250
180
~~~

---

# 9. 今天的 Retrieval

今天沒有重新教以下內容：

- `var`
- `List<T>`
- Collection Initializer
- `foreach`
- Lambda

這些都是前幾天已經碰過的知識。

如果忘記 syntax，可以先自己回想或翻前幾天的實作。

真的卡住再回來要：

> 提示1

---

# 10. 今天完成後應建立的心智模型

原本：

~~~text
Lambda
= 可以裝「可執行行為」
~~~

今天更新成：

~~~text
Collection
    ↓
Where
    ↓
Lambda 負責判斷每一筆資料
    ↓
true  → 留下
false → 排除
    ↓
篩選後的資料
~~~

以及 TS → C# mapping：

~~~text
TypeScript
array.filter(x => condition)

        ↓

C#
collection.Where(x => condition)
~~~

---

# 11. Backend Coding Pattern

今天第一次正式接觸：

## Collection Filtering

~~~csharp
items.Where(x => condition);
~~~

用途：

> 從一組資料中，只留下符合條件的資料。

這會是之後大量 LINQ Pattern 的基礎。

今天先只練這一層，不加入 `Any`、`Select` 或其他 LINQ API。