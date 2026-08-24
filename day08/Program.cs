Console.WriteLine("Hello, Day08!");

/*實作要求:
    1. 建立 products
    2. 使用 Where
    3. 在 Where 的 Lambda 裡使用今天的新知 Contains
    4. 使用 foreach 遍歷結果
    5. 印出商品名稱
*/


// 商品資料
List<Product> productList = new List<Product>()
{
    new Product()
    {
        Id=1,
        Name ="Laptop"
    },
    new Product()
    {
        Id=2,
        Name ="Mouse"
    },
    new Product()
    { 
        Id=3,
        Name ="Keyboard"
    },
    new Product()
    { 
        Id=4,
        Name ="Monitor"
    }
};

// 使用者選中的 Product Id
var selectedProductIds = new List<int> {
    1,3,4
};
// 使用者選中的商品資料
var selectedProductList = productList.Where(
    item => selectedProductIds.Contains(item.Id)
);

// 印出使用者選中的商品資料
foreach (var item in selectedProductList)
{
    Console.WriteLine($"使用者選中的商品資料:{item.Name}");
}

// 定義型別
class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = "";

}