Console.WriteLine("Hello, Day13!");


// ——————————————————————————————————————  變數  ——————————————————————————————————————
var orderObj1 = new Order()
{
    Id = 1001,
    CustomerName = "Alice",
    TotalAmount = 2500,
    IsPaid = true
};

var orderObj2 = new Order()
{
    Id = 1002,
    CustomerName = "Bob",
    TotalAmount = 1800,
    IsPaid = false
};



// ——————————————————————————————————————  主程式  ——————————————————————————————————————
var orders = new List<Order>() {
    orderObj1,orderObj2
};

foreach (var item in orders)
{
    Console.WriteLine($"訂單資訊 Id:{item.Id},CustomerName:{item.CustomerName},TotalAmount:{item.TotalAmount},IsPaid:{item.IsPaid}");
}



// ——————————————————————————————————————  型別  ——————————————————————————————————————
class Order
{
    public int Id { get;set;  }
    public string CustomerName {  get; set; } = "";
    public int TotalAmount {  get;set;  }
    public bool IsPaid { get;set;  }
}