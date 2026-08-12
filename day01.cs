/*
Daily 01 — List<T> + foreach

題目：
有一組商品價格：

120, 80, 250, 40, 300

需求：
1. 使用 List<int> 保存這 5 個價格。
2. 使用 foreach 逐筆讀取價格。
3. 只將大於等於 100 的價格加入 result。
4. 最後印出 result。

預期結果：
120, 250, 300

----------------------------------------
本日實際學習紀錄
----------------------------------------

【List<T>】

C# 的 List<T> 是可以動態新增、刪除元素的集合。

TypeScript：
const prices: number[] = [];

C#：
List<int> prices = new();

----------------------------------------

【new()】

完整寫法：

List<int> prices = new List<int>();

因為左側已經知道型別是 List<int>，
C# 可以簡寫成：

List<int> prices = new();

----------------------------------------

【Collection Initializer】

可以在建立 List 時直接放入初始資料：

List<int> prices = new()
{
    120,
    80,
    250
};

這裡的 { } 不是 JavaScript / TypeScript 的 Object，
而是 C# 的 Collection Initializer。

----------------------------------------

【Add()】

往 List 加入一筆資料：

prices.Add(300);

概念上類似 TypeScript：

prices.push(300);

----------------------------------------

【foreach】

逐筆走訪集合：

foreach (var price in prices)
{
    Console.WriteLine(price);
}

概念上類似處理 TypeScript Array 中的每個元素。

----------------------------------------

今日觀察：

foreach、if 等 Programming Concept 已有 TypeScript 基礎。

目前主要需要建立的是 C# Syntax Fluency，例如：

- List<T>
- new()
- Collection Initializer
- Add()

之後新 C# 語法第一次出現時，先學習最小語法與使用方式；
後續再次遇到時，再透過 Retrieval 自己回想與實作。
*/

List<int> priceList = new()
{ 120, 80, 250, 40, 300 };

List<int> result= new() {};

foreach (var item in priceList)
{
    Console.WriteLine($"目前的值:{item}");

    if (item >= 100) {
        result.Add(item);
    };
};


Console.WriteLine($"===篩選結果：{string.Join(", ", result)}===");