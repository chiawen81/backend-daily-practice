Console.WriteLine("Hello, Day23!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var existingProductIds = new HashSet<int>()
{
    101,102,103,104
};

var requestedProductIds = new HashSet<int>()
{
    102,103,105,106
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================

// 需要新增的產品
var shouldBeAddedProductIds = requestedProductIds.Except(existingProductIds).ToList();

// 需要刪除的產品
var shouldBeDeletedProductIds = existingProductIds.Except(requestedProductIds).ToList();

PrintIds(shouldBeAddedProductIds, true);
PrintIds(shouldBeDeletedProductIds, false);

void PrintIds(IEnumerable<int> collection, bool isAdd)
{
    var printTypeText = isAdd ? "需要新增" : "需要刪除";

    foreach (var item in collection)
    {
        Console.WriteLine($"{printTypeText}：{item}");
    }
}
