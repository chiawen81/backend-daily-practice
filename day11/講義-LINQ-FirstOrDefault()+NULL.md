# Backend Daily 10 — FirstOrDefault + null 判斷

## 今日主題

今天只補一個主要新知：

> `FirstOrDefault()` 找不到資料時，如何用 `null` 判斷處理？

你昨天已經接觸：

~~~csharp
FirstOrDefault()
~~~

今天不重新學 API，而是把它補成後端非常常見的完整流程：

```text
從集合找資料
    ↓
FirstOrDefault()
    ↓
找到？
 ┌──┴──┐
 Yes    No
 ↓       ↓
使用資料  null
          ↓
       做對應處理
```

---

# 1. 新知：null 是什麼？

`null` 可以先理解成：

> 「目前沒有任何物件。」

例如：

~~~csharp
Product? product = null;
~~~

這代表：

```text
product
  ↓
目前沒有指向任何 Product
```

如果用 TypeScript 對照，可以先建立這個 mapping：

~~~typescript
let product: Product | null = null;
~~~

對應 C#：

~~~csharp
Product? product = null;
~~~

這裡的：

~~~csharp
Product?
~~~

表示：

> 這個變數允許是 `Product`，也允許是 `null`。

---

# 2. 為什麼 FirstOrDefault 會跟 null 一起出現？

假設：

~~~csharp
var products = new List<Product>
{
    new() { Id = 101, Name = "Laptop" },
    new() { Id = 102, Name = "Mouse" }
};
~~~

我們找：

~~~csharp
var product = products.FirstOrDefault(item => item.Id == 102);
~~~

有找到，所以：

```text
product
  ↓
Mouse
```

但如果找：

~~~csharp
var product = products.FirstOrDefault(item => item.Id == 999);
~~~

集合裡沒有 Id 999。

對 `Product` 這種 reference type 而言，結果就是：

~~~csharp
null
~~~

因此實務上不能直接假設一定找得到。

---

# 3. C# 的 null 判斷

今天使用這個寫法：

~~~csharp
if (product is null)
{
    Console.WriteLine("找不到商品");
}
~~~

也可以反過來：

~~~csharp
if (product is not null)
{
    Console.WriteLine(product.Name);
}
~~~

先記住：

```text
is null      → 是 null
is not null  → 不是 null
```

---

# 4. Example

以下只是範例，不是今天 Coding Task 的答案。

~~~csharp
var users = new List<User>
{
    new() { Id = 1, Name = "Amy" },
    new() { Id = 2, Name = "Bob" }
};

var user = users.FirstOrDefault(item => item.Id == 3);

if (user is null)
{
    Console.WriteLine("找不到使用者");
}
else
{
    Console.WriteLine(user.Name);
}

class User
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}
~~~

流程：

```text
users
  ↓
FirstOrDefault(Id == 3)
  ↓
沒有符合資料
  ↓
null
  ↓
if (user is null)
  ↓
「找不到使用者」
```

---

# 5. Coding Task

## 情境

系統裡有以下商品：

| Id | Name | Price |
|---|---|---:|
| 101 | Laptop | 30000 |
| 102 | Mouse | 1200 |
| 103 | Keyboard | 2500 |

指定：

~~~csharp
var targetProductId = 999;
~~~

請從 `productList` 找出這個商品。

---

## 實作要求

1. 建立 `Product` class，包含：

~~~text
Id
Name
Price
~~~

2. 建立上述三筆 `productList`。

3. 宣告：

~~~csharp
var targetProductId = 999;
~~~

4. 使用昨天學過的：

~~~csharp
FirstOrDefault(...)
~~~

尋找 `Id == targetProductId` 的商品。

5. 使用今天的新知：

~~~csharp
is null
~~~

判斷結果。

6. 如果找不到，輸出：

~~~text
找不到商品
~~~

7. 如果找到，輸出：

~~~text
商品：Laptop，價格：30000
~~~

---

# 6. 預期結果

第一次執行：

~~~text
找不到商品
~~~

接著自己把：

~~~csharp
targetProductId
~~~

改成：

~~~csharp
102
~~~

重新執行。

預期：

~~~text
商品：Mouse，價格：1200
~~~

---

# 今日限制

今天先不要查完整答案。

你已經學過的東西：

- `List<T>`
- Object / Collection Initializer
- Lambda
- `FirstOrDefault()`
- `if`

今天真正的新東西只有：

~~~csharp
null
is null
is not null
Product?
~~~

如果卡住：

```text
提示1
 ↓
提示2
 ↓
完整答案
```

---

# 今日要建立的 Backend 心智模型

今天最重要的不是記 `is null` 語法，而是開始建立：

```text
Lookup
  ↓
可能找到
也可能找不到
  ↓
不能假設資料一定存在
  ↓
先處理 Not Found
```

這會逐漸形成後端非常常見的：

> Lookup + Null Handling Pattern

今天先完成最小版本，不需要提前處理 Guard Clause。