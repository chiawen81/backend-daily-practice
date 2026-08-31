# Day13 — class / object / property 心智模型

## 今日主題

今天正式整理三個你其實已經用過、但還沒有完整建立心智模型的概念：

- `class`
- `object / instance`
- `property`

今天的目標不是學複雜 OOP，而是能回答：

> 我寫的 `Product` 到底是什麼？  
> `new Product()` 又是在做什麼？  
> `Name`、`Price` 這些東西又屬於哪一層？

---

# 1. 先建立整體心智模型

```text
class
「這種東西長什麼樣」
        │
        │ new
        ▼
object / instance
「實際建立出來的一份資料」
        │
        ├── property
        ├── property
        └── property
```

例如：

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

這裡的 `Product` 是：

> 一個型別（type）的定義／藍圖。

它描述：

```text
Product
├── Id
├── Name
└── Price
```

但此時還沒有任何真正的商品資料。

---

# 2. object / instance 是什麼？

當我們寫：

~~~csharp
var laptop = new Product
{
    Id = 101,
    Name = "Laptop",
    Price = 30000
};
~~~

才真正建立出一個 `Product`。

可以想成：

```text
Product class
    │
    │ new
    ▼
laptop object
├── Id = 101
├── Name = "Laptop"
└── Price = 30000
```

所以：

- `Product` → 型別／藍圖
- `laptop` → 一個實際 object
- `new Product` → 根據 Product 型別建立新的 object

---

# 3. object 與 instance

今天先把這兩個詞視為幾乎相同即可：

```text
object ≈ instance
```

更精確地說：

> `laptop` 是一個 object，也是 `Product` 的 instance。

也就是：

```text
Product
   ↓
instance
   ↓
laptop
```

未來看到：

> Create a Product instance

基本上就是：

> 建立一個 Product 物件。

---

# 4. property 是什麼？

在：

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

`Id`、`Name`、`Price` 都是 **Property（屬性）**。

它們描述：

> Product object 可以保存／提供哪些資料。

所以：

```text
class Product
│
├── property: Id
├── property: Name
└── property: Price
```

建立 object 後：

~~~csharp
laptop.Name
laptop.Price
~~~

就是在取得這個 object 的 property。

---

# 5. TypeScript → C# Mapping

你熟悉的 TypeScript：

~~~typescript
class Product {
  id: number;
  name: string;
  price: number;
}

const laptop = new Product();
~~~

概念上對應 C#：

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}

var laptop = new Product();
~~~

兩邊核心概念相同：

```text
class
  ↓
定義型別
  ↓
new
  ↓
建立 instance
```

C# 的：

~~~csharp
public string Name { get; set; }
~~~

目前先理解成：

> Product 對外提供一個可以讀取與設定的 `Name` property。

`get` / `set` 的更深入機制今天先不展開。

---

# 6. 一個 class 可以建立很多 object

class 不是某一筆商品。

例如：

~~~csharp
var laptop = new Product
{
    Id = 101,
    Name = "Laptop",
    Price = 30000
};

var mouse = new Product
{
    Id = 102,
    Name = "Mouse",
    Price = 1200
};
~~~

心智模型：

```text
              Product class
             /             \
          new               new
           ↓                 ↓
       laptop              mouse
     Product instance    Product instance
```

兩個 object：

- 型別相同
- property 結構相同
- 實際保存的資料不同

---

# Coding Task

建立今天的 `day13` Console Project。

## 情境

現在系統需要表示「訂單」。

一筆 Order 有：

```text
Id
CustomerName
TotalAmount
IsPaid
```

資料型別：

```text
Id            → int
CustomerName  → string
TotalAmount   → int
IsPaid        → bool
```

---

## 實作要求

### 1. 自己建立 `Order` class

需要包含：

- `Id`
- `CustomerName`
- `TotalAmount`
- `IsPaid`

四個 property。

---

### 2. 建立兩個不同的 Order object

資料如下：

第一筆：

```text
Id = 1001
CustomerName = Alice
TotalAmount = 2500
IsPaid = true
```

第二筆：

```text
Id = 1002
CustomerName = Bob
TotalAmount = 1800
IsPaid = false
```

請使用之前已經接觸過的 **Object Initializer** 建立。

---

### 3. 將兩個 Order 放入 List<Order>

這部分是 Sprint 1 Retrieval。

不要回去找完整答案，先自己回想：

```text
List<T>
Collection Initializer
```

---

### 4. 使用 foreach 印出每筆訂單

輸出以下 property：

```text
Id
CustomerName
TotalAmount
IsPaid
```

格式不用完全一致，只要資料正確即可。

---

# 今天刻意不做的事情

不要使用：

- LINQ
- method
- Dictionary
- constructor 自訂邏輯

今天不是要增加功能，而是確認：

> 你能不能自己從 class → object → property → List 串起來。

---

# 完成後你應該能回答

請先不要寫成文字答案交給 AI。

直接看著自己的程式碼，確認自己能指出：

```text
哪一段是 class？

哪兩個東西是 object / instance？

哪些東西是 property？

new Order 做了什麼？

為什麼兩個 Order 可以放進 List<Order>？
```

如果其中任何一題你無法解釋，再提出來討論。

---

# 預期結果

執行：

~~~bash
dotnet run --project day13/day13.csproj
~~~

應能看到兩筆 Order 的資料。

例如概念上：

```text
1001 Alice 2500 True
1002 Bob 1800 False
```

---

# 今日完成條件

- [ ] 能自行建立 `Order` class
- [ ] 能定義四個 property
- [ ] 能建立兩個不同的 `Order` instance
- [ ] 能將它們放入 `List<Order>`
- [ ] 能用 `foreach` 讀取並輸出 property
- [ ] 能分辨 class / object(instance) / property
- [ ] 程式成功 compile + run

卡住時依序：

**提示1 → 提示2 → 完整答案**

不要直接查完整答案。