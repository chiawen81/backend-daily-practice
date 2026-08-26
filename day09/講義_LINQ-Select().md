# .NET Backend Daily 09 — LINQ `Select`：把資料轉換成另一種形狀

## 今日主題

今天只學一個主要新知：

> LINQ `Select`

前面已經接觸：

- `Where`：決定「哪些資料留下來」
- `Contains`：判斷某個值是否存在於集合中

今天加入：

- `Select`：決定「留下來的資料要變成什麼」

---

# 1. 先建立心智模型

假設有：

~~~csharp
var productList = new List<Product>
{
    new() { Id = 1, Name = "Laptop" },
    new() { Id = 2, Name = "Mouse" },
    new() { Id = 3, Name = "Keyboard" }
};
~~~

如果使用：

~~~csharp
productList.Where(product => product.Id >= 2);
~~~

意思是：

~~~text
Product
  ↓
判斷要不要留下
  ↓
Product
~~~

結果仍然是 Product，只是數量變少。

---

`Select` 不一樣。

~~~csharp
productList.Select(product => product.Name);
~~~

意思是：

~~~text
Product
  ↓
取出 / 轉換
  ↓
string
~~~

結果：

~~~text
Mouse
Keyboard
Laptop
~~~

所以可以先記：

~~~text
Where  = 篩選
Select = 轉換
~~~

---

# 2. TypeScript → C# Mapping

你在 TypeScript / JavaScript 已經有非常接近的概念：

~~~typescript
products.map(product => product.name);
~~~

C# LINQ：

~~~csharp
products.Select(product => product.Name);
~~~

可以先建立：

~~~text
TS / JS map()
      ↓
C# LINQ Select()
~~~

兩者核心概念都是：

> 把集合裡的每一筆資料轉換成另一個值／另一種形狀。

---

# 3. 最小語法

~~~csharp
var names = products.Select(product => product.Name);
~~~

拆開看：

~~~text
products
   │
   └── 原始集合

.Select(
   product => product.Name
      │           │
      │           └── 每一筆 Product 最後要變成什麼
      │
      └── 每次拿到的一筆 Product
)
~~~

原本：

~~~text
List<Product>
~~~

經過 Select：

~~~text
Product → string
~~~

所以結果可以理解成：

~~~text
一串 string
~~~

---

# 4. Example

這是今天的新知示範，不是 Coding Task 的答案。

~~~csharp
var users = new List<User>
{
    new() { Id = 1, Name = "Amy" },
    new() { Id = 2, Name = "Bob" },
    new() { Id = 3, Name = "Cindy" }
};

var userNames = users.Select(user => user.Name);

foreach (var name in userNames)
{
    Console.WriteLine(name);
}

class User
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}
~~~

預期：

~~~text
Amy
Bob
Cindy
~~~

注意資料流：

~~~text
User
 ↓ Select
Name
 ↓
string
~~~

---

# 5. 今日 Coding Task

## 情境

後端收到一組 Product 資料。

現在前端只需要商品名稱，不需要完整 Product。

請你使用 `Select`，把：

~~~text
Product 集合
~~~

轉換成：

~~~text
商品名稱集合
~~~

---

## 起始資料

