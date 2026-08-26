Console.WriteLine("Hello, Day09!");

var productList = new List<Product>
{
    new(){Id=101,Name="Laptop", Price = 30000 },
    new(){Id=102,Name="Mouse", Price = 1200 },
    new(){Id=103,Name="Keyboard", Price = 2500 }
};


IEnumerable<string> productNames= productList.Select(item => item.Name);
// 也可以用 var 型別推論寫成：var productNames = productList.Select(item => item.Name);

foreach (var item in productNames)
{
    Console.WriteLine($"{item}");
}

class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public int Price { get; set; }
}