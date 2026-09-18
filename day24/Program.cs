Console.WriteLine("Hello, Day24!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var products = new List<Product>
{
    new Product() { Id = 101, Name = "Laptop", Price = 30000 },
    new Product() { Id = 102, Name = "Mouse", Price = 1200 },
    new Product() { Id = 103, Name = "Keyboard", Price = 2500 }
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================
PrintProductDetail(products, 102);
PrintProductDetail(products, 999);

void PrintProductDetail(
    IEnumerable<Product> products,
    int productId)
{
    // TODO

    var targetProductDetail = products.FirstOrDefault(item => item.Id == productId);

    if (targetProductDetail is null)
    {
        Console.WriteLine($"Product not found");
        return;
    }
    else
    {
        Console.WriteLine($"Id:{targetProductDetail.Id},產品:{targetProductDetail.Name},價格:{targetProductDetail.Price}");

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


