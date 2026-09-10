# Day19 — HashSet<T> 基礎：不重複的集合

## 今日主題

今天第一次正式學：

`HashSet<T>`

這是一個新的 Collection 型別。

今天先不要急著學很多 API。

只建立一個最重要的 baseline：

> `List<T>` 可以保存重複資料；`HashSet<T>` 的核心特性是「集合中的值不重複」。

---

# 1. 先從已知的 List<T> 開始

你已經很熟悉：

~~~csharp
var productIds = new List<int>()
{
    101,
    102,
    101
};
~~~

這是合法的。

List 裡面可以存在：

~~~text
101
102
101
~~~

也就是：

~~~text
List<T>
→ 可以有重複值
~~~

---

# 2. HashSet<T> 是什麼？

最小宣告方式：

~~~csharp
var productIds = new HashSet<int>()
{
    101,
    102,
    101
};
~~~

看起來跟 List 很像：

~~~text
List<int>

HashSet<int>
~~~

但 HashSet 有一個非常重要的規則：

> 同一個值只會存在一次。

因此上面的 HashSet 實際內容會是：

~~~text
101
102
~~~

不是：

~~~text
101
102
101
~~~

---

# 3. 最重要的心智模型

先暫時把它們想成：

~~~text
List<T>
│
├─ 一組資料
└─ 可以重複


HashSet<T>
│
├─ 一組資料
└─ 每個值只保留一份
~~~

例如：

~~~text
List<int>

101
101
102
103
103


HashSet<int>

101
102
103
~~~

---

# 4. 和 TypeScript 的關係

TypeScript / JavaScript 其實也有相近的：

~~~typescript
const ids = new Set<number>();

ids.add(101);
ids.add(102);
ids.add(101);
~~~

最後仍然只有：

~~~text
101
102
~~~

所以概念上可以先建立：

~~~text
TypeScript / JavaScript       C#

Set<T>                    →   HashSet<T>
Array / Array<T>          →   List<T>（概念上的近似對照）
~~~

不過你過去沒有實際使用過 TS 的 `Set`，所以今天不把它當成已知概念，只拿來建立語言對照。

---

# 5. 今天唯一的新 API：Add()

HashSet 也可以：

~~~csharp
var ids = new HashSet<int>();

ids.Add(101);
ids.Add(102);
ids.Add(101);
~~~

這裡有一個和 List 很有意思的差異。

`HashSet<T>.Add()` 會回傳 `bool`：

~~~csharp
bool result = ids.Add(101);
~~~

意思是：

~~~text
true
→ 這次真的新增進去了

false
→ 這個值原本就存在，所以沒有新增
~~~

例如：

~~~csharp
var ids = new HashSet<int>();

bool result1 = ids.Add(101);
bool result2 = ids.Add(101);

Console.WriteLine(result1);
Console.WriteLine(result2);
~~~

結果：

~~~text
True
False
~~~

因為第二次加入 `101` 時：

~~~text
HashSet 已經有 101
        ↓
不允許重複
        ↓
沒有新增
        ↓
Add() 回傳 false
~~~

---

# 6. Coding Task

## 情境

假設後端收到一批「使用者選取的商品 ID」。

資料裡可能重複出現同一個 ID：

~~~text
101
102
101
103
102
104
~~~

我們希望最後只留下：

~~~text
101
102
103
104
~~~

---

## Task

請建立：

~~~csharp
var selectedProductIds = new HashSet<int>();
~~~

然後依序使用 `Add()` 加入：

~~~text
101
102
101
103
102
104
~~~

每次呼叫 `Add()` 時：

1. 接住 `Add()` 回傳的 `bool`
2. 印出：
   - 要加入的 ID
   - 是否成功新增

最後再使用你已經學過的 `foreach`：

印出 HashSet 中實際存在的所有 ID。

---

# 7. 預期觀察結果

你應該會觀察到：

~~~text
第一次加入 101 → True
第一次加入 102 → True

第二次加入 101 → False

第一次加入 103 → True

第二次加入 102 → False

第一次加入 104 → True
~~~

最後集合裡只有：

~~~text
101
102
103
104
~~~

---

# 8. 實作要求

今天只需要使用：

- `HashSet<int>`
- `Add()`
- `bool`
- `foreach`
- `Console.WriteLine()`

不要使用：

- LINQ
- `Distinct()`
- Dictionary
- 其他去重方法

今天的目的不是「想辦法把資料去重」。

而是親手觀察：

> HashSet 本身就不允許相同的值重複存在。

---

# 9. 今天完成後要能回答

不用現在回答，寫完程式後再一起確認：

1. `List<int>` 和 `HashSet<int>` 最核心的差異是什麼？
2. 同一個值 `Add()` 兩次，HashSet 最後會有幾份？
3. 為什麼 `HashSet<T>.Add()` 回傳 `bool`？
4. 第二次加入相同值時，為什麼會得到 `false`？

---

# 今日目標

今天先只建立：

List<T>
    ↓
「一組資料」

HashSet<T>
    ↓
「一組不重複的資料」

先不要急著記 HashSet 的其他 API。

等這個心智模型穩定後，再繼續學它在 Backend 中真正很常見的用途：
「快速判斷某個 ID 是否存在於一組 ID 裡」。
