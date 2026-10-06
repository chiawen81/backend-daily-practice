# Day27 — Dictionary 安全 Lookup

## 今日主題

使用 `Dictionary<TKey, TValue>` 依照 Key 查找資料，並安全處理「Key 不存在」的情況。

今天只新增一個主要知識點：

> `TryGetValue()`

---

# 1. 為什麼需要「安全 Lookup」？

假設有：

~~~csharp
var productNames = new Dictionary<int, string>
{
    { 101, "Laptop" },
    { 102, "Mouse" },
    { 103, "Keyboard" }
};
~~~

如果我們確定 Key 一定存在，可以：

~~~csharp
var productName = productNames[101];

Console.WriteLine(productName);
~~~

結果：

~~~text
Laptop
~~~

但如果：

~~~csharp
var productName = productNames[999];
~~~

`999` 不存在，程式會直接拋出 Exception。

所以當 Key **可能不存在**時，需要安全 Lookup。

---

# 2. TryGetValue()

Dictionary 提供：

~~~csharp
dictionary.TryGetValue(key, out value)
~~~

它會同時做兩件事：

1. 檢查 Key 是否存在
2. 如果存在，把找到的 Value 放進 `out` 變數

最小範例：

~~~csharp
var productNames = new Dictionary<int, string>
{
    { 101, "Laptop" },
    { 102, "Mouse" }
};

var isFound = productNames.TryGetValue(101, out var productName);

if (isFound)
{
    Console.WriteLine(productName);
}
else
{
    Console.WriteLine("Product not found");
}
~~~

結果：

~~~text
Laptop
~~~

---

# 3. `out var` 先建立最小心智模型

今天不用深入研究 `out`。

先把：

~~~csharp
productNames.TryGetValue(101, out var productName);
~~~

理解成：

~~~text
拿 101 去 Dictionary 查
        ↓
找到？
├─ Yes → 回傳 true，並把 Value 放進 productName
└─ No  → 回傳 false
~~~

因此：

~~~csharp
var isFound = productNames.TryGetValue(
    101,
    out var productName
);
~~~

最後會得到兩個資訊：

~~~text
isFound
→ 有沒有找到

productName
→ 找到的 Value
~~~

---

# 4. Backend Coding Pattern

今天要開始建立這個 Pattern：

## Dictionary Safe Lookup

~~~text
收到一個 ID / Code
        ↓
Dictionary.TryGetValue()
        ↓
     找到嗎？
     /    \
   No      Yes
   ↓        ↓
提早結束   使用 Value
~~~

這在 Backend 很常見，例如：

- ProductId → Product
- UserId → User
- StatusCode → 顯示文字
- PermissionId → Permission
- 設定 Key → 設定值

---

# 5. Coding Task

現在有商品 Dictionary：

~~~csharp
var products = new Dictionary<int, Product>
{
    {
        101,
        new Product { Id = 101, Name = "Laptop", Price = 30000 }
    },
    {
        102,
        new Product { Id = 102, Name = "Mouse", Price = 1200 }
    },
    {
        103,
        new Product { Id = 103, Name = "Keyboard", Price = 2500 }
    }
};

class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

請你自己完成：

~~~csharp
void PrintProduct(
    Dictionary<int, Product> products,
    int productId)
{
    // TODO
}
~~~

---

# 6. 實作要求

`PrintProduct()` 必須：

1. 使用 `productId` 當 Key 查 Dictionary。
2. 使用今天的新 API：`TryGetValue()`。
3. 如果找不到商品：
   - 印出 `Product not found`
   - 直接結束 method。
4. 如果找到商品：
   - 印出商品的 Id、Name、Price。
5. 請沿用之前學過的 Guard Clause，不要寫成大型 `if / else`。

主程式請測試：

~~~csharp
PrintProduct(products, 102);
PrintProduct(products, 999);
~~~

---

# 7. 預期結果

概念上應得到：

~~~text
Id: 102, Name: Mouse, Price: 1200
Product not found
~~~

---

# 8. 今天的驗證重點

完成後確認自己能回答：

### Q1
為什麼下面這種寫法，在 Key 不確定存在時有風險？

~~~csharp
var product = products[productId];
~~~

### Q2
`TryGetValue()` 同時提供了哪兩個資訊？

### Q3
看到這種需求：

> 「我有一個 ProductId，要從 Dictionary 找 Product，但 ProductId 不一定存在。」

你是否能想到：

~~~text
Dictionary Safe Lookup
→ TryGetValue
→ Guard Clause
~~~

---

完成後把你的 `Program.cs` 貼回來，我會做 Day27 Code Review。

卡住時照舊：

提示1 → 提示2 → 完整答案
