# .NET Backend Daily — Daily 03

## 今日主題

**Collection（集合）是什麼？**

今天只建立一個主要新知：

> Collection 是「一個變數裡管理多筆同類資料」的概念。

預計時間：10～15 分鐘。

---

# 1. 為什麼需要 Collection？

假設現在有三個商品價格。

目前你已經會這樣寫：

~~~csharp
int price1 = 100;
int price2 = 200;
int price3 = 300;
~~~

三筆資料還勉強可以。

但如果今天有：

~~~text
1000 個商品價格
~~~

總不能寫：

~~~csharp
int price1 = 100;
int price2 = 200;
int price3 = 300;
// ...
int price1000 = 999;
~~~

我們需要一個東西，可以：

> 用一個變數管理「一組資料」。

這就是 Collection（集合）要解決的問題。

---

# 2. Collection 是「概念」，不是某一個特定語法

這點很重要。

**Collection 不是 `List` 的另一個名字。**

Collection 是比較大的概念：

~~~text
Collection
│
├── List<T>
├── Dictionary<TKey, TValue>
├── Array
└── ...
~~~

它們都是用來管理「一組資料」的不同工具。

現階段不用記住這些種類。

目前只要建立：

~~~text
單一變數
→ 保存一筆資料

Collection
→ 管理多筆資料
~~~

---

# 3. 今天先認識 `List<T>`

C# Backend 很常看到：

~~~csharp
List<int> prices = new List<int>
{
    100,
    200,
    300
};
~~~

這代表：

~~~text
prices
↓
一個 List
↓
裡面存放 int

100
200
300
~~~

---

# 4. `List<int>` 到底在說什麼？

拆開看：

~~~csharp
List<int>
~~~

可以先理解成：

> 一個「只能放 int」的 List。

例如：

~~~csharp
List<int> prices
~~~

表示：

~~~text
prices 是一個 List
而且裡面的元素是 int
~~~

如果改成：

~~~csharp
List<string> productNames
~~~

就表示：

~~~text
productNames 是一個 List
而且裡面的元素是 string
~~~

---

# 5. TypeScript 對照

你在 TypeScript 比較容易看到：

~~~typescript
const prices: number[] = [100, 200, 300];

const productNames: string[] = [
  "Keyboard",
  "Mouse",
  "Monitor"
];
~~~

概念上可以先這樣 mapping：

~~~text
TypeScript                  C#

number[]              →     List<int>

string[]              →     List<string>
~~~

注意：

這不是說 TypeScript Array 和 C# List 完全相同。

目前只是利用你熟悉的 TypeScript syntax 建立：

> 「一個變數裡面有很多筆同類資料」

這個 Collection 心智模型。

---

# 6. `new` 是什麼？

你 Day 01 已經碰過：

~~~csharp
new List<int>
{
    100,
    200,
    300
};
~~~

今天先建立最小理解：

> `new` 代表建立一個新的物件。

因此：

~~~csharp
new List<int>
~~~

可以暫時理解成：

> 建立一個新的 `List<int>`。

`new` 之後還會搭配 class / object / constructor 正式學習。

今天不用深入 OOP。

---

# 7. `{ ... }` 裡面是什麼？

~~~csharp
List<int> prices = new List<int>
{
    100,
    200,
    300
};
~~~

這裡：

~~~csharp
{
    100,
    200,
    300
}
~~~

是在建立 List 時，直接放入初始資料。

這種寫法稱為：

~~~text
Collection Initializer
~~~

今天只需要會看懂，不要求背名稱。

---

# 8. `var` 可以和 List 一起使用

你剛剛補充過 `var`。

所以：

~~~csharp
List<int> prices = new List<int>
{
    100,
    200,
    300
};
~~~

也可以寫成：

~~~csharp
var prices = new List<int>
{
    100,
    200,
    300
};
~~~

Compiler 可以從右邊知道：

~~~csharp
new List<int>
~~~

所以推論：

~~~text
prices 的型別 = List<int>
~~~

這就是前一個知識點開始和今天的 Collection 接起來。

---

# 9. Coding Task

請建立兩組 Collection。

第一組：

~~~text
變數名稱：prices
型別：List<int>

資料：
100
250
500
~~~

第二組：

~~~text
變數名稱：productNames
型別：List<string>

資料：
Keyboard
Mouse
Monitor
~~~

## 實作要求

### prices

請使用完整型別宣告：

~~~csharp
List<int> prices = ...
~~~

### productNames

請使用剛剛複習過的：

~~~csharp
var productNames = ...
~~~

---

# 10. 印出資料

Day 01 已經碰過 `foreach`。

今天不用重新學 `foreach`，只拿它來觀察 Collection 裡面的資料。

你可以參考這個**不同情境的範例**：

~~~csharp
var scores = new List<int>
{
    80,
    90,
    100
};

foreach (int score in scores)
{
    Console.WriteLine(score);
}
~~~

請你自己把這個 Pattern 套用到：

~~~text
prices
productNames
~~~

不要直接複製變數名稱。

---

# 11. 預期結果

執行：

~~~bash
dotnet run --project day03/day03.csproj
~~~

輸出應包含：

~~~text
100
250
500
Keyboard
Mouse
Monitor
~~~

---

# 12. 今天真正要會的是什麼？

不是背：

~~~csharp
List<int>
~~~

而是建立這個心智模型：

