Console.WriteLine("Hello, Day28!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var products = new Dictionary<int, Product>
{
    {
        101,
        new Product(){
            ProductId = 101,
            Name = "Laptop",
            Price = 30000
        }
    },
    {
    102,
    new Product (){
            ProductId = 102,
            Name = "Mouse",
            Price = 1200
    }
},
    {
    103,
    new Product(){
            ProductId = 103,
            Name = "Keyboard",
            Price = 2500   }
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
    if (!products.TryGetValue(productId, out var targetProduct))
    {
        Console.WriteLine($"Product not found");
        return;
    }

    Console.WriteLine($"Id:{targetProduct.ProductId}, Product:{targetProduct.Name}, Price:{targetProduct.Price}");
}





// ==========================================================================================
//                                            型別
// ==========================================================================================
class Product
{
    public int ProductId { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }

}
