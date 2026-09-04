# Day15 — Method 基礎：parameter 與 return value

## 今日主題

今天只學一個主要概念：

> 把一段可重複執行的邏輯包成 method（方法）。

你在 TypeScript 已經使用過 function；C# 的 method 概念相近，但參數與回傳值都需要明確標示型別。

---

## 1. Method 是什麼？

假設程式需要多次判斷商品是否屬於高價商品。

如果每次都重寫判斷：

~~~csharp
product.Price >= 10000
~~~

可以把這段行為包成 method：

~~~csharp
bool IsExpensiveProduct(Product product)
{
    return product.Price >= 10000;
}
~~~

呼叫 method：

~~~csharp
var result = IsExpensiveProduct(product);
~~~

---

## 2. Method 的基本結構

~~~csharp
回傳型別 Method名稱(參數型別 參數名稱)
{
    return 回傳值;
}
~~~

套用到剛才的範例：

~~~csharp
bool IsExpensiveProduct(Product product)
{
    return product.Price >= 10000;
}
~~~

各部分的意思：

- `bool`：這個 method 執行後會回傳 `bool`
- `IsExpensiveProduct`：method 名稱
- `Product product`：接收一個 `Product` object 作為參數
- `return`：將判斷結果交回呼叫的位置

---

## 3. TypeScript → C# 對照

TypeScript：

~~~typescript
function isExpensiveProduct(product: Product): boolean {
    return product.price >= 10000;
}
~~~

C#：

~~~csharp
bool IsExpensiveProduct(Product product)
{
    return product.Price >= 10000;
}
~~~

主要差異：

- C# 的回傳型別寫在 method 名稱前面。
- C# 的參數寫成「型別在前、名稱在後」。
- C# method 通常使用 PascalCase 命名。

---

# Coding Task

請建立兩筆訂單：

1. 訂單 1001
   - 客戶：Alice
   - 金額：2500
   - 已付款

2. 訂單 1002
   - 客戶：Bob
   - 金額：1200
   - 未付款

接著建立一個 method：

~~~csharp
bool IsEligibleForFreeShipping(Order order)
~~~

## 判斷規則

訂單必須同時符合以下條件，才具有免運資格：

- 已付款
- 訂單金額大於或等於 2000

請分別將兩筆訂單傳入 method，並輸出判斷結果。

---

## 實作要求

1. 建立 `Order` class。
2. 使用 Object Initializer 建立兩個不同的 `Order` object。
3. 建立 `IsEligibleForFreeShipping` method。
4. method 接收一個 `Order` parameter。
5. method 回傳 `bool`。
6. 在 method 內根據訂單資料完成判斷。
7. 在主程式呼叫 method 並輸出結果。

---

## 預期結果

~~~text
Order 1001 free shipping: True
Order 1002 free shipping: False
~~~

輸出文字不必完全相同，但判斷結果必須是：

- 訂單 1001：`True`
- 訂單 1002：`False`

---

## 今日驗證重點

完成後，試著指出下面四個位置：

1. Method 名稱
2. Parameter
3. Return type
4. Return value

今天先不要使用 LINQ，也不需要把訂單放進 `List<Order>`。

目標是先建立最小心智模型：

> object 保存資料，method 接收資料並執行行為。