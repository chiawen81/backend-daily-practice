Console.WriteLine("Hello, Day11!");


var products = new List<Product>(){
    new Product(){ Id=101,Name="Laptop",Price=30000},
    new Product(){ Id=102,Name="Mouse",Price=1200},
    new Product(){Id=1031,Name="Keyboard",Price=2500 }
};

var targetProductId =102;
var targetProduct = products.FirstOrDefault<Product>(item => item.Id == targetProductId);

if (targetProduct is null)
{
    Console.WriteLine($"找不到商品");
}

if (targetProduct is not null)
{
    Console.WriteLine($"商品:{targetProduct.Name},價格:{targetProduct.Price}");
}


class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}