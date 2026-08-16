Console.WriteLine("Hello, Day04");

List<int> prices = new()
{
    80,120,200,50
};

Func<int,bool> isHighPrice = price => price >= 100;

foreach(int item in prices)
{   
    bool result = isHighPrice(item);
    Console.WriteLine($"價格:{item}, 判斷結果:{result}");
}
