
# Author: Mohamed Mghawry
# GitHub: https://github.com/Mohamed4456



# ===========================
# Bulk Create AD Users from CSV
# ===========================

# ====== Variables ======
$CSVPath = "C:\Users\it00\Desktop\users.csv"
$DefaultPassword = "P@ssw0rd"
$ForceChangePassword = $true

# ====== Process ======
Import-Csv $CSVPath | ForEach-Object {
    try {
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$($_.SamAccountName)'")) {

            New-ADUser `
                -Name $_.Name `
                -GivenName $_.GivenName `
                -Surname $_.Surname `
                -SamAccountName $_.SamAccountName `
                -UserPrincipalName $_.UserPrincipalName `
                -Path $_.OU `
                -AccountPassword (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force) `
                -Enabled $true `
                -ChangePasswordAtLogon $ForceChangePassword

            Write-Host "[$($_.CreateDate)] User $($_.SamAccountName) created successfully" -ForegroundColor Green

        } else {
            Write-Host "[$($_.CreateDate)] User $($_.SamAccountName) already exists" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[$($_.CreateDate)] Failed to create $($_.SamAccountName): $($_.Exception.Message)" -ForegroundColor Red
    }
}
