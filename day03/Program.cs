Console.WriteLine("Hello, Day03!");

// ================== price ==================
List<int> prices = new List<int> {
    100,250,500
};

Console.WriteLine($"看全部價格 prices:{string.Join(", ", prices)}");

foreach (int item in prices)
{
    Console.WriteLine($"看單一價格:{item}");
}

// ================== productNames ==================
var productNames = new List<string> {
    "Keyboard","Mouse","Monitor"
};

Console.WriteLine($"看全部產品 productNames:{string.Join(",",productNames)}");

foreach (string item in productNames)
{
    Console.WriteLine($"看單一產品:{item}");
}