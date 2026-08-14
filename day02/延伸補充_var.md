# .NET Backend Daily — Daily 03

## 今日主題

**C# `var` 與型別推論（Type Inference）**

今天只學一個主要新知：

> 使用 `var` 宣告變數時，C# 可以根據右邊的值推論變數型別。

預計時間：10～15 分鐘。

---

# 1. 先回想昨天的寫法

昨天已經學過：

~~~csharp
int price = 100;
string productName = "Keyboard";
bool isAvailable = true;
~~~

C# 的基本宣告結構是：

~~~text
型別 變數名稱 = 值;
~~~

例如：

~~~csharp
int price = 100;
~~~

---

# 2. 今天的新知：`var`

C# 也可以寫：

~~~csharp
var price = 100;
var productName = "Keyboard";
var isAvailable = true;
~~~

Compiler 會根據右邊的值推論型別。

因此：

~~~csharp
var price = 100;
~~~

實際上 `price` 仍然是：

~~~csharp
int
~~~

而：

~~~csharp
var productName = "Keyboard";
~~~

實際上仍然是：

~~~csharp
string
~~~

---

# 3. 跟 TypeScript 對照

TypeScript：

~~~typescript
const price = 100;
const productName = "Keyboard";
const isAvailable = true;
~~~

TypeScript 可以從右邊推論：

~~~text
price       → number
productName → string
isAvailable → boolean
~~~

C#：

~~~csharp
var price = 100;
var productName = "Keyboard";
var isAvailable = true;
~~~

C# 也會從右邊推論：

~~~text
price       → int
productName → string
isAvailable → bool
~~~

---

# 4. 一個重要差異

不要把 C# 的 `var` 理解成 JavaScript 舊式的 `var`。

在 C#：

~~~csharp
var price = 100;
~~~

不是代表：

> price 沒有型別。

而是：

> Compiler 幫你推論出 price 是 `int`。

型別一旦決定，就不能突然換成其他型別。

例如：

~~~csharp
var price = 100;

// price 已經是 int
price = 200;
~~~

這是可以的。

但如果之後改成：

~~~csharp
price = "Apple";
~~~

就會發生編譯錯誤。

---

# 5. `var` 必須能推論型別

這樣可以：

~~~csharp
var price = 100;
~~~

因為 Compiler 看得出來 `100` 是什麼型別。

但不能只寫：

~~~csharp
var price;
~~~

因為 Compiler 沒有右邊的值可以判斷 `price` 到底是什麼型別。

---

# 6. Coding Task

今天建立一個簡單的「商品庫存資訊」。

請你自己宣告以下 3 個變數，而且**全部使用 `var`**：

~~~text
productName
price
isInStock
~~~

資料：

~~~text
商品名稱：Mechanical Keyboard
價格：2500
是否有庫存：true
~~~

然後使用：

~~~csharp
Console.WriteLine(...)
~~~

印出：

~~~text
商品名稱：Mechanical Keyboard
價格：2500
有庫存：True
~~~

---

# 7. 實作要求

請自己完成 `Program.cs`。

限制：

1. 三個變數都使用 `var`
2. 不直接寫 `string`、`int`、`bool`
3. 不需要 List
4. 不需要 foreach
5. 不需要 if
6. 不需要 LINQ
7. 不需要建立 class

今天只專注：

~~~text
var
 ↓
Compiler 型別推論
 ↓
變數仍然具有固定型別
~~~

---

# 8. 驗證

執行：

~~~bash
dotnet run --project day03/day03.csproj
~~~

預期結果：

~~~text
商品名稱：Mechanical Keyboard
價格：2500
有庫存：True
~~~

---

# 9. 額外小實驗

主題完成後，再做一個 30 秒實驗。

假設你有：

~~~csharp
var price = 2500;
~~~

嘗試在下面加入：

~~~csharp
price = "2500";
~~~

然後執行程式。

觀察 Compiler 怎麼說。

**先不要急著修正。**

今天真正要確認的觀念就是：

> `var` 省略的是「型別名稱的書寫」，不是讓變數變成「沒有固定型別」。

---

# 卡住時

先不要查完整答案。

依序回來跟我說：

~~~text
提示1
~~~

如果還是不行：

~~~text
提示2
~~~

最後真的卡住再說：

~~~text
完整答案
~~~

完成後，把你的 `Program.cs` 貼回來，我們做 Daily 03 Code Review。

--

## 個人筆記

~~~csharp
// 看右邊，推論左邊
var prices = new List<int>();
//  ↑              ↑
// 推論成          明確知道是 List<int>
// List<int>
~~~
另一種：
~~~csharp
// 看左邊，推論右邊
List<int> prices = new();
//   ↑              ↑
// 明確知道型別      推論要 new List<int>()
~~~
所以可以先記成：

~~~csharp
var = 右 → 左
new() = 左 → 右
~~~
而且這也解釋了為什麼這個不行：
~~~csharp
var prices = new(); // ❌
~~~

因為兩邊都在互看：
~~~csharp
var：「你右邊告訴我型別啊」
new()：「你左邊告訴我型別啊」
~~~

兩個：？？？？？

Compiler：你們兩個是在看三小。 XDDD

這個觀察很值得留著，之後看到 C# 簡寫會很好用。