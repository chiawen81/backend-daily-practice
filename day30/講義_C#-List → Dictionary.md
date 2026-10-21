# Day30 — List → Dictionary 資料轉換

## 1. 今日主題

**Collection / Data Transformation Retrieval**

今天練習一個後端常見情境：

從資料庫取得 List<Product>，
轉換成 Dictionary<int, Product>，
方便後續依 ProductId 查找商品。

---

## 2. 必要新知：ToDictionary()

先前已經學過：

- List<T>：保存多筆資料
- Dictionary<TKey, TValue>：透過 Key 查找 Value
- Select()：將資料轉換成其他形狀

今天新增一個 LINQ API：

`ToDictionary()`

用途：將集合轉換成 Dictionary。

### 最小範例

~~~csharp
var users = new List<User>
{
    new User { Id = 1, Name = "Alice" },
    new User { Id = 2, Name = "Bob" }
};

var userDictionary = users.ToDictionary(
    user => user.Id,
    user => user.Name
);

Console.WriteLine(userDictionary[1]); // Alice

class User
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}
~~~

### 理解轉換結果

原本：

List<User>

轉換後：

Dictionary<int, string>

- Key：User.Id
- Value：User.Name

也可以省略第二個參數：

~~~csharp
var userDictionary = users.ToDictionary(
    user => user.Id
);
~~~

此時型別為：

Dictionary<int, User>

Value 會保留整個 User 物件。

注意：Dictionary 的 Key 不可重複。
若 ToDictionary() 遇到重複的 Key，
會拋出 ArgumentException。

---

## 3. Coding Task

### 業務情境

後端從資料庫取得商品清單。

現在需要建立一個商品 Lookup Dictionary，
讓其他程式可以快速透過 ProductId 查詢商品。

### 初始資料

~~~csharp
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop", Price = 30000 },
    new Product { Id = 102, Name = "Mouse", Price = 1200 },
    new Product { Id = 103, Name = "Keyboard", Price = 2500 }
};

var requestedProductIds = new List<int>
{
    102, 103, 999
};

class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
~~~

### 實作要求

1. 使用 ToDictionary() 將 products 轉換成
   Dictionary<int, Product>。

2. 使用 foreach 遍歷 requestedProductIds。

3. 使用 TryGetValue() 查詢商品。

4. 查詢成功時印出商品名稱與價格。

5. 查詢失敗時印出 Product not found。

### 預期結果

~~~text
Mouse - 1200
Keyboard - 2500
Product not found: 999
~~~

---

## 4. 驗證方式

在 VS Code 執行：

~~~bash
dotnet run
~~~

確認：

- 程式可正常編譯
- Dictionary Key 是 Product.Id
- Dictionary Value 是 Product 物件
- 不存在的 ProductId 不會造成例外
- 輸出符合預期結果

---

## 5. 完成後思考

這題不用另外寫答案，Code Review 時討論即可。

1. 為什麼這裡適合使用 Dictionary？
2. 如果只查詢一次，還有必要先轉 Dictionary 嗎？
3. ToDictionary() 和 Select() 的轉換目的有什麼不同？

今天的 Backend Coding Pattern：

**Collection → Lookup Dictionary → Safe Lookup**

實務用途：
將資料庫查詢結果建立成記憶體中的 Lookup，
方便後續多次依 ID 查找資料。
