# EntraGuard: Enterprise Identity Security and Governance Lab

EntraGuard is a multi-sprint Microsoft Entra ID zero-trust identity and access management lab simulating a regulated financial firm, Meridian Financial Group. It is the identity-focused companion to the completed Azure Zero Trust SOC Lab (Provost Inc): where the SOC lab centered on detection, SIEM, and response, EntraGuard centers on identity as the control plane, governance, lifecycle, privileged access, and access-based defense.

The lab is built and documented sprint by sprint against a real Entra tenant, mapped to the SC-300, AZ-500, and SC-200 certifications.

## Sprint Status

| Sprint | Focus | Status |
|--------|-------|--------|
| 1 | Foundation and Tenant Design | Complete |
| 2 | Identity Lifecycle and Structure | Complete |
| 3 | Authentication and Access Foundations | Complete |
| 4 | Privileged Access with PIM | Complete |
| 5 | Federation and Application Integration | Complete |
| 6 | Identity Governance | Complete |
| 7 | Identity Protection and Risk-Based Conditional Access | Complete |
| 8 | Identity Automation | Complete |
| 9 | Governance, Audit, and Compliance | Complete (with documented deviations, see AD-014, AD-015) |
| 10 | Portfolio Finalization and Live Operations | Pending |

Sprint 9 note: audit-evidence and framework-mapping objectives were met. Block 3 (log retention) was delivered as a design rather than a live build due to a disabled subscription (AD-014). Block 2 (recertification) surfaced a Global Administrator lockout incident, documented in full and resolved with AD-015. Tenant recovery is an open item.

## Where things live

The repository is organized by topic. Sprint writeups sit in the topic folder that best matches their subject, with cross-link stubs from other relevant folders for multi-topic sprints.

| Content | Location |
|---------|----------|
| Sprint 1 (foundation) | `architecture/` |
| Sprint 2 (identity lifecycle) | `identity-access/` |
| Sprint 3 and 5 (auth, federation) | `authentication/` |
| Sprint 4 (PIM) | `pim/` |
| Sprint 6 and 9 (governance) | `identity-governance/` |
| Sprint 7 (risk-based CA) | `conditional-access/` |
| Sprint 8 (automation) | `logic-apps/` |
| Architecture decision log | `architecture/decision-log.md` |
| Graph PowerShell scripts | `graph-scripts/` |
| Azure scripts | `azure-scripts/` |
| KQL queries | `kql-queries/` |
| Audit evidence exports | `reports/` |
| Screenshots and index | `screenshots/` |

## Environment

- **Tenant:** `meridianfgoutlook.onmicrosoft.com` (tenant ID `f54eb811-e94a-4bd3-9931-65e9d5e160e9`)
- **Primary admin:** adm-provost
- **Emergency access:** bg-emergency-01, bg-emergency-02 (see AD-015 for corrective rebuild)
- **Platform:** Microsoft Entra ID, Microsoft 365, Azure subscription
- **Tooling:** Microsoft Graph PowerShell SDK (sub-modules pinned to matching versions), Azure PowerShell, PowerShell 7 on macOS

## Licensing and Trial Tracker

| License / trial | Purpose | Status |
|-----------------|---------|--------|
| Entra ID P2 (trial) | PIM, Identity Protection, access reviews, risk-based CA | Trial, expiry 8/15/2026 (checkpoint was 8/9/2026) |
| Entra ID Governance (trial) | Lifecycle Workflows (Sprint 6) | 30-day trial, activated Sprint 6, verify remaining days |
| Workload Identities Premium | Service principal risk policies (CA22) | Not held, separate SKU (AD-010) |
| Azure subscription | Resource builds (Logic App, Automation, log storage) | Disabled and read-only, blocks new resources (AD-014); tenant recovery open |

Action items: confirm Governance trial days remaining; resolve the disabled subscription; recover Global Administrator access (see AD-015).

## Cost Tally

| Item | Cost |
|------|------|
| Azure free account and Entra Free tier (Sprint 1) | $0 |
| Entra P2 and Governance trials | $0 (trial) |
| Logic App (Consumption), Azure Automation (Sprint 8) | Negligible at lab scale |
| Log archive storage (Sprint 9, design only, not built) | Would be under $1/month at lab scale |
| **Running total** | Effectively $0 to date |

## Architecture Decisions

The full decision log (AD-001 through AD-015) lives at `architecture/decision-log.md`. It is the authoritative record of why the design looks the way it does.


