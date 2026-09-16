# Day22 — HashSet<T> + Except()

## 今日主題

使用 `Except()` 找出：

> **「A 有，但 B 沒有」的元素**

今天只新增一個主要知識點：

~~~csharp
Except()
~~~

---

# 1. 先回顧昨天：Intersect()

昨天學的是：

~~~csharp
var favoriteProductIds = new HashSet<int>()
{
    101, 102, 105, 108, 110
};

var availableProductIds = new HashSet<int>()
{
    101, 103, 105, 106, 110
};

var result = favoriteProductIds.Intersect(availableProductIds);
~~~

`Intersect()` 的意思：

~~~text
favoriteProductIds
        ∩
availableProductIds

→ 兩邊都有
~~~

結果：

~~~text
101
105
110
~~~

Backend Pattern：

> 兩組「相同型別的值」要找共同元素 → Intersect

---

# 2. 今天的新知：Except()

假設：

~~~csharp
var orderedProductIds = new HashSet<int>()
{
    101, 102, 105, 108
};

var availableProductIds = new HashSet<int>()
{
    101, 105, 106
};
~~~

現在需求變成：

> 找出「客戶有下單，但目前已經不存在於可購買商品中的 ProductId」。

可以使用：

~~~csharp
var unavailableProductIds =
    orderedProductIds.Except(availableProductIds);
~~~

結果：

~~~text
102
108
~~~

心智模型：

~~~text
A.Except(B)

= A 有
  但 B 沒有
~~~

也就是：

~~~text
orderedProductIds
101 102 105 108

        Except

availableProductIds
101     105     106

        ↓

102 108
~~~

---

# 3. 很重要：順序會影響結果

`Except()` 和昨天的 `Intersect()` 有一個很重要的差異。

昨天：

~~~csharp
A.Intersect(B)
~~~

是在問：

> A 和 B 共同有哪些？

但：

~~~csharp
A.Except(B)
~~~

是在問：

> **A 裡有哪些東西不在 B？**

所以：

~~~csharp
A.Except(B)
~~~

與：

~~~csharp
B.Except(A)
~~~

語意完全不同。

例如：

~~~text
A = { 101, 102, 105 }
B = { 101, 105, 108 }

A.Except(B)
→ 102

B.Except(A)
→ 108
~~~

閱讀 `Except()` 時，先把它翻譯成：

> 「左邊扣掉右邊」

---

# 4. Backend Coding Pattern

今天要建立的 Pattern：

## Set Difference / 集合差集

需求：

> 找出「原本有，但另一組沒有」的資料。

Pattern：

~~~csharp
sourceIds.Except(targetIds)
~~~

常見 Backend 情境：

~~~text
原本權限 - 新權限
→ 被移除的權限

原本商品 - 現有商品
→ 已不存在的商品

舊關聯 ID - 新關聯 ID
→ 需要刪除的關聯
~~~

尤其「比較更新前後的 ID 集合」時很常看到這個 Pattern。

---

# 5. Coding Task

## 情境

後端收到某個使用者「更新後的角色權限」。

資料庫原本的權限：

~~~csharp
var existingPermissionIds = new HashSet<int>()
{
    10, 20, 30, 40, 50
};
~~~

前端送來更新後要保留的權限：

~~~csharp
var requestedPermissionIds = new HashSet<int>()
{
    10, 30, 40, 60
};
~~~

請找出：

> **這次更新後，需要被移除的 PermissionId。**

---

# 6. 實作要求

請自己完成：

1. 建立 `existingPermissionIds`
2. 建立 `requestedPermissionIds`
3. 使用今天的新知 `Except()`
4. 將結果存進一個命名清楚的變數
5. 使用 `foreach` 印出結果

輸出格式：

~~~text
Remove PermissionId: ???
Remove PermissionId: ???
~~~

⚠️ 不要用 `Contains()` + `if` 自己重做差集。

今天刻意練習：

~~~text
看到「A 有、B 沒有」
        ↓
想到 Except()
~~~

---

# 7. 預期結果／驗證方式

執行：

~~~bash
dotnet run
~~~

確認：

1. 程式可以正常 compile / run
2. 印出的 PermissionId 符合需求
3. 沒有印出仍然存在於 `requestedPermissionIds` 的權限
4. 自己能回答：

~~~text
existingPermissionIds.Except(requestedPermissionIds)

到底是在找：

A. 新增的權限
B. 移除的權限
C. 兩邊共同的權限
~~~

---

# 今日 Retrieval

完成 Coding Task 後，不查前面的內容，試著回答：

~~~text
兩組 ProductId：

A 和 B 都有
→ ?

A 有、B 沒有
→ ?

判斷某個 ProductId 是否存在於 A
→ ?
~~~

今天的目標不是背 API。

而是開始建立：

需求語意
    ↓
集合關係
    ↓
選擇對應操作

共同元素       → Intersect
左邊有右邊沒有 → Except
單一元素存在性 → Contains
