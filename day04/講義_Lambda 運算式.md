# Backend Daily Training — Daily 04

## 今日主題：Lambda Expression 基礎

### 今天只學一件事

看懂並寫出最基本的 C# Lambda：

~~~csharp
x => x > 100
~~~

今天**不學 LINQ `Where()`**。

因為之後你會大量看到：

~~~csharp
products.Where(product => product.Price > 100);
~~~

在碰 `Where()` 以前，我們先把裡面的：

~~~csharp
product => product.Price > 100
~~~

搞懂。

---

# 1. 先看整體位置

你目前已經會：

~~~text
List<T>
   ↓
集合裡有很多資料
   ↓
foreach
   ↓
一筆一筆拿出來處理
~~~

接下來 LINQ 會讓你開始看到：

~~~text
List<T>
   ↓
Where(...)
   ↓
需要告訴 Where：
「什麼資料算符合條件？」
   ↓
Lambda
   ↓
x => 條件
~~~

所以 Lambda 可以先建立一個很簡單的心智模型：

> 「給我一筆資料，我告訴你它符不符合條件。」

---

# 2. TypeScript → C# Mapping

這個概念其實你在 TypeScript 已經看過很多次。

TypeScript：

~~~typescript
price => price >= 100
~~~

C#：

~~~csharp
price => price >= 100
~~~

這個最簡單的情況下，兩邊長得幾乎一樣。

---

# 3. Lambda 到底在表達什麼？

看到：

~~~csharp
price => price >= 100
~~~

可以從左往右讀：

~~~text
price
  ↓
收到一個 price

=>

把它拿去做右邊的事情

price >= 100
  ↓
判斷它是否 >= 100
~~~

也就是：

~~~text
輸入
 ↓
price
 ↓
執行條件
 ↓
price >= 100
 ↓
得到 bool
~~~

例如：

~~~text
150 → true
80  → false
200 → true
~~~

---

# 4. 最小 Example

今天先示範一個「可以直接執行 Lambda」的方法。

~~~csharp
Func<int, bool> isExpensive = price => price >= 100;

Console.WriteLine(isExpensive(150));
Console.WriteLine(isExpensive(80));
~~~

執行結果：

~~~text
True
False
~~~

---

# 5. `Func<int, bool>` 今天只需要知道什麼？

今天不要深入研究 `Func`。

目前只需要把：

~~~csharp
Func<int, bool>
~~~

暫時讀成：

> 「一個接收 `int`，最後回傳 `bool` 的 function。」

所以：

~~~csharp
Func<int, bool> isExpensive = price => price >= 100;
~~~

可以理解成：

~~~text
輸入 int
   ↓
Lambda
   ↓
price >= 100
   ↓
輸出 bool
~~~

`Func` 本身未來會再正式處理。

今天它只是讓我們可以單獨練習 Lambda。

---

# 6. Coding Task

建立以下商品價格：

~~~csharp
List<int> prices = new()
{
    80,
    120,
    200,
    50
};
~~~

請建立一個 Lambda：

~~~csharp
Func<int, bool> isHighPrice = ???
~~~

條件：

> price 大於等於 100 時回傳 `true`，否則回傳 `false`。

接著使用你之前學過的 `foreach`：

~~~csharp
foreach (...)
{
    ...
}
~~~

逐筆執行：

~~~csharp
isHighPrice(...)
~~~

並印出每個價格以及判斷結果。

---

# 7. 實作要求

請自己完成：

1. 建立 `List<int> prices`
2. 建立 `isHighPrice` Lambda
3. 使用 `foreach`
4. 每次把目前的 price 傳入 `isHighPrice`
5. 印出 price 與判斷結果

今天主要的新東西只有：

~~~csharp
price => price >= 100
~~~

以下內容都是 Retrieval：

- `List<int>`
- `new()`
- Collection Initializer
- `foreach`

---

# 8. 預期結果

輸出內容至少能看出：

~~~text
80 False
120 True
200 True
50 False
~~~

格式不用完全相同。

只要能正確判斷即可。

---

# 9. 驗證方式

執行：

~~~bash
dotnet run --project day04/day04.csproj
~~~

確認：

~~~text
80  → False
120 → True
200 → True
50  → False
~~~

---

# 10. 今天刻意不要做的事情

不要使用：

~~~csharp
Where()
~~~

不要讓 AI 幫你把題目改成 LINQ。

今天的目的不是「快速篩選資料」。

而是確認看到：

~~~csharp
price => price >= 100
~~~

你知道：

~~~text
price            → 輸入
=>               → Lambda
price >= 100     → 執行的條件
結果             → bool
~~~

---

# 心智模型更新

之前：

~~~text
foreach
   ↓
自己控制迴圈
   ↓
拿到每一筆資料
   ↓
自己寫 if 判斷
~~~

今天加入：

~~~text
Lambda
   ↓
把「判斷規則」本身寫成一個 expression

price => price >= 100
~~~

目前先把它理解成：

> 「給我一個 price，我告訴你它是不是 >= 100。」

下一階段你會開始看到：

~~~text
Collection
    +
Lambda
    ↓
LINQ
~~~

到時候像：

~~~csharp
prices.Where(price => price >= 100)
~~~

你就不會把整行當成一坨新的魔法。

你會看成：

~~~text
prices
   ↓
Where
   ↓
判斷規則
   ↓
price => price >= 100
~~~

---

# 完成條件

今天完成後，你應該能自己回答：

> `price => price >= 100`

左邊的 `price` 是什麼？

右邊的 `price >= 100` 又是在做什麼？

能回答＋程式能正確執行，Daily 04 就完成。
