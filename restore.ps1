# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456


طريقة Restore

1️⃣ Users:

Import-Csv "C:\AD_Backups\2025-12-18\AD_Users.csv" -Delimiter ';' | ForEach-Object {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($_.SamAccountName)'")) {
        New-ADUser -Name $_.Name -SamAccountName $_.SamAccountName -UserPrincipalName $_.UserPrincipalName -Path $_.DistinguishedName -Enabled $_.Enabled
    }
}

2️⃣ Groups:

Import-Csv "C:\AD_Backups\2025-12-18\AD_Groups.csv" -Delimiter ';' | ForEach-Object {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$($_.SamAccountName)'")) {
        New-ADGroup -Name $_.Name -SamAccountName $_.SamAccountName -GroupCategory $_.GroupCategory -GroupScope $_.GroupScope
    }
}


3️⃣ GPOs:

# Example restore of a specific GPO
Restore-GPO -Name "اسم الـ GPO" -Path "C:\AD_Backups\2025-12-18\GPOs_Backup"
