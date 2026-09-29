Console.WriteLine("Hello, Day26!");

var productPrices = new Dictionary<int, int>
{
    { 101, 30000 },
    { 102, 1200 },
    { 103, 2500 },
    { 104, 8000 }
};

var productIdSale03 = productPrices[103];

Console.WriteLine($"productIdSale03:{productIdSale03}");
