# Day17 — Method + LINQ Retrieval

## 今日主題

把已經學過的 LINQ 查詢封裝進 method：

> 集合輸入 → LINQ 處理 → 回傳結果

今天不引入新的 LINQ API，重點是從需求判斷該組合哪些既有工具。

---

## 心智模型

一個負責資料查詢的 method，可以分成三部分：

~~~text
輸入資料
   ↓
使用 LINQ 處理
   ↓
回傳需要的結果形狀
~~~

例如：

~~~csharp
IEnumerable<int> GetExpensiveProductIds(
    List<Product> products,
    int minimumPrice)
{
    return products
        .Where(product => product.Price >= minimumPrice)
        .Select(product => product.Id);
}
~~~

這個 method：

- 接收 `List<Product>`
- 篩選價格符合條件的商品
- 將商品轉換成商品 ID
- 回傳多筆 `int`

這是一個：

> Filter → Project Pattern

---

## Coding Task

建立一個訂單清單，並完成：

~~~csharp
IEnumerable<string> GetUnpaidCustomerNames(
    List<Order> orders)
~~~

這個 method 必須：

1. 接收訂單集合。
2. 找出所有尚未付款的訂單。
3. 只回傳這些訂單的客戶名稱。
4. 不修改傳入的 `orders`。
5. 在主程式呼叫 method，使用 `foreach` 印出結果。

---

## 測試資料

請建立以下三筆訂單：

| 訂單編號 | 客戶名稱 | 金額 | 是否付款 |
|---|---|---:|---|
| 1001 | Alice | 2500 | 是 |
| 1002 | Bob | 1200 | 否 |
| 1003 | Carol | 3000 | 否 |

`Order` 至少需要以下 properties：

~~~csharp
class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = "";
    public int Price { get; set; }
    public bool IsPaid { get; set; }
}
~~~

---

## 實作要求

- method 名稱必須是 `GetUnpaidCustomerNames`
- parameter 型別為 `List<Order>`
- 回傳型別為 `IEnumerable<string>`
- LINQ 查詢寫在 method 內
- 使用兩個已學過的 LINQ API 完成查詢
- 不要在 method 內使用 `Console.WriteLine`
- 由呼叫端使用 `foreach` 顯示結果

---

## 預期輸出

~~~text
Bob
Carol
~~~

---

## 完成後請思考

1. 為什麼回傳型別是 `IEnumerable<string>`，不是 `IEnumerable<Order>`？
2. 如果只使用篩選、不進行資料轉換，回傳型別會變成什麼？
3. 這個 method 有沒有修改傳入的 `orders`？
4. 呼叫端只看 method 名稱與回傳型別，能不能大致理解它會得到什麼結果？

完成並執行成功後，把程式碼或截圖貼回來進行 Code Review。
