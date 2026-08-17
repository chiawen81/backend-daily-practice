Console.WriteLine("Hello, Day05!");

var prices = new List<int>
{
    45,120,80,250,99,100
};

var highPriceProducts = prices.Where(price => price >= 100);

foreach (int item in highPriceProducts)
{
    Console.WriteLine($"篩選後的值: {item}");
}