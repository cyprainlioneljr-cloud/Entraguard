# Creates the Meridian Financial Group workforce from CSV (Sprint 2)
# EntraGuard - bulk user provisioning via Microsoft Graph PowerShell
# Scope used: User.ReadWrite.All (logged in project bible)

Connect-MgGraph -Scopes "User.ReadWrite.All"

$workforce = Import-Csv -Path "./meridian-workforce.csv"

Write-Host "Loaded $($workforce.Count) users from CSV" -ForegroundColor Cyan

foreach ($user in $workforce) {

    $randomPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 24 | ForEach-Object { [char]$_ })

    $passwordProfile = @{
        Password                      = $randomPassword
        ForceChangePasswordNextSignIn = $true
    }

    $mailNickname = ($user.UserPrincipalName.Split('@')[0]).Replace('.', '')

    try {
        New-MgUser -UserPrincipalName $user.UserPrincipalName `
                   -DisplayName       $user.DisplayName `
                   -GivenName         $user.GivenName `
                   -Surname           $user.Surname `
                   -JobTitle          $user.JobTitle `
                   -Department        $user.Department `
                   -EmployeeType      $user.EmployeeType `
                   -OfficeLocation    $user.OfficeLocation `
                   -UsageLocation     $user.UsageLocation `
                   -MailNickname      $mailNickname `
                   -PasswordProfile   $passwordProfile `
                   -AccountEnabled | Out-Null

        Write-Host "  Created: $($user.DisplayName)  [$($user.Department)]" -ForegroundColor Green
    }
    catch {
        Write-Host "  FAILED:  $($user.DisplayName) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nDepartment summary:" -ForegroundColor Cyan
Get-MgUser -All -Property DisplayName,Department |
    Where-Object { $_.Department } |
    Group-Object Department |
    Sort-Object Name |
    Format-Table Name, Count -AutoSize

Disconnect-MgGraph
