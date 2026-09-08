Console.WriteLine("Hello, Day17!");



// —————————————————————————————— 變數 ——————————————————————————————
var orders = new List<Order>()
{
    new Order()
    {
        Id = 1001,
        CustomerName = "Alice",
        Price = 2500,
        IsPaid = true
    },
    new Order()
    {
        Id = 1002,
        CustomerName = "Bob",
        Price = 1200,
        IsPaid = false
    },
    new Order()
    {
        Id = 1003,
        CustomerName = "Carol",
        Price = 3000,
        IsPaid = false
    }
};



// —————————————————————————————— 主程式 ——————————————————————————————

// 未付款的客戶名稱
IEnumerable<string> unpaidCustomerNames = GetUnpaidCustomerNames(orders);

// 印出資料
PrintDetail(unpaidCustomerNames);



// 未付款的客戶名稱- 從訂單中篩選
IEnumerable<string> GetUnpaidCustomerNames(List<Order> orders)
{
    var unpaidCustomerNames = orders.Where(item => !item.IsPaid)
                                   .Select(item => item.CustomerName);

    return unpaidCustomerNames;
}


// 印出資料
void PrintDetail(IEnumerable<string> collection)
{
    foreach (var item in collection)
    {
        Console.WriteLine($"未付款客戶姓名:{item}");
    }
}



// —————————————————————————————— 型別 ——————————————————————————————
class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = "";
    public int Price { get; set; }
    public bool IsPaid { get; set; }
}
