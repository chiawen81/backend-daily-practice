# Daily 06 — LINQ `Any`：集合中「有沒有」符合條件的資料

## 今日主題

今天只新增一個主要知識點：

> LINQ `Any()`

昨天的 `Where()` 解決的是：

> 「哪些資料符合條件？」

今天的 `Any()` 解決的是：

> 「有沒有任何一筆資料符合條件？」

---

# 1. 先建立整體心智模型

假設有一個價格集合：

~~~csharp
var prices = new List<int>
{
    80,
    120,
    200
};
~~~

如果需求是：

> 找出價格 >= 100 的所有資料

昨天學過：

~~~csharp
prices.Where(price => price >= 100);
~~~

結果概念上是：

~~~text
[120, 200]
~~~

---

但如果需求變成：

> 有沒有任何價格 >= 100？

我們其實不需要把資料全部找出來。

只需要回答：

~~~text
有 → true
沒有 → false
~~~

這就是：

~~~csharp
Any()
~~~

---

# 2. `Any()` 基本語法

~~~csharp
var hasExpensiveProduct =
    prices.Any(price => price >= 100);
~~~

拆開來看：

~~~text
prices
  ↓
Any(...)
  ↓
逐筆判斷 Lambda 條件
  ↓
只要至少一筆符合
  ↓
true
~~~

如果全部都不符合：

~~~text
false
~~~

因此：

~~~csharp
prices.Any(price => price >= 100)
~~~

回傳的不是 Collection。

它回傳的是：

~~~csharp
bool
~~~

也就是：

~~~text
true / false
~~~

---

# 3. `Where` vs `Any`

這兩個非常容易混在一起。

## Where

問題：

> 哪些資料符合？

~~~csharp
var result =
    prices.Where(price => price >= 100);
~~~

概念：

~~~text
Collection
    ↓
條件篩選
    ↓
Collection
~~~

---

## Any

問題：

> 有沒有資料符合？

~~~csharp
var result =
    prices.Any(price => price >= 100);
~~~

概念：

~~~text
Collection
    ↓
條件判斷
    ↓
bool
~~~

所以可以先記：

~~~text
Where = 哪些？
Any   = 有沒有？
~~~

---

# 4. Example

以下只是示範，不是今天 Coding Task 的答案。

~~~csharp
var scores = new List<int>
{
    60,
    75,
    90
};

var hasPassed =
    scores.Any(score => score >= 80);

Console.WriteLine(hasPassed);
~~~

預期：

~~~text
True
~~~

因為：

~~~text
60 >= 80 → false
75 >= 80 → false
90 >= 80 → true

至少一筆 true

→ Any() = true
~~~

---

# 5. Coding Task

建立商品價格集合：

~~~csharp
var prices = new List<int>
{
    80,
    120,
    200,
    50
};
~~~

請判斷：

> 是否存在「價格大於 150」的商品。

將結果存入：

~~~text
hasExpensiveProduct
~~~

最後印出：

~~~text
True
~~~

---

# 實作要求

請自己完成核心 LINQ expression。

你的程式至少需要：

~~~text
prices
Any
Lambda
Console.WriteLine
~~~

不要使用：

~~~csharp
foreach
~~~

也不要先：

~~~csharp
Where(...)
~~~

再判斷結果。

今天要直接使用 `Any()` 表達：

> 集合中是否存在符合條件的資料。

---

# 6. 完成後再做一個小 Retrieval

第一題成功後，把條件改成：

> 是否存在價格大於 300 的商品？

這次預期：

~~~text
False
~~~

不要新增資料。

只修改判斷條件。

---

# 7. 驗證方式

執行：

~~~bash
dotnet run --project day06/day06.csproj
~~~

第一個條件：

~~~text
價格 > 150
~~~

預期：

~~~text
True
~~~

第二個條件：

~~~text
價格 > 300
~~~

預期：

~~~text
False
~~~

---

# 今日真正要建立的 Pattern

今天先不用背 Pattern 名稱，只要建立這個直覺：

~~~text
需求出現：

「有沒有」
「是否存在」
「至少一筆」

        ↓

想到 Any()
~~~

例如未來 Backend 很可能看到：

~~~csharp
orders.Any(order => !order.IsPaid)
~~~

先試著用中文閱讀它：

> orders 裡面「有沒有至少一筆」符合某個條件的 order？

至於 `!order.IsPaid` 的細節今天不是重點。

---

# 心智模型更新

昨天：

~~~text
Collection
   ↓
Where(condition)
   ↓
留下符合條件的資料
   ↓
Collection
~~~

今天新增：

~~~text
Collection
   ↓
Any(condition)
   ↓
是否至少一筆符合
   ↓
bool
~~~

因此目前 LINQ 心智模型開始分成：

~~~text
              Collection
                  │
          ┌───────┴───────┐
          ▼               ▼
       Where()           Any()
          │               │
       哪些？            有沒有？
          │               │
          ▼               ▼
     Collection           bool
```

完成後把你的 `Program.cs` 或執行結果貼給我，我再做 Daily 06 review。