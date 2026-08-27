Console.WriteLine("Hello, Day10!");

var numbers = new List<int> { 10, 20, 30, 40 };
var resultFirstOrDefault = numbers.FirstOrDefault(number => number > 20);
var resultWhere = numbers.Where(number => number > 20);

Console.WriteLine($"FirstOrDefault:{resultFirstOrDefault}");
Console.WriteLine($"resultWhere:{resultWhere}");

var products = new List<Product>() {
    new Product(){
        Id=101,Name="Laptop",Price=30000
    },
    new Product(){
        Id=102,Name="Mouse",Price=1200
    },
    new Product(){
        Id=103,Name="Keyboard",Price=2500
    }
};

var selectProduct = products.FirstOrDefault(item => item.Id == 102);
Console.WriteLine($"Product:{selectProduct?.Name},Price:{selectProduct?.Id}");


class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}