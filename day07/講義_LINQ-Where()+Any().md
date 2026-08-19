# Daily 07 — LINQ `Where + Any`：篩選「子集合存在符合條件資料」的物件

## 今日主題

今天真正的 LINQ 主題只有一個：

> 把已經學過的 `Where` 與 `Any` 組合起來。

但是今天的資料第一次出現：

- 自訂 `class`
- 建立自訂 class 的物件
- Object Initializer
- 巢狀物件
- `List<自訂型別>`

因此在寫 LINQ 前，必須先建立這些 C# syntax baseline。

今天分成兩部分：

```text
Part A：先學會建立 Product / Stock 資料
                    ↓
Part B：使用 Where + Any 查詢資料
```

---

# Part A — 建立物件資料

## 1. `class` 是什麼？

今天會使用兩個 class：

~~~csharp
class Product
{
    public string Name { get; set; } = "";
    public List<Stock> Stocks { get; set; } = new();
}

class Stock
{
    public string Warehouse { get; set; } = "";
    public int Quantity { get; set; }
}
~~~

先不用深入 OOP。

目前只需要建立這個心智模型：

```text
class
  ↓
定義「這種物件具有哪些資料」

Product
├─ Name
└─ Stocks

Stock
├─ Warehouse
└─ Quantity
```

可以暫時把它類比成 TypeScript 的 class：

~~~typescript
class Stock {
    warehouse: string;
    quantity: number;
}
~~~

---

# 2. TS / JS 的 `:` 與 C# 的 `=`

這是今天很重要的語法差異。

在 JavaScript / TypeScript Object Literal 中：

~~~typescript
const stock = {
    warehouse: "Taipei",
    quantity: 5
};
~~~

使用：

```text
property : value
```

但 C# 今天使用的是 **Object Initializer**：

~~~csharp
Stock stock = new Stock
{
    Warehouse = "Taipei",
    Quantity = 5
};
~~~

使用：

```text
Property = value
```

所以：

```text
JavaScript / TypeScript

{
    warehouse: "Taipei"
}

        ↓ C# mapping

new Stock
{
    Warehouse = "Taipei"
}
```

注意：

> C# 這裡不是 JavaScript Object Literal。

它是在：

1. 建立一個 `Stock` instance
2. 對這個 instance 的 Property 指定初始值

所以使用 `=`。

---

# 3. `new` 到底在做什麼？

看到：

~~~csharp
new Stock()
~~~

目前先理解成：

> 建立一個 Stock instance（物件）。

例如：

~~~csharp
Stock stock = new Stock();
~~~

心智模型：

```text
Stock
  ↑
class / 型別

new Stock()
  ↓
建立一個真正的 Stock instance

stock
  ↓
變數指向這個 instance
```

這和 TypeScript：

~~~typescript
const form = new FormGroup(...);
~~~

裡面的 `new` 是相近概念。

---

# 4. `new Stock()` 為什麼有時候可以寫成 `new()`？

完整寫法：

~~~csharp
Product keyboard = new Product();
~~~

但 C# 如果左邊已經明確寫出型別：

~~~csharp
Product keyboard = new();
~~~

Compiler 已經知道：

```text
左邊：Product
       ↓
所以 new() 要建立 Product
```

因此：

~~~csharp
Product keyboard = new Product();
~~~

可以簡化成：

~~~csharp
Product keyboard = new();
~~~

這叫做 **target-typed new**。

目前只要記：

```text
Product keyboard = new();
↑
左邊已經告訴 Compiler 型別
```

---

# 5. 為什麼 `new Stock` 又沒有 `()`？

你可能會看到：

~~~csharp
new Stock
{
    Warehouse = "Taipei",
    Quantity = 5
}
~~~

而不是：

~~~csharp
new Stock()
{
    Warehouse = "Taipei",
    Quantity = 5
}
~~~

在今天這種「呼叫無參數 constructor + Object Initializer」的情況：

~~~csharp
new Stock()
{
    ...
}
~~~

可以省略成：

