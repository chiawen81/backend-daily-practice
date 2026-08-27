# Day10 — LINQ `FirstOrDefault()`：從集合找出第一筆資料

## 今日主題

今天只學一個新的 LINQ 方法：

```csharp
FirstOrDefault()
```

前面學過：

```text
Where()     → 篩選出符合條件的「一批資料」
Any()       → 判斷是否「至少存在一筆」
Contains()  → 判斷集合是否「包含某個值」
Select()    → 把資料「轉換成另一種結果」
```

今天加入：

```text
FirstOrDefault() → 找出符合條件的「第一筆資料」
```

---

# 1. `FirstOrDefault()` 是什麼？

假設有：

~~~csharp
var numbers = new List<int> { 10, 20, 30, 40 };
~~~

如果想找：

> 第一個大於 20 的數字

可以寫：

~~~csharp
var result = numbers.FirstOrDefault(number => number > 20);
~~~

結果：

~~~text
30
~~~

它的思考方式可以理解成：

```text
numbers
   ↓
逐筆檢查
   ↓
number > 20 ?
   ↓
找到第一筆符合條件的資料
   ↓
停止搜尋
   ↓
回傳該資料
```

---

# 2. 跟 `Where()` 有什麼差別？

這兩個很像，但「想拿到的結果」不同。

### `Where()`

~~~csharp
var result = numbers.Where(number => number > 20);
~~~

意思：

> 把所有大於 20 的資料找出來。

結果是一個集合：

~~~text
30
40
~~~

---

### `FirstOrDefault()`

~~~csharp
var result = numbers.FirstOrDefault(number => number > 20);
~~~

意思：

> 找到第一個大於 20 的資料就好。

結果：

~~~text
30
~~~

所以可以先建立這個判斷：

```text
我要一批符合條件的資料
        ↓
      Where()

我要第一筆符合條件的資料
        ↓
 FirstOrDefault()
```

---

# 3. 為什麼叫 `OrDefault`？

這是今天最重要的新概念。

如果沒有任何資料符合條件：

~~~csharp
var numbers = new List<int> { 10, 20, 30 };

var result = numbers.FirstOrDefault(number => number > 100);
~~~

因為找不到符合條件的資料，所以它會回傳該型別的：

```text
default value
```

例如 `int` 的 default 是：

~~~text
0
~~~

因此上面的 `result` 會是：

~~~text
0
~~~

---

## 如果集合裡放的是物件呢？

例如：

~~~csharp
var products = new List<Product>
{
    new() { Id = 101, Name = "Laptop", Price = 30000 },
    new() { Id = 102, Name = "Mouse", Price = 1200 },
    new() { Id = 103, Name = "Keyboard", Price = 2500 }
};

var product = products.FirstOrDefault(item => item.Id == 999);
~~~

找不到 `Id == 999` 的 Product。

這種情況下：

~~~text
product
  ↓
null
~~~

今天先知道：

> `FirstOrDefault()` 找不到物件時，可能得到 `null`。

`null` 的正式處理方式會在後續 Daily 再練，今天先不要提前展開。

---

# 4. 今天的 Coding Task

有以下商品資料：

~~~text
101 Laptop    30000
102 Mouse      1200
103 Keyboard   2500
~~~

請找出：

> `Id == 102` 的第一個商品

然後印出：

~~~text
Product: Mouse
Price: 1200
~~~

---

# 實作要求

請自己建立新的 Console Project，並完成以下內容。

### 1. 建立 `Product`

需要：

~~~text
Id
Name
Price
~~~

型別請使用之前已經用過的型別。

---

### 2. 建立 `productList`

資料：

~~~text
Id: 101
Name: Laptop
Price: 30000

Id: 102
Name: Mouse
Price: 1200

Id: 103
Name: Keyboard
Price: 2500
~~~

---

### 3. 使用今天的新知 `FirstOrDefault()`

請找：

~~~text
Id == 102
~~~

的第一個 Product。

限制：

- 不使用 `Where()`
- 不使用 `foreach` 自己搜尋
- 直接使用 `FirstOrDefault(condition)`

---

### 4. 印出結果

預期：

~~~text
Product: Mouse
Price: 1200
~~~

---

# 今天可以直接使用的語法

今天的新語法：

~~~csharp
collection.FirstOrDefault(item => condition);
~~~

例如：

~~~csharp
var number = numbers.FirstOrDefault(item => item > 20);
~~~

但是 Coding Task 中 `Product` 的完整寫法請自己完成。

---

# 驗證方式

執行：

~~~bash
dotnet run
~~~

成功時應看到：

~~~text
Product: Mouse
Price: 1200
~~~

---

# 今天真正要練的判斷

不要只記 API 名稱。

看到需求：

```text
從一批資料中
找符合條件的「第一筆」
```

要開始想到：

```csharp
FirstOrDefault(...)
```

今天先建立：

```text
一批符合條件
    ↓
Where()

第一筆符合條件
    ↓
FirstOrDefault()
```

---

# 卡住時

先不要直接查完整答案。

依序：

```text
提示1
  ↓
提示2
  ↓
完整答案
```

完成後把 `Program.cs` 或執行結果貼回來做 Day10 Code Review。