# Day18 — `FirstOrDefault` + nullable + null handling

## 今日主題

今天只處理一個核心問題：

> **我要找「一筆資料」，但這筆資料可能不存在時，Method 應該怎麼表達？**

今天會把之前學過的：

- Method
- `FirstOrDefault`
- `null`

正式組合起來。

---

# 1. 先回憶：`FirstOrDefault`

之前我們已經建立過這個心智模型：

| 需求 | LINQ |
|---|---|
| 要多筆資料 | `Where` |
| 要知道有沒有 | `Any` |
| 要取得一筆資料 | `FirstOrDefault` |

例如：

~~~csharp
var order = orders.FirstOrDefault(
    order => order.Id == 1001
);
~~~

如果找到：

~~~text
Order object
~~~

如果找不到：

~~~text
null
~~~

---

# 2. 今天的新重點：Method 的回傳型別也要表達「可能沒有」

假設有：

~~~csharp
class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = "";
}
~~~

我們想寫一個 Method：

~~~csharp
FindOrderById(...)
~~~

如果一定保證找得到，回傳型別可以想成：

~~~csharp
Order
~~~

但問題是：

> `FirstOrDefault()` 找不到資料時可能得到 `null`。

所以 Method 的設計也應該表達：

~~~csharp
Order?
~~~

最小範例：

~~~csharp
Order? FindOrderById(List<Order> orders, int orderId)
{
    return orders.FirstOrDefault(
        order => order.Id == orderId
    );
}
~~~

這裡的：

~~~csharp
Order?
~~~

可以先理解成：

> 這個 Method 回傳的是 `Order`，但是也允許回傳 `null`。

---

# 3. 為什麼這很重要？

比較：

~~~csharp
Order FindOrderById(...)
~~~

與：

~~~csharp
Order? FindOrderById(...)
~~~

第二種其實是在告訴呼叫端：

> 「注意，這個查詢有可能找不到資料。」

因此呼叫端拿到結果後，就應該處理：

~~~csharp
if (order is null)
{
    // 找不到資料
}
~~~

這是 Backend 很常見的資料查詢流程：

~~~text
收到查詢條件
    ↓
FirstOrDefault
    ↓
找到？
 ┌──┴──┐
Yes    No
 ↓      ↓
使用資料  null handling
~~~

---

# 4. Coding Task

建立以下訂單：

~~~text
Id: 1001
CustomerName: Alice

Id: 1002
CustomerName: Bob
~~~

請實作：

~~~csharp
FindOrderById(...)
~~~

需求：

1. 接收：
   - `List<Order>`
   - `int orderId`

2. 使用 `FirstOrDefault`

3. 回傳：
   - 找到 → 對應的 `Order`
   - 找不到 → `null`

---

# 5. 主程式測試

請分別查詢：

~~~text
1001
9999
~~~

然後自行使用 `if` 判斷查詢結果。

預期輸出概念：

~~~text
找到訂單：Alice
找不到訂單
~~~

實際文字可以自己決定，不需要完全相同。

---

# 6. 實作要求

今天請至少出現：

- `class Order`
- `List<Order>`
- 一個 `FindOrderById` Method
- Parameter
- `Order?`
- `FirstOrDefault`
- `is null` 或 `is not null`
- `Console.WriteLine`

不要使用 AI 直接產生完整答案。

---

# 7. 今天刻意不做

今天先不要：

- Guard Clause
- Dictionary
- exception
- ASP.NET Core

今天只把這條資料流寫熟：

~~~text
List<Order>
    ↓
FindOrderById(...)
    ↓
FirstOrDefault(...)
    ↓
Order?
    ↓
null 判斷
~~~

---

# 8. 完成驗證

執行：

~~~bash
dotnet run
~~~

確認：

### Case 1

~~~text
orderId = 1001
~~~

能取得 Alice。

### Case 2

~~~text
orderId = 9999
~~~

程式不會因為 `null` 出錯，而是正常輸出「找不到訂單」。

---

## 今日完成標準

如果你能自己完成：

~~~text
需求：依 ID 找一筆資料
        ↓
Method 回傳 Order?
        ↓
FirstOrDefault
        ↓
呼叫端判斷 null
~~~

Day18 就可以結案。

這個 Pattern 之後會非常常出現在：

~~~text
Controller
    ↓
Service
    ↓
Database Query
    ↓
FirstOrDefault
    ↓
資料存在 / 不存在
~~~