~~~csharp
new Stock
{
    ...
}
~~~

兩者在今天的情境可以先視為同一件事：

```text
new Stock()
{
    ...
}

≈

new Stock
{
    ...
}
```

因此目前你會看到三種外觀：

### 完整寫出型別

~~~csharp
Product keyboard = new Product();
~~~

### 左邊已有型別，因此省略右邊型別

~~~csharp
Product keyboard = new();
~~~

### Object Initializer 中省略空的 `()`

~~~csharp
new Stock
{
    Warehouse = "Taipei"
}
~~~

先不用背規格。

核心只有：

> `new` = 建立 instance。

其他差異目前主要是 C# 提供的語法簡化。

---

# 6. 為什麼第二層還需要 `new Stock`？

假設：

~~~csharp
List<Stock> stocks = new List<Stock>
{
    ???
};
~~~

`List<Stock>` 的意思是：

> 這個 List 裡面要裝的是 `Stock instance`。

所以每一項都必須真的建立一個 Stock：

~~~csharp
List<Stock> stocks = new List<Stock>
{
    new Stock
    {
        Warehouse = "Taipei",
        Quantity = 0
    },

    new Stock
    {
        Warehouse = "Taichung",
        Quantity = 3
    }
};
~~~

結構是：

```text
List<Stock>
│
├─ Stock instance
│    ├─ Warehouse
│    └─ Quantity
│
└─ Stock instance
     ├─ Warehouse
     └─ Quantity
```

這和之前：

~~~csharp
List<string> names = new()
{
    "Apple",
    "Banana"
};
~~~

有一個重要差異。

`"Apple"` 本身已經是一個 string value。

但：

~~~csharp
{
    Warehouse = "Taipei"
}
~~~

本身並不是一個完整的 `Stock instance`。

所以必須：

~~~csharp
new Stock
{
    Warehouse = "Taipei"
}
~~~

---

# 7. 組合成 Product

現在才能安全地看今天需要的資料：

~~~csharp
Product laptop = new()
{
    Name = "Laptop",

    Stocks = new List<Stock>
    {
        new Stock
        {
            Warehouse = "Taipei",
            Quantity = 0
        },

        new Stock
        {
            Warehouse = "Taichung",
            Quantity = 3
        }
    }
};
~~~

由外往內看：

```text
new Product
│
├─ Name = "Laptop"
│
└─ Stocks
     ↓
   new List<Stock>
     │
     ├─ new Stock
     │    ├─ Warehouse = "Taipei"
     │    └─ Quantity = 0
     │
     └─ new Stock
          ├─ Warehouse = "Taichung"
          └─ Quantity = 3
```

這裡出現多次 `new` 是合理的。

因為你真的建立了：

```text
1 個 Product instance
1 個 List<Stock> instance
2 個 Stock instance
```

不是同一個 `new` 重複寫很多次，而是：

> 每個 `new` 都在建立一個不同的物件。

---

# 8. 為什麼 class 放在程式最後？

目前我們的 Console Project 使用 C# 的 **top-level statements**。

例如：

~~~csharp
Console.WriteLine("Hello");

var products = new List<Product>();
~~~

這些直接寫在檔案裡的執行程式碼屬於 top-level statements。

而：

~~~csharp
class Product
{
}
~~~

是型別宣告。

在這種寫法下，top-level statements 必須出現在 type declaration 前面。

所以目前 Daily 可以固定使用：

~~~csharp
// ==========================
// 執行程式
// ==========================

Console.WriteLine("Hello");

var products = new List<Product>();


// ==========================
// Class 定義
// ==========================

class Product
{
}

class Stock
{
}
~~~

目前先記住這個 Console Daily 的結構即可：

```text
Program.cs

執行程式
    ↓
LINQ / foreach 等操作
    ↓
class Product
    ↓
class Stock
```

這不代表：

> C# 的 class 永遠只能放在所有程式碼最後。

而是目前我們使用 top-level statements 時，需要遵守這個結構。

未來進入一般 class-based C# / ASP.NET Core 程式碼時，再建立完整的檔案與 class 心智模型。

