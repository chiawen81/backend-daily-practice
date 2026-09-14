# Day20 — HashSet<T>：Contains 與 Membership Check

## 今日主題

昨天第一次學：

~~~csharp
HashSet<T>
~~~

建立了最重要的 baseline：

~~~text
HashSet<T>
→ 一組「不重複」的資料
~~~

今天只往前增加一個能力：

~~~csharp
Contains()
~~~

也就是：

> 快速判斷「某個值是不是這個集合的成員」。

這在 Backend 很常出現在：

~~~text
這個 ProductId 有沒有被選取？
這個 UserId 有沒有權限？
這個 MenuCode 有沒有被鎖定？
這個 ID 是否存在允許清單中？
~~~

---

# 1. 昨天的 Retrieval

昨天已經寫過：

~~~csharp
var ids = new HashSet<int>();

ids.Add(101);
ids.Add(102);
ids.Add(103);
~~~

現在 HashSet 裡：

~~~text
101
102
103
~~~

今天如果想問：

> 102 在不在裡面？

可以使用：

~~~csharp
ids.Contains(102);
~~~

---

# 2. Contains() 是什麼？

最小語法：

~~~csharp
bool result = ids.Contains(102);
~~~

如果存在：

~~~text
true
~~~

如果不存在：

~~~text
false
~~~

例如：

~~~csharp
var ids = new HashSet<int>()
{
    101,
    102,
    103
};

bool result1 = ids.Contains(102);
bool result2 = ids.Contains(999);

Console.WriteLine(result1);
Console.WriteLine(result2);
~~~

結果：

~~~text
True
False
~~~

心智模型：

~~~text
HashSet
101
102
103
 │
 │ Contains(102)
 ▼
true


HashSet
101
102
103
 │
 │ Contains(999)
 ▼
false
~~~

---

# 3. 這個 Contains 好像看過？

對。

之前 Day08 做過：

~~~csharp
selectedProductIds.Contains(item.Id)
~~~

當時的意思就是：

> `item.Id` 是否存在於 `selectedProductIds`？

今天的概念其實完全一樣：

~~~text
一組 ID
    ↓
Contains(id)
    ↓
這個 ID 在不在裡面？
    ↓
bool
~~~

差別在於：

以前我們主要是在學 LINQ Pattern。

今天則是在理解：

> 為什麼「一組用來判斷某個值存不存在的 ID」很適合使用 HashSet。

---

# 4. HashSet 的第二層心智模型

昨天：

~~~text
HashSet<T>
→ 不重複
~~~

今天增加：

~~~text
HashSet<T>
├─ 不重複
└─ 很適合判斷「某個值是否存在」
~~~

因此看到這種程式需求：

~~~text
我有一組 ID
然後程式會一直問：

101 在不在？
205 在不在？
999 在不在？
...
~~~

就可以開始想到：

~~~csharp
HashSet<int>
~~~

而不是只把 HashSet 理解成：

> 「拿來去重的 List」。

---

# 5. Backend Coding Pattern

今天建立：

## Membership Check

~~~text
一組允許／選取／存在的 ID
          ↓
      HashSet<int>
          ↓
     Contains(id)
          ↓
      true / false
~~~

最小 Pattern：

~~~csharp
if (ids.Contains(productId))
{
    // productId 在集合裡
}
~~~

---

# 6. Coding Task

## 情境

系統中有一組「允許購買的商品 ID」：

~~~text
101
103
105
108
~~~

請使用：

~~~csharp
HashSet<int>
~~~

保存這些 ID。

接著有一批使用者想購買的商品：

~~~text
101
102
103
106
108
~~~

---

## Task

### Step 1

建立：

~~~csharp
var allowedProductIds = new HashSet<int>()
{
    101,
    103,
    105,
    108
};
~~~

### Step 2

建立使用者想購買的商品 ID。

這一組請使用你已經學過的：

~~~csharp
List<int>
~~~

資料：

~~~text
101
102
103
106
108
~~~

### Step 3

使用：

~~~csharp
foreach
~~~

逐一檢查使用者想購買的 ProductId。

每一個 ProductId 都要使用：

~~~csharp
allowedProductIds.Contains(...)
~~~

判斷是否允許購買。

### Step 4

依結果輸出：

~~~text
Product 101：允許購買
Product 102：不允許購買
Product 103：允許購買
Product 106：不允許購買
Product 108：允許購買
~~~

---

# 7. 實作要求

今天必須使用：

- `HashSet<int>`
- `List<int>`
- `Contains()`
- `foreach`
- `if / else`

今天不要使用：

- LINQ `Where()`
- LINQ `Any()`
- `FirstOrDefault()`
- Dictionary
- `Distinct()`

雖然你已經會其中一些 LINQ API，但今天刻意不用。

目的是讓你直接練：

~~~text
HashSet
   ↓
Contains
   ↓
Membership Check
~~~

---

# 8. 一個容易搞混的地方

請注意方向：

~~~csharp
allowedProductIds.Contains(productId)
~~~

可以讀成：

> allowedProductIds 裡面，有沒有 productId？

跟之前 Day08 的心智模型一致：

~~~text
大水池.Contains(要找的東西)
~~~

所以：

~~~text
allowedProductIds.Contains(productId)
^^^^^^^^^^^^^^^^^          ^^^^^^^^^
      大水池                 要找的值
~~~

---

# 9. 預期結果／驗證方式

執行：

~~~bash
dotnet run
~~~

預期至少得到：

~~~text
Product 101：允許購買
Product 102：不允許購買
Product 103：允許購買
Product 106：不允許購買
Product 108：允許購買
~~~

---

# 10. 完成後要確認的心智模型

Day19：

~~~text
HashSet
→ 不允許重複值
~~~

Day20：

~~~text
HashSet
→ 不允許重複值
→ 適合做 Membership Check
~~~

也就是看到：

> 「我有一組 ID，需要一直判斷某個 ID 在不在裡面。」

開始能想到：

~~~csharp
HashSet<int>
~~~

搭配：

~~~csharp
Contains()
~~~

這會是之後把 HashSet 用進 Backend 資料處理 Pattern 的基礎。
