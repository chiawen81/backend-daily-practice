# Day25 — 綜合 Pattern Retrieval

## 今日主題

**從需求自己選擇 Collection / LINQ Pattern**

今天不學新的 LINQ API。

你已經學過：

- `Where`
- `Any`
- `Contains`
- `FirstOrDefault`
- `HashSet<T>`
- `Intersect`
- `Except`
- method
- null handling
- Guard Clause

今天不告訴你「這一題要用哪個」。

你要先判斷：

> 需求到底是在找「多筆」、「一筆」、「是否存在」，還是在比較「兩組 ID」？

---

## Coding Task

現在有：

1. 系統中實際存在的商品
2. 使用者送來想購買的 ProductId

~~~csharp
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop", Price = 30000 },
    new Product { Id = 102, Name = "Mouse", Price = 1200 },
    new Product { Id = 103, Name = "Keyboard", Price = 2500 },
    new Product { Id = 104, Name = "Monitor", Price = 8000 }
};

var requestedProductIds = new HashSet<int>
{
    101,
    103,
    999
};

class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

請實作：

~~~csharp
void PrintOrderCheck(
    IEnumerable<Product> products,
    HashSet<int> requestedProductIds)
{
    // TODO
}
~~~

---

## 實作要求

`PrintOrderCheck()` 要完成兩件事。

### 1. 印出「存在而且被要求購買」的商品

以上面的資料來說：

~~~text
Laptop
Keyboard
~~~

### 2. 找出 requestedProductIds 中不存在的 ProductId

以上面的資料來說：

~~~text
Product 999 not found
~~~

如果沒有任何不存在的 ProductId：

~~~text
All requested products exist
~~~

---

## 限制

今天是 Retrieval，所以：

- 不提供應該使用哪些 LINQ API
- 不提供完整 Pattern
- 不要求追求最短寫法
- 可以建立中間變數
- 可以拆成幾個步驟處理

優先寫出你自己看得懂的版本。

---

## 寫之前先想 30 秒

不要立刻開始敲 LINQ。

先判斷：

~~~text
需求 A：
我要從 products 中取得「符合 requestedProductIds 的商品」

我要的是：
□ 一筆
□ 多筆
□ bool
□ 兩組集合的差異


需求 B：
我要知道 requestedProductIds 裡面
「哪些 ID 不存在於系統商品」

我要的是：
□ 一筆
□ 多筆
□ bool
□ 兩組集合的差異
~~~

再決定要拿哪些已經學過的 Pattern。

---

## 預期結果

~~~text
Requested products:
Laptop
Keyboard

Missing products:
Product 999 not found
~~~

---

## 驗證方式

完成後，再把：

~~~csharp
999
~~~

改成：

~~~csharp
104
~~~

重新執行。

這時應該看到：

~~~text
Requested products:
Laptop
Keyboard
Monitor

All requested products exist
~~~

如果兩組情境都正確，就把程式碼貼回來做 Day25 Review。
