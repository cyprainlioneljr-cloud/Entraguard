## Introduction

Sprints 1 through 8 built the identity controls for Meridian Financial Group. Sprint 9 proves the two things a regulated firm is actually judged on: that the controls produce audit evidence on demand, and that every control maps to a compliance obligation someone can name. This document covers the framework mapping and a real production incident that occurred during the sprint, an access-review-driven Global Administrator lockout, which is documented in full because it is the most instructive artifact the project produced.

This is the identity-governance companion to the Azure Zero Trust SOC Lab. Where the SOC lab centered on detection and response, this sprint centers on audit readiness and compliance mapping for the identity control plane.

## Part 1: Control-to-Framework Mapping

### Why this matters

Controls without a compliance mapping are just configuration. In a regulated firm, every access control has to answer "which obligation does this satisfy," because that is the question an examiner asks. This matrix maps the EntraGuard controls to four frameworks, weighted by how central each is to an identity lab: SOX and GLBA carry the detail because they are the reason Meridian is modeled as a financial firm, ISO 27001 anchors the mapping to an internationally recognized standard, and ISO 42001 is included narrowly and honestly for the AI-governance hook carried from the SOC lab.

### SOX (Sarbanes-Oxley)

SOX is about the integrity of financial reporting. For identity, that means controlling who can touch financial systems, enforcing segregation of duties, and producing evidence that access is reviewed. These are the controls that most directly reduce the risk of unauthorized or unreviewed access to financial data.

| EntraGuard control | SOX relevance | Sprint |
|---|---|---|
| PIM just-in-time privileged roles | Removes standing privileged access to financial systems; every elevation is time-bound and logged | 4 |
| PIM approval gating on top roles | Enforces segregation of duties; a second party approves elevation | 4 |
| Dedicated approver identity (admin-approver) with zero directory roles | Separates the approver from the approved, a core SoD control | 4 |
| Access reviews / recertification | Produces the periodic attestation SOX expects: who holds access and whether it is still needed | 6, 9 |
| Audit log evidence export | The auditable trail of who changed access controls and when | 9 |
| Conditional Access scoped by persona | Restricts access to sensitive systems by role and risk | 3, 7 |
| Entitlement management access packages | Access to financial-role resources is requested, approved, and time-limited, not standing | 6 |

### GLBA (Gramm-Leach-Bliley Act)

GLBA is about safeguarding customer financial data. For identity, that means strong authentication, least-privilege access to systems holding financial data, and controls that detect and respond to compromised identities.

| EntraGuard control | GLBA relevance | Sprint |
|---|---|---|
| MFA registration and enforcement | Strong authentication protecting access to financial data | 3, 7 |
| Identity Protection risk policies | Detects and responds to compromised identities before they reach financial data | 7 |
| Risk-based Conditional Access | Blocks or challenges risky sign-ins that could expose customer data | 7 |
| Least-privilege app permissions (SAML claims trimmed, OIDC User.Read only) | Applications touch only the identity data they need | 5 |
| Lifecycle workflows (automated leaver offboarding) | Revokes access to financial data promptly when a person leaves | 6, 8 |
| Dynamic groups keyed off department | Access to data follows role, reducing over-provisioning | 2 |
| Log archive to durable storage (design) | Retains the evidence needed to investigate potential data exposure | 9 |

### ISO 27001

ISO 27001 Annex A (2022 revision) has direct identity controls. This mapping shows the EntraGuard build satisfies the recognized international standard, not just US financial regulation.

| ISO 27001:2022 control | EntraGuard control | Sprint |
|---|---|---|
| A.5.15 Access control | Conditional Access persona architecture | 3, 7 |
| A.5.16 Identity management | User lifecycle, dynamic groups, administrative units | 2 |
| A.5.17 Authentication information | Authentication methods, passwordless, MFA | 3 |
| A.5.18 Access rights | Access reviews, entitlement management, recertification | 6, 9 |
| A.8.2 Privileged access rights | PIM for Entra and Azure roles, tiered admin | 4 |
| A.8.15 Logging | Audit log evidence, diagnostic settings archive design | 9 |
| A.8.16 Monitoring activities | Sign-in and audit log hunting, risk detections | 7 |

### ISO 42001 (AI Management Systems)

ISO 42001 is the AI-governance standard, and its center of gravity lives in the companion SOC lab. In an identity project the hook is narrow but real: AI systems are accessed by identities, human and workload, and those identities need the same governance as any other privileged access.

| ISO 42001 theme | EntraGuard control | Notes |
|---|---|---|
| Access control for AI systems | PIM and Conditional Access would govern human access to AI tooling | The same privileged-access model applies to AI system administration |
| Workload identity governance | Service principal and managed identity controls | Sprint 8 governed a managed identity's app-role assignments; the same discipline governs identities that call AI services |

Deep AI-governance treatment (model risk, data governance, AI lifecycle) is out of scope for an identity lab and is covered in the SOC lab. Including ISO 42001 here honestly, as a narrow identity hook rather than a full mapping, reflects where the boundary actually sits.

## Part 2: Incident, Access-Review-Driven Global Administrator Lockout

### Summary

