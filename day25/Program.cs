Console.WriteLine("Hello, Day25!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var products = new List<Product>
{
    new Product { Id = 101, Name = "Laptop", Price = 30000 },
    new Product { Id = 102, Name = "Mouse", Price = 1200 },
    new Product { Id = 103, Name = "Keyboard", Price = 2500 },
    new Product { Id = 104, Name = "Monitor", Price = 8000 }
};

var requestedProductIds = new HashSet<int>
{
    101,
    103,
    999
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================

PrintOrderCheck(products, requestedProductIds);

void PrintOrderCheck(
    IEnumerable<Product> products,
    HashSet<int> requestedProductIds)
{
    // 1. 找出有被要求購買的商品
    var requestedProducts = products
        .Where(product => requestedProductIds.Contains(product.Id));

    foreach (var product in requestedProducts)
    {
        Console.WriteLine(product.Name);
    }

    // 2. 找出有被要求、但系統不存在的 ProductId
    var existingProductIds = products
        .Select(product => product.Id);

    var missingProductIds = requestedProductIds
        .Except(existingProductIds);

    // 3. 處理不存在的商品
    if (!missingProductIds.Any())
    {
        Console.WriteLine("All requested products exist");
        return;
    }

    foreach (var productId in missingProductIds)
    {
        Console.WriteLine($"Product {productId} not found");
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
