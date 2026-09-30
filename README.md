# EntraGuard: Enterprise Identity Security and Governance Lab

EntraGuard is a multi-sprint Microsoft Entra ID zero-trust identity and access management lab simulating a regulated financial firm, Meridian Financial Group. It is the identity-focused companion to the completed Azure Zero Trust SOC Lab (Provost Inc): where the SOC lab centered on detection, SIEM, and response, EntraGuard centers on identity as the control plane, governance, lifecycle, privileged access, and access-based defense.

The lab was built and documented sprint by sprint against a real Entra tenant and mapped to SC-300, AZ-500, and SC-200 objectives. Status labels below distinguish live implementation from report-only validation, licensed-feature boundaries, and design-only work.

## Sprint Status

| Sprint | Focus | Status |
|--------|-------|--------|
| 1 | Foundation and Tenant Design | Implemented and validated |
| 2 | Identity Lifecycle and Structure | Implemented and validated |
| 3 | Authentication and Access Foundations | Built and validated in report-only; enforcement cutover not evidenced |
| 4 | Privileged Access with PIM | Implemented and validated |
| 5 | Federation and Application Integration | SAML and OIDC implemented; SCIM demonstrated to the connection boundary |
| 6 | Identity Governance | Implemented and validated, with documented lifecycle limitations |
| 7 | Identity Protection and Risk-Based Conditional Access | User-risk controls validated in report-only; workload-identity enforcement not licensed |
| 8 | Identity Automation | Deployed and screenshot-validated; condition gate implemented, live approval connector deferred |
| 9 | Governance, Audit, and Compliance | Framework mapping and incident documentation complete; log retention design-only; tenant recovery open |
| 10 | Portfolio Finalization and Live Operations | Pending |

## Implementation Evidence Matrix

| Capability | Evidence level | Notes |
|------------|----------------|-------|
| Tenant foundation, emergency access, admin tiering | Implemented | Portal and sign-in evidence in Sprints 1 and 4 |
| Workforce, dynamic groups, Administrative Unit, group licensing | Implemented | Graph scripts, CSV, portal validation, and audit evidence |
| Foundational Conditional Access policies | Report-only validated | Policies were built and tested; tenant-wide enforcement cutover is not evidenced |
| Entra and Azure PIM | Implemented | Eligibility, activation, approval, remediation, and alert-review evidence |
| SAML federation | Implemented | Successful SSO round trip captured |
| OIDC application registration | Implemented | Single-tenant registration and least-privilege delegated permission captured |
| SCIM provisioning | Boundary demonstration | Entra-side setup reached a deliberate placeholder endpoint; no live provisioning target |
| Access Reviews, Entitlement Management, Lifecycle Workflows | Implemented | Request, approval, delivery, review, and leaver execution captured |
| Identity Protection risk policies | Report-only validated | Real anonymous-IP detection used to tune the sign-in-risk threshold |
| Workload identity CA | Not implemented | Workload Identities Premium was unavailable |
| Logic App and Azure Automation | Deployed and tested | Screenshot evidence exists; workflow, joiner/leaver, and runbook source files are not yet published |
| Human approval workflow | Prototype boundary | A condition gate was tested; Outlook or Teams approval integration was unavailable |
| Audit-log retention archive | Design-only | Live build was blocked by the disabled/read-only subscription |
| Sentinel/KQL identity monitoring | Planned | `kql-queries/` currently contains a placeholder only |
| Terraform, Bicep, or ARM deployment | Not implemented | No infrastructure-as-code artifacts are published |
| Tenant recovery and break-glass corrective rebuild | Open | Corrective design is documented in AD-022 |

## Where Things Live

The repository is organized by topic. Sprint writeups sit in the folder that best matches their subject.

| Content | Location |
|---------|----------|
| Sprint 1 (foundation) | `architecture/` |
| Sprint 2 (identity lifecycle) | `identity-access/` |
| Sprint 3 and 5 (authentication and federation) | `authentication/` |
| Sprint 4 (PIM) | `pim/` |
| Sprint 6 and 9 (governance) | `identity-governance/` |
| Sprint 7 (risk-based CA) | `conditional-access/` |
| Sprint 8 (automation writeup) | `logic-apps/` |
| Architecture decision log | [Architecture Decision Log](architecture/Architecture%20Decision%20Log.md) |
| Published Graph PowerShell scripts | `graph-scripts/` |
| Break-glass operational runbook | `runbooks/` |
| Screenshots and index | `screenshots/` |
| KQL placeholder | `kql-queries/` |

## Environment

- **Tenant:** `meridianfgoutlook.onmicrosoft.com`
- **Primary admin:** `adm-provost`
- **Emergency access:** `bg-emergency-01` and `bg-emergency-02`; corrective rebuild is tracked in AD-022
- **Platform:** Microsoft Entra ID, Microsoft 365, Azure
- **Tooling:** Microsoft Graph PowerShell SDK, Azure PowerShell, PowerShell 7 on macOS

## Licensing and Trial Tracker

| License / trial | Purpose | Recorded project status |
|-----------------|---------|-------------------------|
| Entra ID P2 trial | PIM, Identity Protection, access reviews, risk-based CA | Recorded expiry 8/15/2026 |
| Entra ID Governance trial | Lifecycle Workflows | Activated during Sprint 6 |
| Workload Identities Premium | Service-principal risk policies | Not held; separate SKU |
| Azure subscription | Logic App, Automation, log storage | Later disabled/read-only; blocked the Sprint 9 log-retention build |

