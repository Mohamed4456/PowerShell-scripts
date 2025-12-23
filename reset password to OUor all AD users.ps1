# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456





# Reset Password لكل اليوزرز أو OU محدد
# يجبرهم يغيروا كلمة السر عند أول Logon
# يطلع تقرير Excel شامل لكل اليوزرز أو حسب OU


##############################################################################
# كلمة السر الجديدة (غيّرها حسب الـ Domain Policy)

$newPasswordPlain = "P@ssw0rd" 
$newPassword = ConvertTo-SecureString $newPasswordPlain -AsPlainText -Force

# لو عايز تحدد OU معين، غير المسار هنا
# لو عايز كل الدومين، خلي $OUPath = $null

$OUPath = "OU=users, OU=hr ,OU=mega.com ,DC=mega,DC=com"  # مثال: OU محدد
# $OUPath = $null  # كل الدومين

# مسار حفظ التقرير
$reportPath = "C:\Reports\AD_Users_PasswordReset_Report.csv"

# تأكد من وجود الفولدر
$folder = Split-Path $reportPath
if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force }

# -----------------------------
# جلب المستخدمين
# -----------------------------
if ($OUPath) {
    $users = Get-ADUser -Filter * -SearchBase $OUPath -Properties SamAccountName,Enabled,DistinguishedName
} else {
    $users = Get-ADUser -Filter * -Properties SamAccountName,Enabled,DistinguishedName
}

# -----------------------------
# عمل Reset Password وForce Change
# -----------------------------
$report = @()

foreach ($user in $users) {
    try {
        Set-ADAccountPassword $user.SamAccountName -Reset -NewPassword $newPassword
        Set-ADUser $user.SamAccountName -ChangePasswordAtLogon $true

        $status = "Success"
    } catch {
        $status = "Failed: $($_.Exception.Message)"
    }

    # بناء التقرير
    $report += [PSCustomObject]@{
        Name = $user.Name
        SamAccountName = $user.SamAccountName
        Enabled = $user.Enabled
        OU = $user.DistinguishedName
        Status = $status
        ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm"
    }
}

# -----------------------------
# تصدير التقرير إلى CSV
# -----------------------------
$report | Export-Csv $reportPath -NoTypeInformation -Delimiter ';'

Write-Host "Process completed. Report saved at $reportPath" -ForegroundColor Green
