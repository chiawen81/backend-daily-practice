# Day28 — Dictionary Lookup：Value 是物件

## 今日主題

前兩天我們已經做過：

- Day26：`Dictionary<TKey, TValue>` 基本概念、Key → Value、`dictionary[key]`
- Day27：`TryGetValue()` + Guard Clause

今天只往前一步：

> Dictionary 的 Value 不一定是 `string`、`int` 這種簡單型別，也可以是一個物件。

這在 Backend 很常見，例如：

~~~csharp
Dictionary<int, Product>
Dictionary<int, Customer>
Dictionary<int, Order>
~~~

也就是：

~~~text
ProductId → Product
CustomerId → Customer
OrderId → Order
~~~

---

# 1. 新知：Dictionary 的 Value 可以是物件

之前如果有：

~~~csharp
var productNames = new Dictionary<int, string>
{
    { 101, "Laptop" },
    { 102, "Mouse" }
};
~~~

型別關係是：

~~~text
int    → string
Key      Value
~~~

今天改成：

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

Dictionary 可以寫成：

~~~csharp
var products = new Dictionary<int, Product>
{
    {
        101,
        new Product
        {
            Id = 101,
            Name = "Laptop",
            Price = 30000
        }
    },
    {
        102,
        new Product
        {
            Id = 102,
            Name = "Mouse",
            Price = 1200
        }
    }
};
~~~

現在型別關係變成：

~~~text
int    → Product
Key      Value
~~~

所以如果成功 lookup：

~~~csharp
products.TryGetValue(101, out var product);
~~~

`product` 就是一個 `Product` 物件。

因此可以存取：

~~~csharp
product.Name
product.Price
~~~

---

# 2. 最小 Example

~~~csharp
var products = new Dictionary<int, Product>
{
    {
        101,
        new Product
        {
            Id = 101,
            Name = "Laptop",
            Price = 30000
        }
    }
};

if (!products.TryGetValue(101, out var product))
{
    Console.WriteLine("Product not found");
    return;
}

Console.WriteLine(product.Name);
Console.WriteLine(product.Price);
~~~

核心 Pattern：

~~~text
Key
 ↓
Dictionary Lookup
 ↓
取得完整 Object
 ↓
使用 Object 的 Properties
~~~

這是很常見的：

> **ID → Object Lookup**

---

# 3. Coding Task

請建立以下商品資料：

| ProductId | Name | Price |
|---|---|---:|
| 101 | Laptop | 30000 |
| 102 | Mouse | 1200 |
| 103 | Keyboard | 2500 |

使用：

~~~csharp
Dictionary<int, Product>
~~~

儲存資料。

接著建立：

~~~csharp
void PrintProduct(
    Dictionary<int, Product> products,
    int productId)
~~~

---

## 實作要求

`PrintProduct()` 必須：

1. 使用 `productId` 查詢 Dictionary。
2. 不可以使用 `dictionary[key]` 直接取得資料。
3. 使用 Day27 學過的安全 Lookup Pattern。
4. 找不到商品時印出：

~~~text
Product not found
~~~

並立即結束 method。

5. 找到商品時印出：

~~~text
Id: 102, Product: Mouse, Price: 1200
~~~

---

# 4. 驗證

主程式呼叫：

~~~csharp
PrintProduct(products, 102);
PrintProduct(products, 999);
~~~

預期：

~~~text
Id: 102, Product: Mouse, Price: 1200
Product not found
~~~

---

# 5. 今日限制

今天不要使用：

- LINQ
- `FirstOrDefault`
- `Where`
- `ContainsKey`

目標不是找更多 API。

今天只練熟這條：

~~~text
ID
 ↓
Dictionary<int, Product>
 ↓
TryGetValue
 ↓
Product object
 ↓
property access
