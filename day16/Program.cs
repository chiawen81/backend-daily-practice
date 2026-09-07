Console.WriteLine("Hello, Day16!");

// ————————————————————————— 訂單資料 —————————————————————————
// 訂單1001
var order1001 = new Order()
{
    Id = 1001,
    CustomerName = "Alice",
    Price = 2500,
    IsPaid = true
};

// 訂單1002
var order1002 = new Order()
{
    Id = 1002,
    CustomerName = "Bob",
    Price = 1200,
    IsPaid = false
};

// 訂單1003
var order1003 = new Order()
{
    Id = 1003,
    CustomerName = "Cindy",
    Price = 3000,
    IsPaid = false
};

// 所有訂單
var orders = new List<Order>()
{
    order1001,order1002,order1003
};



// ————————————————————————— 主程式 —————————————————————————
var validOrders = GetFreeShippingOrders(orders);
PrintDetail(validOrders);


// 是否免運
bool IsEligibleForFreeShipping(Order order)
{
    bool result = false;

    if (order.IsPaid && order.Price >= 2000)
    {
        result = true;
    }

    return result;
}


// 挑選出免運訂單
IEnumerable<Order> GetFreeShippingOrders(List<Order> orders)
{
    return orders.Where(item => IsEligibleForFreeShipping(item));
}


// 印出資料
void PrintDetail(IEnumerable<Order> orders)
{
    foreach (var item in orders)
    {
        Console.WriteLine($"訂單 {item.Id} | {item.CustomerName} | {item.Price} 元 | 符合免運資格");
    }
}



// ————————————————————————— 型別 —————————————————————————
class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = "";
    public int Price { get; set; }
    public bool IsPaid { get; set; }
}

