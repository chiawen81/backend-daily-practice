Console.WriteLine("Hello, Day15!");

// ————————————————————————— 訂單資料 —————————————————————————
// 訂單1001
var order1001 = new Order()
{
    Id=1001,
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

// 所有訂單
var orders = new List<Order>()
{
    order1001,order1002
};



// ————————————————————————— 主程式 —————————————————————————
// 是否免運
bool IsEligibleForFreeShipping(Order order)
{
    bool result=false;

    if (order.IsPaid && order.Price>=2000) {
        result = true;
    }

    return result;
};

void PrintDetail()
{
    foreach (var item in orders)
    {
        var isFreeShipOrder = IsEligibleForFreeShipping(item);
        Console.WriteLine($"訂單編號:{item.Id} 是否免運:{isFreeShipOrder}");  
    };
}

PrintDetail();



// ————————————————————————— 型別 —————————————————————————
class Order
{
    public int Id { get; set;  }
    public string CustomerName { get; set; } = "";
    public int Price { get; set; }
    public bool IsPaid {get; set;  }
}

