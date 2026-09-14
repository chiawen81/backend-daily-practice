Console.WriteLine("Hello, World!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var allProductIds = new List<int>()
{
    101,
    102,
    103,
    106,
    108,
};

var allowedProductIds = new HashSet<int>()
{
    101,
    103,
    105,
    108
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================

foreach (var item in allProductIds)
{
    var isAllowedBuy = allowedProductIds.Contains(item);
    var str = isAllowedBuy ? "允許購買" : "不允許購買";

    Console.WriteLine($"Product {item}：{str}");
}