~~~csharp
var productList = new List<Product>
{
    new() { Id = 101, Name = "Laptop", Price = 30000 },
    new() { Id = 102, Name = "Mouse", Price = 1200 },
    new() { Id = 103, Name = "Keyboard", Price = 2500 }
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

---

# 6. 實作要求

請自己完成：

1. 使用 `Select`
2. 從每個 Product 取出 `Name`
3. 把結果存進一個變數
4. 使用 `foreach` 遍歷結果
5. 印出所有商品名稱

不要使用：

- `for`
- 手動建立另一個 List 再 `Add`
- AI 直接產生完整答案

---

# 7. 預期結果

執行：

~~~bash
dotnet run
~~~

應看到：

~~~text
Laptop
Mouse
Keyboard
~~~

---

# 8. 今天真正要確認的能力

完成後你應該可以看懂：

~~~csharp
items.Select(item => item.Name);
~~~

並知道它不是在「篩選 item」。

而是在說：

~~~text
每一個 item
    ↓
轉換成
    ↓
item.Name
~~~

今天先不要急著組合 `Where + Select`。

先把：

~~~text
Where  → 篩選
Select → 轉換
~~~

這兩個責任分清楚。

下一步才會開始把 LINQ Pattern 組合起來。



<br><br><br>

---
## Day09 補充筆記

### Select 不是 List 專屬 API

`Select` 可以處理「能列舉」的資料，不只 `List<T>`。

目前先建立：

~~~text
能列舉的資料
    ↓
可以使用 LINQ Select
~~~

例如：

- `List<T>`
- Array
- `HashSet<T>`
- `Dictionary<TKey, TValue>`
- `Queue<T>`
- `Stack<T>`

這背後與 `IEnumerable<T>` 有關，目前先不深入。

---

### Select 與 TS / JS map 的差異

兩者都負責：

> 把每筆資料轉換成另一個值／形狀。

~~~text
TS / JS

products.map(product => product.name)

→ Array<string>
~~~

~~~text
C#

products.Select(product => product.Name)

→ IEnumerable<string>
~~~

因此可以明確宣告：

~~~csharp
IEnumerable<string> productNames =
    productList.Select(item => item.Name);
~~~

不能直接寫成：

~~~csharp
List<string> productNames =
    productList.Select(item => item.Name);
~~~

因為 `Select()` 的結果不是 `List<string>`。

如果真的需要 `List<string>`，可以再使用 `.ToList()`：

~~~csharp
List<string> productNames =
    productList
        .Select(item => item.Name)
        .ToList();
~~~

資料流：

~~~text
List<Product>
    ↓ Select
IEnumerable<string>
    ↓ ToList()
List<string>
~~~

---

### 為什麼 IEnumerable 仍然可以 foreach？

雖然 `Select()` 的結果不是 `List`：

~~~csharp
IEnumerable<string> productNames =
    productList.Select(item => item.Name);
~~~

但它仍然是「能列舉」的資料，因此可以：

~~~csharp
foreach (var item in productNames)
{
    Console.WriteLine(item);
}
~~~

目前先建立：

~~~text
不是 List
   ≠
不能 foreach

只要是「能列舉」的資料
就可能可以使用 foreach
~~~

---

### 變數命名

變數名稱優先描述：

> 「這些資料是什麼」

而不是：

> 「這些資料使用什麼容器／型別」。

例如：

~~~csharp
productNames      // ✅ 一組商品名稱
selectedProducts  // ✅ 被選中的商品
orderIds          // ✅ 一組訂單 ID
~~~

不建議：

~~~csharp
productNameList
~~~

因為如果實際型別是 `IEnumerable<string>`，`List` 容易造成誤解。

也不需要特別寫：

~~~csharp
productEnumerable
~~~

因為 `Enumerable` 是技術型別資訊，不是這筆資料的業務語意。

`productSet` 也不適合，因為 `Set` 容易讓人聯想到 `HashSet<T>`。

#### 命名原則

> 命名表達「資料是什麼」；型別交給型別系統表達。

---

## 今日心智模型更新

### Where vs Select

~~~text
Where
→ 篩選
→ 決定「哪些資料留下」

Select
→ 轉換
→ 決定「每筆資料要變成什麼」
~~~

例如：

~~~csharp
productList.Where(item => item.Price > 1000);
~~~

仍然是在處理 `Product`：

~~~text
Product
   ↓ Where
Product
~~~

而：

~~~csharp
productList.Select(item => item.Name);
~~~

則是：

~~~text
Product
   ↓ Select
string
~~~

---

### Select 的結果

目前先記：

~~~text
Select(...) → IEnumerable<T>

需要 List<T>
    ↓
再使用 .ToList()
~~~

`IEnumerable<T>` 今天只是第一次接觸。

目前只需要知道：

> 它代表一種「能被逐筆列舉」的資料。

今天尚未正式學習 `IEnumerable<T>` 的介面、運作方式與延遲執行，因此不要把它視為已經學會的知識點。