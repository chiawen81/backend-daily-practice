Console.WriteLine("Hello, Day18!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var orders = new List<Order>()
{
    new Order(){
        Id=1001,
        CustomerName="Alice"
    },
    new Order(){
        Id=1002,
        CustomerName="Bob"
    },
};

var targetOrderIds = new List<int>() { 1001, 9999 };





// ==========================================================================================
//                                           主程式
// ==========================================================================================
// ——————————————————————————————————————————————————————————————————————————————————————————
//  查詢訂單
// ——————————————————————————————————————————————————————————————————————————————————————————
FindOrder(targetOrderIds);



// 查詢訂單
void FindOrder(List<int> targetIdCollection)
{
    foreach (var item in targetIdCollection)
    {
        var targetOrder = FindOrderById(orders, item);

        if (targetOrder is null)
        {
            Console.WriteLine($"找不到資料");
        }
        else
        {
            Console.WriteLine($"找到訂單：{targetOrder.CustomerName}");
        }
    }
}



// 查詢訂單- 比對訂單Id
Order? FindOrderById(List<Order> orderCollection, int targetId)
{
    var targetOrder = orderCollection.FirstOrDefault(item => item.Id == targetId);

    return targetOrder;
}





// ==========================================================================================
//                                            型別
// ==========================================================================================
class Order
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = "";
}
