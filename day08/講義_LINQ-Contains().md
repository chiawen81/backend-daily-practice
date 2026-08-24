# Backend Daily 09 — LINQ `Contains`：指定 ID 清單篩選

## 今日主題

今天只學一個新的 LINQ / Collection API：

> `Contains`：判斷一個集合裡是否包含指定的值。

並把它跟已經學過的 `Where` 組合起來。

今天會建立第一個很常見的 Backend Coding Pattern：

> **ID List Filtering**

預計時間：10～15 分鐘。

---

# 1. 今天的新知：`Contains`

假設現在有一組商品 ID：

~~~csharp
var targetIds = new List<int> { 1, 3 };
~~~

如果我們想問：

> `targetIds` 裡面有沒有 `1`？

可以寫：

~~~csharp
targetIds.Contains(1);
~~~

結果是：

~~~text
true
~~~

因為：

~~~text
targetIds
↓
1
3
~~~

裡面確實存在 `1`。

反過來：

~~~csharp
targetIds.Contains(2);
~~~

結果就是：

~~~text
false
~~~

因為集合裡沒有 `2`。

---

# 2. TypeScript → C# Mapping

這個概念其實跟 TypeScript 的 `includes()` 很接近。

TypeScript：

~~~typescript
const targetIds = [1, 3];

targetIds.includes(1);
~~~

C#：

~~~csharp
var targetIds = new List<int> { 1, 3 };

targetIds.Contains(1);
~~~

可以先建立這個 mapping：

~~~text
TypeScript                 C#

array.includes(value)  →   collection.Contains(value)
~~~

兩者都在回答：

> 「這個值存在於集合裡嗎？」

結果都是：

~~~text
true / false
~~~

---

# 3. `Where + Contains`

單獨使用 `Contains` 很簡單。

但 Backend 更常遇到的是：

> 我有一組指定 ID，請從完整資料中找出這些 ID 對應的資料。

例如現在有：

~~~csharp
var targetIds = new List<int> { 1, 3 };
~~~

以及很多商品：

~~~text
1 Laptop
2 Mouse
3 Keyboard
4 Monitor
~~~

需求是：

> 找出 Id 存在於 `targetIds` 裡的商品。

這時可以把之前學過的 `Where` 跟今天的 `Contains` 組合：

~~~csharp
var result = products.Where(
    product => targetIds.Contains(product.Id)
);
~~~

---

# 4. 拆開來看它到底在做什麼

先看外層：

~~~csharp
products.Where(...)
~~~

意思是：

> 從 products 篩選資料。

`Where` 每次會拿到一個：

~~~csharp
product
~~~

接著執行：

~~~csharp
targetIds.Contains(product.Id)
~~~

例如目前拿到：

~~~text
Product
Id = 1
Name = Laptop
~~~

實際判斷就相當於：

~~~csharp
targetIds.Contains(1)
~~~

結果：

~~~text
true
~~~

所以 Laptop 被保留。

下一筆：

~~~text
Product
Id = 2
Name = Mouse
~~~

相當於：

~~~csharp
targetIds.Contains(2)
~~~

結果：

~~~text
false
~~~

所以 Mouse 被排除。

整體流程：

~~~text
products
   ↓
Where
   ↓
每次拿一個 product
   ↓
product.Id
   ↓
targetIds.Contains(product.Id)
   ↓
 ┌─────────────┐
true          false
 ↓              ↓
保留           排除
~~~

---

# 5. Backend Coding Pattern：ID List Filtering

今天真正重要的不是單獨背：

~~~csharp
Contains(...)
~~~

而是開始認得這個 Pattern：

~~~text
一批完整資料
      +
一組指定 ID
      ↓
Where + Contains
      ↓
取得指定資料
~~~

例如：

~~~text
UserIds     + Users
ProductIds  + Products
OrderIds    + Orders
RoleIds     + Roles
~~~

都很可能出現相同需求。

Pattern 的形狀是：

~~~csharp
items.Where(
    item => ids.Contains(item.Id)
);
~~~

今天 Coding Task 請不要直接複製這段改變數名稱。

先從需求自己組一次。

---

# Coding Task

## 情境

系統裡有四個商品。

但目前使用者只勾選了其中三個商品 ID。

你的任務是：

> 從所有商品中，找出使用者選中的商品。

---

## Product Class

使用：

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}
~~~

---

## 商品資料

請自己建立 `products`：

| Id | Name |
|---:|---|
| 1 | Laptop |
| 2 | Mouse |
| 3 | Keyboard |
| 4 | Monitor |

---

## 使用者選中的 Product Id

建立：

~~~csharp
var selectedProductIds = new List<int>
{
    1,
    3,
    4
};
~~~

代表使用者選中了：

~~~text
Product Id 1
Product Id 3
Product Id 4
~~~

---

# 你的任務

請完成以下流程：

~~~text
products
   +
selectedProductIds
   ↓
使用 Where + Contains
   ↓
取得使用者選中的 Products
   ↓
foreach
   ↓
印出 Product Name
~~~

---

# 實作要求

請自己完成：

1. 建立 `products`
2. 使用 `Where`
3. 在 `Where` 的 Lambda 裡使用今天的新知 `Contains`
4. 使用 `foreach` 遍歷結果
5. 印出商品名稱

今天不需要使用任何尚未學過的新 LINQ API。

你需要 retrieval 的舊知識只有：

- `List<T>`
- Object / Collection Initializer
- Lambda
- `Where`
- `foreach`

新的只有：

- `Contains`

---

# 預期結果／驗證方式

執行：

~~~bash
dotnet run --project day09/day09.csproj
~~~

Console 應輸出：

~~~text
Laptop
Keyboard
Monitor
~~~

不應該出現：

~~~text
Mouse
~~~

因為：

~~~text
Mouse.Id = 2
~~~

但是：

~~~csharp
selectedProductIds.Contains(2)
~~~

結果為：

~~~text
false
~~~

---

# 完成標準

如果你可以在沒有看完整答案的情況下，自己組出：

~~~text
Where
  ↓
Lambda
  ↓
Contains
~~~

並得到正確結果，今天的 Daily 就完成。

今天真正要帶走的是：

> **ID List Filtering = 用 `Where + Contains` 從完整資料中篩選指定 ID 的資料。**