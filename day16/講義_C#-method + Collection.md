# Day16 — Method + Collection

## 今日主題

將 Collection 傳入 method，並回傳處理後的 Collection。

昨天的 method 處理的是「一筆訂單」：

~~~csharp
bool IsEligibleForFreeShipping(Order order)
{
    return order.IsPaid && order.Price >= 2000;
}
~~~

今天要進一步處理「多筆訂單」：

~~~text
List<Order>
    ↓ 傳入 method
使用 LINQ 篩選
    ↓
IEnumerable<Order>
~~~

---

## 必要新知：Collection 也能作為 parameter 與 return value

過去傳入 method 的 parameter 是單一物件：

~~~csharp
bool IsEligibleForFreeShipping(Order order)
~~~

Collection 本身也是一種型別，因此也能傳入 method：

~~~csharp
IEnumerable<Product> GetExpensiveProducts(List<Product> products)
{
    return products.Where(product => product.Price >= 1000);
}
~~~

這個 method 的結構是：

~~~text
IEnumerable<Product>  → 回傳值型別
GetExpensiveProducts  → method 名稱
List<Product> products → 傳入的集合
~~~

使用方式：

~~~csharp
var expensiveProducts = GetExpensiveProducts(products);

foreach (var product in expensiveProducts)
{
    Console.WriteLine(product.Name);
}
~~~

### TypeScript 對照

概念類似：

~~~typescript
function getExpensiveProducts(products: Product[]): Product[] {
    return products.filter(product => product.price >= 1000);
}
~~~

差別是 C# 需要明確寫出：

- 傳入集合的型別：`List<Product>`
- 回傳集合的型別：`IEnumerable<Product>`

---

## Coding Task

延續 Day15 的訂單資料，建立一個 method：

~~~csharp
GetFreeShippingOrders(...)
~~~

這個 method 必須：

1. 接收完整的 `List<Order>`。
2. 使用 `Where` 篩選訂單。
3. 在 `Where` 裡呼叫昨天的 `IsEligibleForFreeShipping`。
4. 回傳所有符合免運資格的訂單。
5. 主程式呼叫 `GetFreeShippingOrders`。
6. 使用 `foreach` 印出符合資格的訂單資訊。

---

## 測試資料

請建立以下三筆訂單：

| Id | CustomerName | Price | IsPaid |
|---|---|---:|---|
| 1001 | Alice | 2500 | true |
| 1002 | Bob | 1200 | false |
| 1003 | Cindy | 3000 | false |

---

## 實作要求

請保留並使用昨天的判斷 method：

~~~csharp
bool IsEligibleForFreeShipping(Order order)
{
    // 由你完成或貼入昨天的版本
}
~~~

接著自行完成以下 method：

~~~csharp
IEnumerable<Order> GetFreeShippingOrders(List<Order> orders)
{
    // 使用 Where
    // 在篩選條件中呼叫 IsEligibleForFreeShipping
    // 回傳篩選結果
}
~~~

主程式只能透過下面這個 method 呼叫取得結果：

~~~csharp
var freeShippingOrders = GetFreeShippingOrders(orders);
~~~

不要在主程式重新撰寫：

~~~csharp
order.IsPaid && order.Price >= 2000
~~~

避免同一條業務規則散落在不同位置。

---

## 預期結果

執行後應只輸出：

~~~text
訂單 1001｜Alice｜2500 元｜符合免運資格
~~~

Bob 金額不足且未付款，Cindy 雖然金額足夠但尚未付款，因此都不應出現在結果中。

---

## 驗證方式

~~~bash
dotnet run --project day16/day16.csproj
~~~

確認：

- 程式可以成功編譯。
- `GetFreeShippingOrders` 接收的是整個訂單集合。
- `GetFreeShippingOrders` 回傳的是篩選後的集合。
- `Where` 內有重用 `IsEligibleForFreeShipping`。
- 最後只印出 Alice 的訂單。

---

## 今日 Backend Coding Pattern

### Collection Input → Result Output

~~~text
集合傳入 method
    ↓
集中執行查詢或資料處理
    ↓
回傳符合需求的結果
~~~

這是後端常見的 method 形狀：

~~~csharp
IEnumerable<T> GetSomething(List<T> items)
{
    return items.Where(...);
}
~~~

### Method Composition

~~~text
GetFreeShippingOrders
    ↓ 處理整個集合
IsEligibleForFreeShipping
    ↓ 判斷單筆訂單
bool
~~~

大 method 負責流程，小 method 集中保存單一判斷規則。