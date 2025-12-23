# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456





New-Item -ItemType Directory -Path "F:\Reports" -Force

Get-Service |
Select-Object `
    @{Name="ServiceName"; Expression={$_.Name}},
    Status,
    StartType,
    @{Name="ServerName"; Expression={$env:COMPUTERNAME}},
    @{Name="ReportDate"; Expression={Get-Date -Format "yyyy-MM-dd HH:mm"}} |
Export-Csv "F:\Reports\Services_Report.csv" -NoTypeInformation -Delimiter ';'

##########################################################################################

New-ADUser -Name "Ahmed Ali" -GivenName "Ahmed" -Surname "Ali" -SamAccountName "ahmed.ali" -UserPrincipalName "ahmed.ali@mega.com" -Path "OU=users, OU=hr ,OU=mega.com ,DC=mega,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) -Enabled $true

#############################################################################################

Import-Csv C:\Users\it00\Desktop\users.csv| ForEach-Object {
New-ADUser -Name $_.Name -GivenName $_.GivenName -Surname $_.Surname -SamAccountName $_.SamAccountName -UserPrincipalName $_.UserPrincipalName -Path $_.OU -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) -Enabled $true }

##############################################################################################
كل اليوزرات ف شيت اكسل

Get-ADUser -Filter * -Properties SamAccountName,Enabled,Department,Title |
Select-Object `
    Name,
    SamAccountName,
    Enabled,
    Department,
    Title,
    @{Name="Domain";Expression={(Get-ADDomain).DNSRoot}},
    @{Name="ReportDate";Expression={Get-Date -Format "yyyy-MM-dd HH:mm"}} |
Export-Csv "F:\Reports\All_AD_Users_Report.csv" -NoTypeInformation -Delimiter ';'

############################################################################################
ده هيعمل:

Reset لكلمة السر لكل اليوزرات
يجبرهم يغيروها عند أول تسجيل دخول



# كلمة السر الجديدة لكل المستخدمين
$newPassword = ConvertTo-SecureString "NewP@ss123!" -AsPlainText -Force
# نجيب كل المستخدمين
Get-ADUser -Filter * | ForEach-Object {
    Set-ADAccountPassword $_.SamAccountName -Reset -NewPassword $newPassword
    Set-ADUser $_.SamAccountName -ChangePasswordAtLogon $true
}
############################################################################################
و عايز تعمل Reset Password على OU محدد:

$OUPath = "OU=IT,OU=Company,DC=mega,DC=com"
$newPassword = ConvertTo-SecureString "NewP@ss123!" -AsPlainText -Force

Get-ADUser -Filter * -SearchBase $OUPath | ForEach-Object {
    Set-ADAccountPassword $_.SamAccountName -Reset -NewPassword $newPassword
    Set-ADUser $_.SamAccountName -ChangePasswordAtLogon $true
}
############################################################################################
عمل تقرير لكل اليوزرات + OU
Get-ADUser -Filter * -Properties SamAccountName,Enabled,Department,Title,DistinguishedName |
Select Name,SamAccountName,Enabled,Department,Title,@{Name="OU";Expression={$_.DistinguishedName}},@{Name="ReportDate";Expression={Get-Date}} |
Export-Csv "C:\Reports\AD_All_Users_Report.csv" -NoTypeInformation -Delimiter ';'

############################################################################################
كلمة السر الجديدة لمستخدم واحد تغيير


# كلمة السر الجديدة
$newPassword = ConvertTo-SecureString "NewP@ss123!" -AsPlainText -Force

# reset password لمستخدم واحد
Set-ADAccountPassword "ahmed.ali" -Reset -NewPassword $newPassword

# إجباره يغير كلمة السر عند أول Logon
Set-ADUser "ahmed.ali" -ChangePasswordAtLogon $true

############################################################################################



