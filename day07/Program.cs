Console.WriteLine("Hello, Day07 !");

Product laptop = new()
{
    Name = "Laptop",
    Stocks = new List<Stock> {
        new Stock
        {
            Warehouse = "Taichung",
            Quantity = 0
        },
        new Stock
        {
            Warehouse = "Taichung",
            Quantity = 3
        }
    }
};


Product mouse = new()
{
    Name = "Mouse",
    Stocks =new List<Stock> {
        new Stock
        {
            Warehouse = "Taipei",
            Quantity = 0
        },
        new Stock
        {
            Warehouse = "Taichung",
            Quantity = 0
        }
    }
};

Product keyboard = new()
{
    Name = "Keyboard",
    Stocks = new List<Stock> {
        new Stock
        {
            Warehouse = "Taipei",
            Quantity = 5
        },
        new Stock
        {
            Warehouse = "Taichung",
            Quantity = 0
        }
    }
};

var allProductList = new List<Product> {
    laptop,mouse,keyboard 
};

var hasQuantityProductList = allProductList.Where(
    singleProduct =>
    singleProduct.Stocks.Any(item => item.Quantity > 0)
);

foreach (Product singleProduct in hasQuantityProductList)
{
    Console.WriteLine($"有貨的商品名稱:{singleProduct.Name}");
}


class Product
{
    public string Name { get; set; } = "";
    public List<Stock> Stocks { get; set; } = new();
}

class Stock
{
    public string Warehouse { get; set; } = "";
    public int Quantity { get; set; }
}