~~~text
我有一筆資料
↓
普通變數

我有很多筆同類資料
↓
需要某種 Collection

其中一種常見選擇
↓
List<T>
~~~

以及看懂：

~~~csharp
List<int>
~~~

代表：

~~~text
List 裡面的元素型別是 int
~~~

---

# 13. 今天先不要做的事

今天**不學**：

~~~text
Add()
Remove()
Count
Dictionary
LINQ
Where
Any
~~~

因為目前最重要的是先把：

~~~text
Collection
↓
List<T>
↓
多筆同類資料
~~~

這個 baseline 建起來。

後面的 Daily 再逐步操作 Collection。

---

# 卡住時

依序回來跟我說：

~~~text
提示1
~~~

如果還是不行：

~~~text
提示2
~~~

最後才是：

~~~text
完整答案
~~~

完成後把 `Program.cs` 貼回來，我們確認你對 Collection / `List<T>` 的理解。

---

<br><br>

# ※補充筆記：今天的心智模型更新

## 1. Collection 到底是什麼？

Collection 本身先把它理解成一個**概念／分類**：

> 用來管理一組資料。

~~~text
Collection
│
├── List<T>
├── Array
├── Dictionary<TKey, TValue>
└── ...
~~~

所以：

~~~text
Collection
→ 管理一組資料的概念

List<T>
→ 一種具體的 Collection
→ 同時也是一個具體型別
~~~

不要把：

~~~text
Collection = List
~~~

兩者畫上等號。

---

## 2. `List<T>` 的 `<T>` 是什麼？

`T` 可以先理解成：

> 這個 List 裡面要放什麼型別的資料。

例如：

~~~csharp
List<int> prices;
~~~

代表：

~~~text
prices
↓
是一個 List
↓
裡面的元素限定為 int
~~~

而：

~~~csharp
List<string> productNames;
~~~

代表：

~~~text
productNames
↓
是一個 List
↓
裡面的元素限定為 string
~~~

因此：

~~~csharp
var prices = new List<int>
{
    100,
    250,
    500
};
~~~

不能突然加入：

~~~csharp
"Keyboard"
~~~

因為這個 List 已經指定元素型別為 `int`。

---

## 3. `new` 的心智模型

今天看到：

~~~csharp
new List<int>()
~~~

目前先理解成：

> 建立一個新的 `List<int>` instance。

流程：

~~~text
List<int>
↓
一個具體型別

new List<int>()
↓
建立這個型別的新 instance
~~~

所以 `new` 並不是「Collection 專用語法」。

例如未來也可能看到：

~~~csharp
new Product()
new User()
new Order()
~~~

它們背後都有：

~~~text
某個型別
↓
new
↓
建立新的 instance
~~~

目前不需要深入 constructor / class / OOP 細節。

---

## 4. `var` 與 `new()` 的型別推論方向

這兩個剛好方向相反。

### `var`

~~~csharp
var prices = new List<int>();
~~~

~~~text
右邊：new List<int>()
        ↓
Compiler 知道型別是 List<int>
        ↓
左邊：var 被推論為 List<int>
~~~

簡記：

~~~text
var
右 → 左
~~~

### `new()`

~~~csharp
List<int> prices = new();
~~~

~~~text
左邊：List<int>
        ↓
Compiler 已經知道目標型別
        ↓
右邊：new() 推論為 new List<int>()
~~~

簡記：

~~~text
new()
左 → 右
~~~

因此這樣不行：

~~~csharp
var prices = new();
~~~

因為：

~~~text
var：
「看右邊才知道型別」

new()：
「看左邊才知道型別」

結果
↓
兩邊都沒有提供型別資訊
↓
Compiler 無法判斷
~~~

---

## 5. C# 的 string 與 char

這點和 JavaScript / TypeScript 不同。

C#：

~~~csharp
"ABC"
~~~

代表：

~~~text
string
~~~

而：

~~~csharp
'A'
~~~

代表：

~~~text
char（單一字元）
~~~

所以：

~~~csharp
string productName = "Keyboard";
char grade = 'A';
~~~

但：

~~~csharp
'Keyboard'
~~~

不合法。

因為單引號代表 `char`，而 `char` 只能表示單一字元。

---

# 今日心智模型總整理

~~~text
Collection
│
│  管理一組資料的概念
│
└── List<T>
      │
      │  一種具體 Collection
      │  同時也是具體型別
      │
      ├── List<int>
      │      └── 元素限定為 int
      │
      └── List<string>
             └── 元素限定為 string


List<int>
    ↓
具體型別

new List<int>()
    ↓
建立一個 List<int> instance


型別推論：

var prices = new List<int>();
     ←──────────────
       右邊推左邊

List<int> prices = new();
──────────────→
左邊推右邊


字串／字元：

"ABC" → string
'A'   → char
~~~

## 今天應該留下的核心認知

1. Collection 是「管理一組資料」的概念，不等於 `List`。
2. `List<T>` 是一種具體 Collection，也是一個具體型別。
3. `List<int>` 代表 List 裡的元素限定為 `int`。
4. `new List<int>()` 是建立一個新的 `List<int>` instance。
5. `new` 不是 Collection 專用；它與建立 instance 有關。
6. `var` 可以從右邊推論型別；`new()` 可以利用左邊的型別資訊。
7. C# 的 `"ABC"` 是 `string`，`'A'` 是 `char`。