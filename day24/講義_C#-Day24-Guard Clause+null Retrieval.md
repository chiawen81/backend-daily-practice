# Day24 — Guard Clause + null Retrieval

## 今日主題

今天練習一個後端非常常見的 Coding Pattern：

> **Guard Clause（防衛式條件 / 提早返回）**

你已經學過：

- method
- `FirstOrDefault()`
- `null`
- `is null`
- Collection / LINQ

今天把它們組合起來。

---

# 1. Guard Clause 是什麼？

假設一個 method 要處理商品：

~~~csharp
void PrintProduct(Product product)
{
    if (product is not null)
    {
        Console.WriteLine(product.Name);
        Console.WriteLine(product.Price);
    }
}
~~~

另一種常見寫法是：

~~~csharp
void PrintProduct(Product product)
{
    if (product is null)
    {
        return;
    }

    Console.WriteLine(product.Name);
    Console.WriteLine(product.Price);
}
~~~

第二種就是今天要認識的：

> Guard Clause

核心概念：

~~~text
不符合繼續執行的條件
        ↓
提早 return
        ↓
後面的程式只處理正常流程
~~~

---

# 2. 為什麼 Backend 很常看到 Guard Clause？

後端經常會遇到：

~~~text
收到 ID
  ↓
查資料
  ↓
資料不存在？
  ├─ Yes → 提早結束
  └─ No  → 繼續處理
~~~

例如：

~~~csharp
var product = products.FirstOrDefault(
    product => product.Id == productId
);

if (product is null)
{
    return;
}

// 從這裡開始，可以確定 product 有資料
Console.WriteLine(product.Name);
~~~

這是一個很常見的 Backend Coding Pattern：

> **Lookup → Guard Clause → Normal Flow**

未來在 Service / Controller 裡會大量遇到類似結構。

---

# 3. Coding Task

有以下商品資料：

~~~csharp
var products = new List<Product>()
{
    new Product() { Id = 101, Name = "Laptop", Price = 30000 },
    new Product() { Id = 102, Name = "Mouse", Price = 1200 },
    new Product() { Id = 103, Name = "Keyboard", Price = 2500 }
};
~~~

Product：

~~~csharp
class Product
{
    public int Id { get; set; }

    public string Name { get; set; } = "";

    public int Price { get; set; }
}
~~~

請自己完成：

~~~csharp
void PrintProductDetail(
    IEnumerable<Product> products,
    int productId)
{
    // TODO
}
~~~

---

# 4. 實作要求

`PrintProductDetail()` 必須：

1. 使用 `FirstOrDefault()` 尋找指定 `productId` 的商品。
2. 如果商品不存在：
   - 印出 `"Product not found"`
   - 使用 Guard Clause 提早結束 method。
3. 如果商品存在：
   - 印出商品名稱。
   - 印出商品價格。

請分別測試：

~~~csharp
PrintProductDetail(products, 102);
PrintProductDetail(products, 999);
~~~

限制：

- 不要使用 `Where()` 取代 `FirstOrDefault()`。
- 不要把正常流程包在 `if (product is not null) { ... }` 裡。
- 今天刻意使用 Guard Clause。
- 不需要新增其他 method。

---

# 5. 預期結果

執行：

~~~csharp
PrintProductDetail(products, 102);
~~~

應看到類似：

~~~text
Mouse
1200
~~~

執行：

~~~csharp
PrintProductDetail(products, 999);
~~~

應看到：

~~~text
Product not found
~~~

---

# 6. 今天要記住的 Pattern

~~~text
Lookup
  ↓
找不到？
  ↓ Yes
Guard Clause / return
  ↓ No
Normal Flow
~~~

對應到程式結構：

~~~csharp
var item = /* Lookup */;

if (item is null)
{
    // handle not found
    return;
}

// normal flow
~~~

今天的重點不是背 `return`。

而是看到：

「先查一筆資料 → 沒資料就不用繼續」

能想到：

**Lookup → Guard Clause → Normal Flow**
