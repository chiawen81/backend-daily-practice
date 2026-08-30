Console.WriteLine("Hello, Day12!");

var products = new List<Product>
{
    new()
    {
        Id = 101,
        Name = "Laptop",
        Stocks = new List<Stock>
        {
            new() { Warehouse = "Taipei", Quantity = 0 },
            new() { Warehouse = "Taichung", Quantity = 3 }
        }
    },
    new()
    {
        Id = 102,
        Name = "Mouse",
        Stocks = new List<Stock>
        {
            new() { Warehouse = "Taipei", Quantity = 0 },
            new() { Warehouse = "Taichung", Quantity = 0 }
        }
    },
    new()
    {
        Id = 103,
        Name = "Keyboard",
        Stocks = new List<Stock>
        {
            new() { Warehouse = "Taipei", Quantity = 5 },
            new() { Warehouse = "Taichung", Quantity = 0 }
        }
    },
    new()
    {
        Id = 104,
        Name = "Monitor",
        Stocks = new List<Stock>
        {
            new() { Warehouse = "Taipei", Quantity = 8 }
        }
    }
};

var selectedProductIds = new List<int> { 101, 102, 103 };
var targetProductId = 999;


// TODO 1：
// 找出同時符合以下條件的商品：
// - 商品 ID 存在於 selectedProductIds
// - 至少一個倉庫的 Quantity 大於 0

// // 寫法一
// var selectedProducts = products.Where(item=> selectedProductIds.Contains(item.Id));
// var selectedProductsHasStock = selectedProducts.Where(singleProduct=> singleProduct.Stocks.Any(item=>item.Quantity>0));

// 寫法二
var selectedProductsHasStock  = products.Where(singleProduct=> 
                                selectedProductIds.Contains(singleProduct.Id) &&
                                singleProduct.Stocks.Any(item=>item.Quantity>0)
                        );

foreach(var singleProduct in selectedProductsHasStock )
{  
    Console.WriteLine($"TODO 1 符合條件的商品Id:{singleProduct.Id}");
}



// TODO 2：
// 將篩選結果轉換成商品名稱，並使用 foreach 印出

var validProductName = selectedProductsHasStock.Select(item => item.Name);

foreach(var item in validProductName)
{
    Console.WriteLine($"TODO 2 符合條件的商品名稱:{item}");
}

// TODO 3：
// 使用 targetProductId 尋找單一商品
var targetProduct = products.FirstOrDefault(item=> item.Id == targetProductId);

// TODO 4：
// 如果找不到商品，印出「找不到商品：999」
// 如果找到商品，印出商品名稱

if(targetProduct is null)
{
    Console.WriteLine($"TODO 4 找不到商品：999");
}

if(targetProduct is not null)
{
    Console.WriteLine($"商品名稱:{targetProduct.Name}");

}


class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public List<Stock> Stocks { get; set; } = new();
}

class Stock
{
    public string Warehouse { get; set; } = "";
    public int Quantity { get; set; }
}

