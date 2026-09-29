# Backend Daily — Day26
## Sprint 3 — Dictionary Baseline
### 今日主題：Dictionary<TKey, TValue> 是什麼？

---

## 1. 今天只學一件事

建立 `Dictionary<TKey, TValue>` 最基本的心智模型：

> Dictionary = 用「Key」找到對應的「Value」。

你之前已經用過：

- `List<T>`：一串資料
- `HashSet<T>`：一組不重複的值
- 今天加入 `Dictionary<TKey, TValue>`：Key → Value 對照表

---

## 2. 最小心智模型

假設我們要記錄：

| ProductId | ProductName |
|---|---|
| 101 | Laptop |
| 102 | Mouse |
| 103 | Keyboard |

如果使用 `List<Product>`：

~~~csharp
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop" },
    new Product { Id = 102, Name = "Mouse" },
    new Product { Id = 103, Name = "Keyboard" }
};
~~~

概念是：

~~~text
[
    Product,
    Product,
    Product
]
~~~

但如果我們真正需要的是：

> 「給我 ProductId，我要直接找到 ProductName。」

這時可以使用 Dictionary：

~~~csharp
var productNames = new Dictionary<int, string>
{
    { 101, "Laptop" },
    { 102, "Mouse" },
    { 103, "Keyboard" }
};
~~~

它的概念是：

~~~text
Key  → Value

101  → "Laptop"
102  → "Mouse"
103  → "Keyboard"
~~~

---

## 3. `<int, string>` 到底是什麼？

~~~csharp
Dictionary<int, string>
~~~

兩個型別分別代表：

~~~text
Dictionary<TKey, TValue>
           ↓      ↓
          int   string
           ↓      ↓
      ProductId  Name
~~~

所以：

~~~csharp
Dictionary<int, string>
~~~

代表：

> Key 必須是 `int`
> Value 必須是 `string`

---

## 4. 最基本 Lookup

Dictionary 最核心的能力是：

~~~csharp
var productNames = new Dictionary<int, string>
{
    { 101, "Laptop" },
    { 102, "Mouse" }
};

var productName = productNames[101];

Console.WriteLine(productName);
~~~

輸出：

~~~text
Laptop
~~~

這裡：

~~~csharp
productNames[101]
~~~

意思不是「第 101 個元素」。

而是：

> 找到 Key = 101 所對應的 Value。

這是今天最重要的觀念。

---

# Coding Task

建立：

~~~csharp
var productPrices = new Dictionary<int, int>
{
    { 101, 30000 },
    { 102, 1200 },
    { 103, 2500 },
    { 104, 8000 }
};
~~~

它代表：

~~~text
ProductId → Price
~~~

請你自己完成以下需求：

1. 取得 ProductId `103` 的價格。
2. 將結果存進一個變數。
3. 使用 `Console.WriteLine()` 印出：

~~~text
Product 103 price: 2500
~~~

---

## 實作要求

今天先不要使用：

- LINQ
- `foreach`
- `Contains`
- `TryGetValue`

只使用今天的新知：

~~~text
Dictionary 建立
+
Key Lookup
~~~

目標是先把最基本的 Dictionary syntax 寫熟。

---

## 驗證方式

執行：

~~~bash
dotnet run
~~~

預期：

~~~text
Product 103 price: 2500
~~~

---

## 今天完成後你應該能回答

看到：

~~~csharp
Dictionary<int, string>
~~~

你應該能說出：

1. `int` 是 Key 的型別。
2. `string` 是 Value 的型別。
3. `dictionary[key]` 是用 Key 取得 Value。
4. Dictionary 的核心模型是 `Key → Value`，不是像 List 一樣用資料順序思考。