Open actions: restore Global Administrator access, rebuild true break-glass protections per AD-022, and resolve the disabled subscription before live-operations work.

## Cost Tally

| Item | Cost |
|------|------|
| Azure free account and Entra Free tier (Sprint 1) | $0 |
| Entra P2 and Governance trials | $0 during trial periods |
| Logic App Consumption and Azure Automation (Sprint 8) | Negligible at lab scale |
| Log archive storage (Sprint 9, design only) | Estimated under $1/month at lab scale |
| **Recorded running total** | Effectively $0 during the documented build |

## Architecture Decisions

The [Architecture Decision Log](architecture/Architecture%20Decision%20Log.md) is the authoritative record. It runs from AD-001 through AD-022.

Sprint 8 decisions were deliberately renumbered from the colliding AD-011/012/013 labels to AD-018/019/020. Sprint 9 decisions are AD-021 (log retention delivered as design) and AD-022 (true break-glass and access-review exclusions).

## Real Challenges and Lessons Learned

EntraGuard didn't go smoothly. I hit access problems, made mistakes, and ran into platform limits. Each one made me stop, find the real cause, and rework part of the environment. Those moments taught me more than the clean configurations did.

### Entra roles and Azure RBAC are separate systems

My Global Administrator account could manage Microsoft Entra ID but couldn't touch the Azure subscription. I assumed a role assignment was broken. It wasn't.

Global Administrator controls the identity directory. Azure resources run on their own RBAC model, so the account needed a subscription role like Owner before it could manage resource groups or deployments.

**Takeaway:** Admin power in one Microsoft control plane doesn't carry over to another.

### Least privilege depends on where you assign the role

While setting up delegated admin for HR, I gave Patricia Nguyen the User Administrator role from her user profile. I had reached that profile through the Administrative Unit, so I thought the role was scoped. It wasn't. The role landed at directory scope, which gave her authority over the whole tenant.

I removed it and reassigned the role from the `au-hr` Administrative Unit itself. Then I tested the boundary:

- Patricia could reset an HR user's password.
- Patricia was denied when she tried the same action on a user outside HR.

**Takeaway:** How you navigate to a resource doesn't set the scope. Where you create the assignment does.

### A safe PIM migration can block its own test

I was moving from standing Global Administrator access to PIM eligibility. My first activation attempt failed because the role was already active.

I had kept the standing assignment on purpose as a safety net. That same assignment kept PIM from showing a true just-in-time activation. Neither the account I was converting nor the dedicated approver could remove it. I needed a break-glass account to finish the change.

**Takeaway:** Emergency-access accounts do real work, and they're more than a checkbox. Privileged-role migrations need careful sequencing. Verify your approver and recovery paths before you remove standing access.

### Test credentials can give you false confidence

I first tested Conditional Access in report-only mode with a Temporary Access Pass (TAP). The results showed the MFA requirement was satisfied, so the policy looked safe for the workforce.

It wasn't a fair test. A TAP already counts as MFA, so it hid the fact that most users were still password-only and not ready for enforcement. I reran the test with a password-only user and got the expected user-action-required result. That was the real cutover risk.

**Takeaway:** Test controls with the same credentials and conditions your actual users have. Otherwise a passing test only tells you what you want to hear.

### A break-glass account needs protection from automation

This was the worst incident of the project. I ran an access review on Global Administrator that included my primary admin account and both break-glass accounts. The review couldn't route to a valid reviewer who wasn't also a subject, and auto-apply and remove-on-non-response were both turned on.

The review stripped Global Administrator from every privileged account in the tenant. Nobody could restore access through the portal or PIM.

The design flaw was clear in hindsight. The emergency accounts had strong authentication and Conditional Access exclusions, but an automated review could still reach them. That means they weren't protected break-glass accounts at all.

The corrected design requires break-glass accounts to:

1. Hold permanent, active Global Administrator access.
2. Stay outside PIM eligibility.
3. Be excluded from every Conditional Access policy.
4. Be excluded from all automated access reviews.
5. Follow a separate manual recertification process.
6. Be monitored and tested regularly.
7. Keep their credentials stored outside the tenant.

> **Status:** Tenant recovery and the rebuild are still open. I'm not counting them as finished work.

I'm documenting the incident anyway, because hiding it would erase the project's best lesson. Fail-closed automation is only safe when the recovery path sits outside its reach.

### Platform and licensing limits, stated plainly

I couldn't finish some planned features in the live lab:

- **SCIM provisioning:** Stopped at connection validation because I had no real target endpoint.
- **Workload identity Conditional Access:** Not available under my lab licensing.
- **Durable log retention:** Blocked when the Azure subscription became disabled and read-only.

I didn't present any of these as done. I sorted the work into four groups:

| Category | Meaning |
| --- | --- |
| Implemented controls | Built and working in the lab |
| Validated boundaries | Tested to confirm the limit holds |
| Design-only work | Planned or documented, not deployed |
| Open corrective actions | Known gaps still to fix |

That sorting taught me the last lesson. A credible security portfolio doesn't claim everything worked. It shows what you built, what failed, how you investigated, and what comes next.
