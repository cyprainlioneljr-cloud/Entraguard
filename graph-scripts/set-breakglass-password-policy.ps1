# Sets break-glass account passwords to never expire (AD-003)
# Sprint 1 - EntraGuard / Meridian Financial Group
# Why Graph: the PasswordPolicies property has no portal control.
# Scope used: User.ReadWrite.All (logged with rationale in project bible)

Connect-MgGraph -Scopes "User.ReadWrite.All"

Update-MgUser -UserId "bg-emergency-01@meridianfgoutlook.onmicrosoft.com" -PasswordPolicies "DisablePasswordExpiration"
Update-MgUser -UserId "bg-emergency-02@meridianfgoutlook.onmicrosoft.com" -PasswordPolicies "DisablePasswordExpiration"

# Verify - expect: DisablePasswordExpiration for each
Get-MgUser -UserId "bg-emergency-01@meridianfgoutlook.onmicrosoft.com" -Property PasswordPolicies | Select-Object PasswordPolicies
Get-MgUser -UserId "bg-emergency-02@meridianfgoutlook.onmicrosoft.com" -Property PasswordPolicies | Select-Object PasswordPolicies

Disconnect-MgGraph
