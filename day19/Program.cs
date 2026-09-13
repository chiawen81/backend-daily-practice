Console.WriteLine("Hello, Day19!");

var ids = new HashSet<int> ();
bool result1 = ids.Add(101);
bool result2 = ids.Add(102);
bool result3 = ids.Add(101);
bool result4 = ids.Add(103);
bool result5 = ids.Add(102);
bool result6 = ids.Add(104);

Console.WriteLine($"result1:{result1}");
Console.WriteLine($"result2:{result2}");
Console.WriteLine($"result3:{result3}");
Console.WriteLine($"result4:{result4}");
Console.WriteLine($"result5:{result5}");
Console.WriteLine($"result6:{result6}");

foreach(var item in ids){
    Console.WriteLine($"item:{item}");
}