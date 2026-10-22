Console.WriteLine("Hello, Day31!");

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

// 目前允許販售的商品
var availableProductIds = new HashSet<int>
{
    101, 103, 104
};

// 前端要求購買的商品
var requestedProductIds = new List<int>
{
    101, 102, 103, 999
};

// 商品資訊
Dictionary<int, Product> productsDictionary = products.ToDictionary(
    item => item.Id,
    item => item
);



// ==========================================================================================
//                                            主程式
// ==========================================================================================
PrintOrderCheck(productsDictionary, availableProductIds, requestedProductIds);

void PrintOrderCheck(
    Dictionary<int, Product> productLookup,
    HashSet<int> availableProductIds,
    IEnumerable<int> requestedProductIds)
{
    foreach (var item in requestedProductIds)
    {
        if (!productLookup.TryGetValue(item, out var itemProductInfo))
        {
            Console.WriteLine($"ProductId:{item}, Not Found");
            continue;
        }

        if (availableProductIds.Contains(item))
        {
            Console.WriteLine($"ProductId:{item}, Name: {itemProductInfo.Name}, Price: {itemProductInfo.Price}");
        }
        else
        {
            Console.WriteLine($"ProductId:{item}, Not Available");
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




