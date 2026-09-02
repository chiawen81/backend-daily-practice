# Day14 — 建立多個物件：Object Initializer 與巢狀 Object

## 今日主題

今天練習：

- 由同一個 `class` 建立多個不同的 object
- 使用 Object Initializer 設定 property
- 建立巢狀 object

今天的核心心智模型：

```text
class Order
    │
    ├─ new Order(...) → order1
    ├─ new Order(...) → order2
    └─ new Order(...) → order3
```

同一個 `class` 是共同的型別藍圖，但每次 `new` 都會建立一個獨立的 object／instance。

---

## 必要新知：巢狀 Object

一個 object 的 property，也可以是另一個自訂型別的 object。

例如：

~~~csharp
class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}

class Order
{
    public int Id { get; set; }
    public Customer Customer { get; set; } = new();
}
~~~

建立 `Order` 時，也可以在裡面建立 `Customer`：

~~~csharp
var exampleOrder = new Order
{
    Id = 1001,
    Customer = new Customer
    {
        Id = 1,
        Name = "Alice"
    }
};
~~~

資料結構可以想成：

```text
Order object
├─ Id
└─ Customer
   ├─ Id
   └─ Name
```

存取巢狀 property：

~~~csharp
Console.WriteLine(exampleOrder.Customer.Name);
~~~

對照 TypeScript：

~~~typescript
console.log(exampleOrder.customer.name);
~~~

兩者都是沿著 object 的 property 一層一層取得資料。

---

## Coding Task

建立一份包含三筆訂單的 `List<Order>`，每筆訂單都要包含一個 `Customer` object。

### 資料內容

#### 訂單 1001

- 客戶 ID：1
- 客戶名稱：Alice
- 訂單金額：2500
- 已付款：是

#### 訂單 1002

- 客戶 ID：2
- 客戶名稱：Bob
- 訂單金額：1200
- 已付款：否

#### 訂單 1003

- 客戶 ID：3
- 客戶名稱：Cindy
- 訂單金額：3600
- 已付款：是

---

## 實作要求

1. 建立 `Customer` class，包含：

   - `Id`
   - `Name`

2. 建立 `Order` class，包含：

   - `Id`
   - `Customer`
   - `TotalAmount`
   - `IsPaid`

3. 建立一個 `List<Order>`。

4. 使用 Object Initializer 建立三個不同的 `Order` object。

5. 每個 `Order` 裡都要建立對應的 `Customer` object。

6. 使用 `foreach` 輸出每筆訂單：

   - 訂單編號
   - 客戶名稱
   - 訂單金額
   - 是否付款

---

## 預期結果

執行結果包含以下資訊即可，排版不必完全相同：

```text
訂單編號：1001，客戶：Alice，金額：2500，已付款：True
訂單編號：1002，客戶：Bob，金額：1200，已付款：False
訂單編號：1003，客戶：Cindy，金額：3600，已付款：True
```

---

## 完成後確認

完成後，試著用自己的話回答：

1. 三筆訂單是三個不同的 object，還是同一個 object？
2. `Order.Customer.Name` 分別經過了哪些 object 與 property？
3. `Customer` property 的型別為什麼不是 `string`？

卡住時依序向我索取：

```text
提示1 → 提示2 → 完整答案
```