---

# Part B — `Where + Any`

## 9. 回顧 Where

`Where`：

> 從集合中留下符合條件的元素。

~~~csharp
var expensiveProducts = products.Where(
    product => product.Price >= 100
);
~~~

心智模型：

```text
一群 Product
    ↓
逐個判斷
    ↓
true  → 留下
false → 排除
```

---

# 10. 回顧 Any

`Any`：

> 集合裡是否至少存在一個符合條件的元素？

~~~csharp
var hasStock = stocks.Any(
    stock => stock.Quantity > 0
);
~~~

結果：

```text
true / false
```

---

# 11. 今天的新組合

需求：

> 找出至少有一個倉庫庫存大於 0 的 Product。

先拆需求。

### 外層

我們最後要留下的是 Product：

~~~csharp
products.Where(...)
~~~

### 內層

判斷 Product 的 Stocks 是否至少有一筆：

```text
Quantity > 0
```

因此需要：

~~~csharp
product.Stocks.Any(
    stock => stock.Quantity > 0
)
~~~

組合結構：

~~~csharp
products.Where(
    product =>
        product.Stocks.Any(
            stock => stock.Quantity > 0
        )
);
~~~

---

# 12. Backend Coding Pattern

今天的 Pattern：

## Nested Existence Filtering

結構：

~~~csharp
parents.Where(
    parent => parent.Children.Any(
        child => condition
    )
);
~~~

意思：

> 根據「子集合是否至少存在一筆符合條件的資料」，決定父元素是否留下。

例如：

```text
Product
   ↓
Stocks
   ↓
至少一筆 Quantity > 0？
   ↓
true / false
   ↓
決定 Product 是否留下
```

---

# 13. Coding Task

請建立三個 Product：

```text
Laptop
- Taipei：0
- Taichung：3

Mouse
- Taipei：0
- Taichung：0

Keyboard
- Taipei：5
- Taichung：0
```

然後建立：

~~~csharp
var products = new List<Product>
{
    laptop,
    mouse,
    keyboard
};
~~~

請自己完成核心 LINQ：

~~~csharp
var availableProducts = products
    // TODO
~~~

需求：

> 找出至少有一個 Stock 的 `Quantity > 0` 的 Product。

---

# 14. 實作要求

必須使用：

- `Where`
- `Any`
- `foreach`

不要使用巢狀 `foreach` 手動完成篩選。

---

# 15. 預期結果

~~~text
Laptop
Keyboard
~~~

Mouse 不應出現。

---

# 16. 今日心智模型更新

今天其實建立了兩層知識。

## C# Object

```text
class
  ↓
描述某種物件有哪些資料

new
  ↓
建立 instance

Object Initializer
  ↓
Property = value
```

以及：

```text
Product
│
└─ List<Stock>
      │
      ├─ Stock instance
      └─ Stock instance
```

所以巢狀資料裡看到很多 `new`：

```text
new Product
    ↓
new List<Stock>
    ↓
new Stock
```

代表的是：

> 我正在建立不同層級的 instance。

---

## LINQ Pattern

之前：

```text
Where = 篩選集合

Any = 是否至少存在一個
```

今天：

```text
父集合
   ↓
Where
   ↓
每個父元素
   ↓
檢查它的子集合
   ↓
Any
   ↓
true / false
   ↓
決定父元素是否留下
```

也就是：

```text
Where + Any
    ↓
Nested Existence Filtering
```

---

# 17. 今日 Learning Evidence

`Where + Any` 已成功實作，但今天同時暴露出以下尚未建立 baseline 的 C# syntax：

- Object Initializer
- C# Property assignment：`=`
- 自訂 class instance 建立
- 巢狀物件初始化
- `List<自訂型別>`
- `new()` / `new Type()` / `new Type { }`
- top-level statements 與 class declaration 的基本位置關係

因此：

> 今天「成功寫出 Product / Stock」不代表上述語法已熟悉。

後續需要透過不同情境 Retrieval，再確認是否真正掌握。