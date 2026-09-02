Console.WriteLine("Hello, Day14!");

var order1001 = new Order()
{
    Id = 1001,
    Customer = new Customer() {
        Id = 1,
        Name = "Alice"
    },
    TotalAmount = 2500,
    IsPaid=true
};


var order1002 = new Order()
{
    Id = 1002,
    Customer = new Customer()
    {
        Id = 2,
        Name = "Bob"
    },
    TotalAmount = 1200,
    IsPaid = false
};

var order1003 = new Order()
{
    Id = 1003,
    Customer = new Customer()
    {
        Id = 3,
        Name = "Cindy"
    },
    TotalAmount = 3600,
    IsPaid = true
};

var orders = new List<Order>() {
    order1001,order1002,order1003
};

foreach (var item in orders) {
    Console.WriteLine($"訂單編號：{item.Id},客戶名稱:{item.Customer.Name},訂單金額:{item.TotalAmount},是否付款:{item.IsPaid}");
}



class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}

class Order
{
    public int Id {  get; set;}
    public Customer Customer { get; set; } = new Customer ();

    public int TotalAmount { get; set; }
    public bool IsPaid {  get; set;}
}