During the Sprint 9 privileged-role recertification block, a Global Administrator access review with auto-apply enabled removed the Global Administrator role from every privileged account in the tenant, including both emergency-access (break-glass) accounts and the primary admin. The result was a full tenant lockout requiring Microsoft tenant recovery. The root cause was a break-glass configuration that did not meet the definition of true break-glass, combined with an access review scoped and configured in a way that swept those accounts in.

This incident is documented in full because it is a genuine, first-hand version of a failure mode most identity engineers only read about, and because the corrective decision (AD-015) materially strengthens the tenant's design.

### Timeline

1. A quarterly Global Administrator recertification review was created with auto-apply enabled and non-response set to remove access.
2. The first review was created with reviewer type set to Managers. The admin and break-glass accounts have no manager attribute, so the review could not route to a valid reviewer separate from the subjects.
3. The review was stopped and deleted to recreate it correctly. The auto-apply behavior applied a remove outcome during teardown, stripping Global Administrator from the reviewed accounts.
4. The recreated review surfaced only three Global Administrator holders: both break-glass accounts and the primary admin. This itself was a positive finding: the GA population was correctly minimal, with no sprawl.
5. The reviewer could not approve, because the reviewer identity was also a subject, which Entra blocks as a segregation-of-duties violation.
6. Verification confirmed all three accounts had lost Global Administrator: Assigned Roles empty, Add Assignments disabled, PIM showing no eligible roles to activate. No self-service recovery path remained.
7. The recovery route is Microsoft tenant recovery through the Data Protection team, since no account retained a role able to reassign Global Administrator.

### Root cause

Two design faults combined:

**The break-glass accounts were not true break-glass.** True break-glass accounts hold permanent active Global Administrator and are excluded from every access review and Conditional Access policy. These accounts were reviewable, so an access review could and did strip their access. This is the primary fault.

**The access review was configured to act automatically without a guaranteed valid reviewer.** Auto-apply plus remove-on-non-response is the correct fail-closed posture for ordinary privileged accounts, but it is dangerous when combined with a reviewer routing (Managers) that cannot resolve to a valid reviewer for admin and emergency accounts. When no valid reviewer exists and non-response means remove, the outcome is guaranteed removal.

### What the controls got right

The incident was not all failure. Several controls behaved exactly as designed and are worth noting:

- The GA population was correctly minimal (two break-glass plus one admin, no sprawl), which is what a healthy tenant looks like.
- Entra correctly blocked self-review, enforcing segregation of duties even under pressure.
- The audit trail captured every step, the review creation, the role removals, so the incident is fully reconstructable from the logs exported in Block 1.

### Impact

Administrative access was lost. No built configuration was lost: users, groups, Conditional Access policies, PIM configuration, the Logic App, and the automation runbook all remained intact in the tenant. The impact was loss of control, not loss of work, and it is recoverable through Microsoft tenant recovery.

### Architecture Decision AD-015

**Decision:** Break-glass accounts must be configured as true break-glass: permanent active Global Administrator, and explicitly excluded from every access review and every Conditional Access policy. Access reviews of privileged roles must use a named reviewer who is never a subject of the same review, and auto-apply with remove-on-non-response must never be armed on a review whose reviewer routing cannot resolve to a valid, non-subject reviewer.

**Rationale:** The lockout proved that a break-glass account which can be swept into an automated access review is not break-glass at all. Emergency access only works if it is immune to the automated controls that govern ordinary accounts. Separately, an access review with teeth (auto-apply, fail-closed non-response) is only safe when a valid reviewer is guaranteed; otherwise fail-closed becomes guaranteed lockout.

**Corrective actions (on access restoration):**
1. Rebuild both break-glass accounts as permanent active Global Administrator.
2. Exclude break-glass accounts from all Conditional Access policies (confirm existing exclusions survived).
3. Exclude break-glass accounts from all access review scopes.
4. Recreate the privileged-role recertification with admin-approver as a named reviewer, never a subject.
5. Document a separate, manual break-glass recertification process (two-person integrity check, credential rotation) rather than including break-glass in the automated review.

### Lessons learned

- Auto-apply on an access review is a live control, not a documentation setting. It acts, including during teardown. Treat it as production change.
- Break-glass means immune to automation. If an automated control can touch a break-glass account, it is not break-glass.
- Fail-closed is only safe with a guaranteed valid reviewer. Remove-on-non-response plus an unresolvable reviewer equals guaranteed removal.
- Reviewer routing by Manager assumes accurate manager attributes. Admin and service accounts rarely have managers, so Manager routing silently fails for exactly the accounts that matter most.
- A minimal privileged population is good hygiene and made this recoverable in scope, three accounts, not thirty.

## Conclusion

Sprint 9 delivered the audit-evidence and compliance-mapping layer that makes the earlier identity build legible to a regulator, and it produced a real incident that hardened the design. The framework matrix ties every control to a named obligation across SOX, GLBA, ISO 27001, and ISO 42001. The lockout incident, rather than being hidden, is documented as the project's strongest demonstration of production judgment: a genuine privileged-access failure, correctly diagnosed, honestly recorded, and resolved with a concrete architecture decision that prevents recurrence.
