# Sets break-glass account passwords to never expire (AD-003)
# Scope used: User.ReadWrite.All — logged in project bible
Connect-MgGraph -Scopes "User.ReadWrite.All"

Update-MgUser -UserId "bg-emergency-01@meridianfgoutlook.onmicrosoft.com" -PasswordPolicies "DisablePasswordExpiration"
Update-MgUser -UserId "bg-emergency-02@meridianfgoutlook.onmicrosoft.com" -PasswordPolicies "DisablePasswordExpiration"

# Verify
Get-MgUser -UserId "bg-emergency-01@meridianfgoutlook.onmicrosoft.com" -Property PasswordPolicies | Select-Object PasswordPolicies
Get-MgUser -UserId "bg-emergency-02@meridianfgoutlook.onmicrosoft.com" -Property PasswordPolicies | Select-Object PasswordPolicies

Disconnect-MgGraph
