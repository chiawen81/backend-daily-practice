# Day31 — Dictionary + HashSet 跨集合比對

## 1. 今日主題

Collection / Data Transformation Retrieval

今天的目標：

從商品清單、可販售商品 ID，以及前端要求的商品 ID，
找出真正可以販售的商品，並取得商品詳細資料。

複習：
- List<T>
- ToDictionary()
- HashSet<T>
- Contains()
- TryGetValue()
- foreach / method

今天不新增 API。

---

## 2. 必要知識回顧

### Dictionary：依 Key 查找資料

~~~csharp
var productLookup = products.ToDictionary(p => p.Id);
~~~

用途：依照 ProductId 快速取得 Product 物件。

### HashSet：判斷 ID 是否存在

~~~csharp
var availableIds = new HashSet<int> { 101, 103 };

bool isAvailable = availableIds.Contains(101);
~~~

用途：判斷某個 ProductId 是否在可販售清單內。

### 組合 Pattern

今天要自己思考：

當需要同時滿足「商品存在」與「允許販售」時，
應該如何結合 Dictionary 與 HashSet？

---

## 3. Coding Task — 商品販售資格查詢

### 業務情境

前端送來一批想購買的商品 ID。

後端需要確認：

1. 商品是否存在於商品資料中？
2. 商品是否在可販售清單內？
3. 符合條件時，印出商品名稱與價格。

### 初始資料

~~~csharp
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop", Price = 30000 },
    new Product { Id = 102, Name = "Mouse", Price = 1200 },
    new Product { Id = 103, Name = "Keyboard", Price = 2500 },
    new Product { Id = 104, Name = "Monitor", Price = 8000 }
};

// 目前允許販售的商品
var availableProductIds = new HashSet<int>
{
    101, 103, 104
};

// 前端要求購買的商品
var requestedProductIds = new List<int>
{
    101, 102, 103, 999
};
~~~

### Product 型別

~~~csharp
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

---

## 4. 實作要求

### Task 1 — 建立 Lookup

將 products 轉換成：

Dictionary<int, Product>

Key 使用 Product.Id。

### Task 2 — 實作 Method

~~~csharp
void PrintOrderCheck(
    Dictionary<int, Product> productLookup,
    HashSet<int> availableProductIds,
    IEnumerable<int> requestedProductIds)
{
    // TODO：自行完成
}
~~~

針對每個 requestedProductId：

- 商品不存在 → 印出 Not Found
- 商品存在但不可販售 → 印出 Not Available
- 商品存在且可販售 → 印出商品詳細資料

### 限制

- 必須使用 Dictionary 與 HashSet
- 必須使用 TryGetValue() 安全查詢商品
- 必須使用 Contains() 判斷販售資格
- 不需要新增其他 class
- 不使用新的 LINQ API
- 不需要連接 Database

---

## 5. 預期結果

~~~text
ProductId: 101, Name: Laptop, Price: 30000
ProductId: 102, Not Available
ProductId: 103, Name: Keyboard, Price: 2500
ProductId: 999, Not Found
~~~

---

## 6. 驗證方式

在 day31 Console Project：

1. 完成實作。
2. 執行 dotnet run。
3. 確認輸出符合預期。
4. 確認不存在的商品不會造成例外。
5. 確認不可販售的商品不會被當成有效商品。

---

## 7. 今日 Backend Coding Pattern

### Lookup + Membership Validation

常見業務場景：

- 訂單商品資格檢查
- 使用者權限檢查
- 商品可販售狀態驗證
- 批次資料驗證

核心思路：

Dictionary → 取得資料
HashSet → 驗證是否屬於允許集合

這是記憶體中的資料處理 Pattern，
不代表所有 Database 查詢都應先轉成 Dictionary。

---

## 8. 完成後思考題

如果今天有 10,000 筆商品資料，
但前端只要求查詢 1 個 ProductId：

你還會先把整個 List 轉成 Dictionary 嗎？

為什麼？

這題不需要寫程式，完成後一起討論。
