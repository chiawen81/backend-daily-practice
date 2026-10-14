
# Day28 — Dictionary + foreach

## 1. 今日主題

Dictionary<TKey, TValue> 的遍歷與 Key–Value 存取。

### 學習目標

- 理解 Dictionary 裡每筆資料都是 Key–Value Pair。
- 能使用 foreach 遍歷 Dictionary。
- 能取得每筆資料的 Key 與 Value。
- 理解 Dictionary 與 List 在遍歷時的差異。

---

## 2. 必要新知

之前已經學過：

~~~csharp
var productPrices = new Dictionary<int, int>
{
    { 101, 30000 },
    { 102, 1200 },
    { 103, 2500 }
};

var price = productPrices[101];
~~~

這裡：

- Key：ProductId（int）
- Value：Price（int）

但如果今天想取得 Dictionary 裡的「所有商品」呢？

可以使用 foreach。

### 範例

~~~csharp
var scores = new Dictionary<string, int>
{
    { "Alice", 90 },
    { "Bob", 75 },
    { "Charlie", 85 }
};

foreach (var item in scores)
{
    Console.WriteLine($"{item.Key}: {item.Value}");
}
~~~

預期輸出：

~~~text
Alice: 90
Bob: 75
Charlie: 85
~~~

### 心智模型

List<T>：

~~~csharp
foreach (var item in products)
{
    // item 是一個 Product
}
~~~

Dictionary<TKey, TValue>：

~~~csharp
foreach (var item in scores)
{
    // item 是 KeyValuePair<string, int>
    // item.Key   → string
    // item.Value → int
}
~~~

重點：

Dictionary 的每個元素並非單純的 Value，而是一組 Key–Value Pair。

---

## 3. Coding Task

### 業務情境

電商後端已經取得一份商品價格對照表。

現在需要產生一份簡單的商品價格清單，並標示商品是否屬於高價商品。

高價商品定義：價格 >= 5000。

### 起始資料

~~~csharp
var productPrices = new Dictionary<int, int>
{
    { 101, 30000 },
    { 102, 1200 },
    { 103, 2500 },
    { 104, 8000 }
};
~~~

### 實作要求

請自行撰寫：

~~~csharp
void PrintProductPrices(
    Dictionary<int, int> productPrices)
{
    // TODO
}
~~~

要求：

1. 使用 foreach 遍歷 Dictionary。
2. 取得每筆資料的 ProductId 與 Price。
3. 使用 if / else 判斷是否為高價商品。
4. 使用 Console.WriteLine() 輸出結果。
5. 在主程式呼叫 PrintProductPrices()。

限制：

- 不需要 LINQ。
- 不需要建立新的 List。
- 不需要使用 TryGetValue()。
- 不需要新增其他 class。

---

## 4. 預期結果

~~~text
ProductId: 101, Price: 30000, 高價商品
ProductId: 102, Price: 1200, 一般商品
ProductId: 103, Price: 2500, 一般商品
ProductId: 104, Price: 8000, 高價商品
~~~

注意：Dictionary 不應被當作依插入順序處理資料的業務保證，本題不要求排序。

---

## 5. 驗證方式

執行：

~~~bash
dotnet run
~~~

確認：

- 四筆商品皆有輸出。
- ProductId 與 Price 對應正確。
- 101、104 被判斷為高價商品。
- 102、103 被判斷為一般商品。

---

## 6. 完成後思考

請觀察：

1. foreach 裡面的 item 是什麼型別？
2. item.Key 和 item.Value 分別是什麼型別？
3. 如果 Dictionary 的 Value 改成 Product 物件，item.Value 會變成什麼型別？

先完成 Coding Task，不需要提前回答。
