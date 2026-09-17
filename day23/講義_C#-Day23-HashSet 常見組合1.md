# Day23 — HashSet Pattern Retrieval：找出新增與刪除的資料

## 今日主題

今天不學新的 HashSet API。

目標是把最近學過的：

- `HashSet<T>`
- `Except()`
- `IEnumerable<T>`
- `ToList()`

組合成一個常見的 Backend Coding Pattern：

> **比較「DB 現有資料」與「Request 最新資料」，找出哪些要新增、哪些要刪除。**

---

# 1. 情境

假設資料庫目前有這些商品權限：

~~~csharp
var existingProductIds = new HashSet<int>()
{
    101, 102, 103, 104
};
~~~

前端送來使用者最新選擇：

~~~csharp
var requestedProductIds = new HashSet<int>()
{
    102, 103, 105, 106
};
~~~

可以把它想成：

~~~text
DB 現況
101 102 103 104

前端最新狀態
    102 103     105 106
~~~

所以最後應該能判斷：

~~~text
需要新增：105, 106
需要刪除：101, 104
~~~

---

# 2. 今天需要 Retrieval 的舊知識

昨天學過：

~~~csharp
A.Except(B)
~~~

意思是：

> 找出「A 有，但是 B 沒有」的元素。

例如：

~~~csharp
var a = new HashSet<int>() { 1, 2, 3 };
var b = new HashSet<int>() { 2, 3, 4 };

var result = a.Except(b);
~~~

結果：

~~~text
1
~~~

注意：

**方向很重要。**

~~~text
A.Except(B)

≠

B.Except(A)
~~~

---

# 3. Coding Task

請建立：

~~~csharp
var existingProductIds = new HashSet<int>()
{
    101, 102, 103, 104
};

var requestedProductIds = new HashSet<int>()
{
    102, 103, 105, 106
};
~~~

接著自己完成兩個變數：

~~~csharp
var shouldBeAddedProductIds = ???;

var shouldBeDeletedProductIds = ???;
~~~

要求：

1. 使用 `Except()`
2. 不使用 `foreach + Contains` 自己手刻比對
3. 將兩個結果轉成 `List<int>`
4. 使用 `PrintIds()` 印出結果

---

# 4. PrintIds()

可以沿用昨天的寫法：

~~~csharp
void PrintIds(IEnumerable<int> ids)
{
    foreach (var id in ids)
    {
        Console.WriteLine(id);
    }
}
~~~

你可以自行決定怎麼分開印：

~~~text
需要新增：
105
106

需要刪除：
101
104
~~~

---

# 5. 實作要求

今天真正要判斷的只有兩件事：

### 問題 A

~~~text
哪些 ID：

前端有
但是
DB 沒有
~~~

這些就是：

~~~text
需要新增
~~~

---

### 問題 B

~~~text
哪些 ID：

DB 有
但是
前端沒有
~~~

這些就是：

~~~text
需要刪除
~~~

請先用中文想清楚：

~~~text
誰.Except(誰)
~~~

再寫程式。

---

# 6. 預期結果

程式執行後應得到：

~~~text
需要新增：
105
106

需要刪除：
101
104
~~~

---

# 7. 今天的 Backend Coding Pattern

這是一個很常見的：

## Collection Diff Pattern

~~~text
Existing State（DB）
        +
Requested State（Request）
        ↓
      Compare
     ↙       ↘
  To Add    To Delete
~~~

例如未來可能遇到：

~~~text
使用者權限更新
商品分類更新
角色權限更新
Menu 關聯更新
Tag 更新
多對多關聯更新
~~~

今天先不用考慮 DB 實際 INSERT / DELETE。

只專心完成：

> **兩組 ID → 算出新增集合與刪除集合**
