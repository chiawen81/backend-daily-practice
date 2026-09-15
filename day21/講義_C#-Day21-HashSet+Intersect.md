# Day21 — HashSet<T> Day 3：集合交集 Intersect()

## 今日主題

今天學一個新的 HashSet / Collection 操作：

> **Intersect()：找出兩個集合「共同擁有」的元素。**

前兩天我們做的是：

```text
一個商品 ID
    ↓
allowedProductIds.Contains(id)
    ↓
這個 ID 有沒有在允許清單裡？
```

今天換一個角度：

```text
使用者擁有的商品 IDs
        +
允許購買的商品 IDs
        ↓
兩邊共同存在的 IDs
```

也就是「集合 vs 集合」。

---

# 1. 新知：Intersect()

假設有兩組資料：

~~~csharp
var userProductIds = new HashSet<int>()
{
    101,
    102,
    103,
    106
};

var allowedProductIds = new HashSet<int>()
{
    101,
    103,
    105,
    108
};
~~~

如果想找：

> 同時存在於 `userProductIds` 和 `allowedProductIds` 的 ID

可以使用：

~~~csharp
var result = userProductIds.Intersect(allowedProductIds);
~~~

結果會是：

~~~text
101
103
~~~

心智模型：

~~~text
userProductIds
101 102 103 106
 ↓       ↓
共同存在
 ↓       ↓
101     103
 ↑       ↑
allowedProductIds
101 103 105 108
~~~

也就是數學上的：

> **交集 Intersection**

---

# 2. Intersect() 跟 Contains() 的差異

前一天：

~~~csharp
allowedProductIds.Contains(productId);
~~~

是在問：

> 「這一個 ID」有沒有存在集合裡？

今天：

~~~csharp
userProductIds.Intersect(allowedProductIds);
~~~

是在問：

> 「這兩個集合」有哪些共同元素？

可以先記：

~~~text
Contains()
一個值 vs 一個集合
→ 有沒有？

Intersect()
一個集合 vs 一個集合
→ 共同有哪些？
~~~

---

# 3. 最小 Example

~~~csharp
var backendSkills = new HashSet<string>()
{
    "C#",
    "LINQ",
    "MSSQL"
};

var requiredSkills = new HashSet<string>()
{
    "C#",
    "ASP.NET Core",
    "MSSQL"
};

var matchedSkills = backendSkills.Intersect(requiredSkills);

foreach (var skill in matchedSkills)
{
    Console.WriteLine(skill);
}
~~~

預期：

~~~text
C#
MSSQL
~~~

---

# 4. Coding Task

現在有一個使用者收藏的商品清單：

~~~csharp
var favoriteProductIds = new HashSet<int>()
{
    101,
    102,
    105,
    108,
    110
};
~~~

目前有庫存、可以購買的商品：

~~~csharp
var availableProductIds = new HashSet<int>()
{
    101,
    103,
    105,
    106,
    110
};
~~~

請找出：

> **使用者收藏，而且目前有庫存的商品 ID**

---

# 5. 實作要求

1. 保留上面的兩個 `HashSet<int>`。
2. 使用今天的新知 `Intersect()`。
3. 將結果存入一個語意清楚的變數。
4. 使用 `foreach` 印出所有結果。
5. 不需要自己寫巢狀迴圈。
6. 不需要使用 `if`。
7. 不需要把結果轉成 `List<int>`。

輸出格式：

~~~text
Available favorite product: 101
Available favorite product: 105
Available favorite product: 110
~~~

---

# 6. 驗證方式

執行：

~~~bash
dotnet run
~~~

確認輸出包含：

~~~text
101
105
110
~~~

並且：

~~~text
102 不應出現
108 不應出現
103 不應出現
106 不應出現
~~~

想一下原因：

- `102`、`108`：有收藏，但沒有庫存。
- `103`、`106`：有庫存，但沒有收藏。
- `101`、`105`、`110`：兩個集合都有。

---

# 今日只需要記住

~~~text
Contains
→ 某一個值是否存在集合中？

Intersect
→ 兩個集合共同有哪些元素？
~~~

今天先把「交集」這個集合操作寫熟即可，不需要延伸其他 HashSet API。
