Console.WriteLine("Hello, Day27!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var products = new Dictionary<int, Product>
{
    {
        101,
        new Product { Id = 101, Name = "Laptop", Price = 30000 }
    },
    {
        102,
        new Product { Id = 102, Name = "Mouse", Price = 1200 }
    },
    {
        103,
        new Product { Id = 103, Name = "Keyboard", Price = 2500 }
    }
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================
PrintProduct(products, 102);
PrintProduct(products, 999);


void PrintProduct(
    Dictionary<int, Product> products,
    int productId)
{
    if (products.TryGetValue(productId, out var product))
    {
        Console.WriteLine($"target productId:{productId} Id:{product.Id} Name:{product.Name} Price:{product.Price}");
    }
    else
    {
        Console.WriteLine($"target productId:{productId} Product not found");
        return;
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

