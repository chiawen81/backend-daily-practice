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
    var productIds = products.Select(item => item.Id);
    var isNotExistButRequiredIds = requestedProductIds.Except(productIds);

    foreach (var item in products)
    {

        var isExistAndRequired = requestedProductIds.Contains(item.Id);

        if (isExistAndRequired)
        {
            Console.WriteLine($"{item.Name}");
        }
    }

    if (!isNotExistButRequiredIds.Any())
    {
        Console.WriteLine($"All requested products exist");
    }
    else
    {

        foreach (var id in isNotExistButRequiredIds)
        {
            Console.WriteLine($"Product {id} not found");
        }
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
