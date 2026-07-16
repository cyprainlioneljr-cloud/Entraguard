# Creates dynamic department groups for Meridian (Sprint 2)
# Scope: Group.ReadWrite.All - one per department, rule-driven membership
Connect-MgGraph -Scopes "Group.ReadWrite.All"

$departments = @{
    "sg-dyn-executive"       = "Executive"
    "sg-dyn-advisory"        = "Advisory"
    "sg-dyn-risk-compliance" = "Risk and Compliance"
    "sg-dyn-finance"         = "Finance"
    "sg-dyn-it"              = "IT"
    "sg-dyn-hr"              = "HR"
    "sg-dyn-legal"           = "Legal"
}

foreach ($g in $departments.GetEnumerator()) {
    New-MgGroup -DisplayName $g.Key `
        -Description "Dynamic: all $($g.Value) department users" `
        -MailEnabled:$false `
        -MailNickname $g.Key.Replace("-","") `
        -SecurityEnabled `
        -GroupTypes "DynamicMembership" `
        -MembershipRule "(user.department -eq ""$($g.Value)"")" `
        -MembershipRuleProcessingState "On" | Out-Null
    Write-Host "  Created: $($g.Key)  rule: department -eq '$($g.Value)'" -ForegroundColor Green
}

Disconnect-MgGraph
