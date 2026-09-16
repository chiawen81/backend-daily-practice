Console.WriteLine("Hello, Day22!");

// ==========================================================================================
//                                            變數
// ==========================================================================================
// 資料庫原本的權限
var existingPermissionIds = new HashSet<int>() { 10, 20, 30, 40, 50 };

// 前端送來更新後要保留的權限
var requestedPermissionIds = new HashSet<int>() { 10, 30, 40, 60 };



// ==========================================================================================
//                                            主程式
// ==========================================================================================
// 需要被移除的權限
var shouldBeDeletedPermissionIds = existingPermissionIds.Except(requestedPermissionIds);

PrintIds(shouldBeDeletedPermissionIds);

void PrintIds(IEnumerable<int> ids)
{
    foreach (var item in ids)
    {
        Console.WriteLine($"Remove PermissionId:{item}");
    }
}
