Console.WriteLine("Hello, Day30!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop", Price = 30000 },
    new Product { Id = 102, Name = "Mouse", Price = 1200 },
    new Product { Id = 103, Name = "Keyboard", Price = 2500 }
};

var requestedProductIds = new List<int>
{
    102, 103, 999
};





// ==========================================================================================
//                                            主程式
// ==========================================================================================
Dictionary<int, Product> productsDictionary = products.ToDictionary(
    product => product.Id,
    product => product
);

foreach (var item in requestedProductIds)
{
    if (productsDictionary.TryGetValue(item, out var itemProductInfo))
    {
        Console.WriteLine($"{itemProductInfo?.Name} - {itemProductInfo?.Price}");
    }
    else
    {
        Console.WriteLine($"Product not found: {item}");
    }
}





// ==========================================================================================
//                                            型別
// ==========================================================================================
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}
