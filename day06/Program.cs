Console.WriteLine("Hello, Day06!");

var prices = new List<int> {
    80,120,200,50
};

var hasExpensiveProduct = prices.Any(item => item > 150);


Console.WriteLine($"是否存在「價格大於 150」的商品：{hasExpensiveProduct}");

hasExpensiveProduct = prices.Any(item => item > 300);

Console.WriteLine($"是否存在「價格大於 300」的商品：{hasExpensiveProduct}");
