# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456


# ===========================
# AD Full Backup Script
# ===========================

# ====== إعداد المجلد الرئيسي حسب التاريخ ======
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BackupRoot = "C:\AD_Backups\$Date"
New-Item -ItemType Directory -Path $BackupRoot -Force

# ===========================
# 1️⃣ Backup Users
# ===========================
$UsersCSV = Join-Path $BackupRoot "AD_Users.csv"
Get-ADUser -Filter * -Properties * |
    Select-Object Name,GivenName,Surname,SamAccountName,UserPrincipalName,Enabled,DistinguishedName,ObjectClass,WhenCreated,Description |
    Export-Csv $UsersCSV -NoTypeInformation -Delimiter ';'
Write-Host "✅ AD Users backup completed: $UsersCSV"

# ===========================
# 2️⃣ Backup Groups
# ===========================
$GroupsCSV = Join-Path $BackupRoot "AD_Groups.csv"
Get-ADGroup -Filter * -Properties * |
    Select-Object Name,SamAccountName,GroupCategory,GroupScope,DistinguishedName,Description |
    Export-Csv $GroupsCSV -NoTypeInformation -Delimiter ';'
Write-Host "✅ AD Groups backup completed: $GroupsCSV"

# ===========================
# 3️⃣ Backup GPOs
# ===========================
$GPOBackupFolder = Join-Path $BackupRoot "GPOs_Backup"
New-Item -ItemType Directory -Path $GPOBackupFolder -Force

Get-GPO -All | ForEach-Object {
    Backup-GPO -Guid $_.Id -Path $GPOBackupFolder
}
Write-Host "✅ GPOs backup completed: $GPOBackupFolder"

# ===========================
# 4️⃣ Optional: Output summary
# ===========================
Write-Host "======================================="
Write-Host "AD Full Backup Completed Successfully!"
Write-Host "Backup folder: $BackupRoot"
Write-Host "Users CSV: $UsersCSV"
Write-Host "Groups CSV: $GroupsCSV"
Write-Host "GPOs folder: $GPOBackupFolder"
Write-Host "======================================="
