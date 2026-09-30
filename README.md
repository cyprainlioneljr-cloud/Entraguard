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
