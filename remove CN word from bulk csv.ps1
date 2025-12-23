# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456





# مسار CSV الأصلي
$OriginalCSV = "C:\Users\it00\Desktop\AD_Users_Raw.csv"

# مسار CSV الجديد بعد تنظيف OU
$CleanCSV = "C:\Users\it00\Desktop\AD_Users_Clean.csv"

# قراءة CSV الأصلي
$users = Import-Csv $OriginalCSV -Delimiter ";"

# تنظيف OU فقط
$cleanUsers = foreach ($user in $users) {
    $ouClean = $user.OU

    # إذا بدأ ب CN= نشيلها
    if ($ouClean -like "CN=*") {
        # نحذف CN=اسم المستخدم + الفاصلة الأولى فقط
        $ouClean = $ouClean -replace "^CN=[^,]+,", ""
    }

    # إعادة بناء نفس الأعمدة مع OU المعدل فقط
    [PSCustomObject]@{
        Name        = $user.Name
        SamAccountName = $user.SamAccountName
        Enabled     = $user.Enabled
        OU          = $ouClean
        CreatedDate = $user.CreatedDate
        ReportDate  = $user.ReportDate
    }
}

# تصدير CSV جديد
$cleanUsers | Export-Csv $CleanCSV -NoTypeInformation -Delimiter ";"

Write-Host "CSV cleaned successfully: $CleanCSV" -ForegroundColor Green
