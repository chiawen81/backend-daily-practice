Console.WriteLine("Hello, Day21!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
var favoriteProductIds = new HashSet<int>() {
    101,102,105,108,110
};

var availableProductIds = new HashSet<int>()
{
    101,103,105,106,110
};



// ==========================================================================================
//                                            主程式
// ==========================================================================================
var favoriteAndAvailableProductIds = favoriteProductIds.Intersect(availableProductIds);

foreach (var item in favoriteAndAvailableProductIds)
{
    Console.WriteLine($"Available favorite product:{item}");
}
