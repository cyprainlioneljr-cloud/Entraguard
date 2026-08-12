# Architecture Decision Log

Authoritative record of the architecture decisions made across the EntraGuard project, with rationale. Decisions are numbered sequentially in the order made. Sprint 8's decisions were renumbered from their original AD-011/012/013 labels to AD-018/019/020 to resolve a numbering collision with the Sprint 5 and 6 decisions; content is unchanged.

## AD-001: Dedicated tenant for Meridian

**Sprint:** 1

**Decision:** Provision a new dedicated tenant (`meridianfgoutlook.onmicrosoft.com`) via a fresh Azure free-account signup, rather than reusing the Provost Inc SOC lab tenant.

**Rationale:** Enterprises do not share an identity plane across unrelated organizations. A dedicated tenant keeps evidence uncontaminated and gives fresh trial clocks. Constraint discovered during setup: tenant creation through the admin center requires a paid Entra P1 or P2 license; a paid Azure subscription alone is not sufficient, and trial licenses also fail that check, so new-account signup was the only clean route.

## AD-002: Defer the P2 trial to Sprint 2

**Sprint:** 1

**Decision:** Do not activate the Entra ID P2 trial during Sprint 1. Activate it at Sprint 2 kickoff.

**Rationale:** Sprint 1 needs nothing beyond Entra ID Free. The P2 trial is a 30-day clock, and spending a week of it on tenant setup and repo scaffolding is waste.

## AD-003: Break-glass accounts with phishing-resistant MFA

**Sprint:** 1

**Decision:** Create two break-glass accounts secured with device-bound FIDO2 passkeys, registered via Temporary Access Pass.

**Rationale:** Emergency access accounts must sign in when normal paths fail, but under mandatory MFA they still need strong authentication. Phishing-resistant passkeys satisfy both. Production design would use two hardware keys from different vendors; the lab used device-bound passkeys as the acceptable alternative.

**Note:** Later found incompletely implemented. See AD-022: the break-glass accounts were not excluded from access reviews and were swept into a recertification, so they did not meet the full definition of true break-glass.

## AD-004: Security defaults remain enabled until Conditional Access replaces them

**Sprint:** 1

**Decision:** Leave security defaults enabled at the end of Sprint 1, to be replaced by custom Conditional Access later.

**Rationale:** A tenant should never have a gap where neither security defaults nor CA protects sign-ins. Security defaults stay on until the custom CA persona set is ready to enforce. Fulfilled in AD-007.

## AD-005: Group-based licensing with admins direct-assigned

**Sprint:** 2

**Decision:** License workforce users through group-based licensing; assign admin accounts their licenses directly.

**Rationale:** Group-based licensing scales and ties licensing to role membership. Admin accounts are few and benefit from direct assignment so their licensing does not depend on dynamic group evaluation.

## AD-006: Custom Conditional Access persona set built from scratch

**Sprint:** 3

**Decision:** Design and build a custom Conditional Access persona set rather than relying on templates or Microsoft-managed policies.

**Rationale:** The tenant started empty. Building from scratch produces a persona architecture that maps to Meridian's actual structure and is fully explainable from first principles.

## AD-007: Disable security defaults ahead of CA enforcement

**Sprint:** 3

**Decision:** Disable security defaults once custom CA policies were built in report-only and ready to move toward enforcement.

**Rationale:** Fulfils AD-004. Security defaults and custom CA cannot both govern sign-ins cleanly, so security defaults retire only when custom CA is ready to take over. Mitigations documented for the transition window.

## AD-008: Build risk enforcement in Conditional Access, not legacy ID Protection policies

**Sprint:** 7

**Decision:** Implement sign-in-risk and user-risk enforcement through Conditional Access rather than the legacy Identity Protection risk policies.

**Rationale:** The legacy ID Protection policies retire on October 1, 2026. Building risk enforcement in CA is forward-compatible and keeps all access policy in one place.

## AD-009: Dormant external account held standing subscription Owner (finding and remediation)

**Sprint:** 4

**Date:** 2026-07-28

**Finding:** During the Azure resource PIM audit, the subscription had two standing Owner assignments belonging to `meridianfg_outlook.com#EXT#@meridianfgoutlook.onmicrosoft.com` (Object ID 8f12858c-9c4c-4807-89f5-b1e03fed18dd), an external MicrosoftAccount with zero authentication methods, zero licenses, and zero group memberships. This is the same dormant guest-format account flagged in Sprint 3, and the original account that bootstrapped the subscription. Azure's own IAM banner flagged the elevated access.

**Decision:** Grant adm-provost Owner first (safe management path), then remove both external Owner grants, then convert adm-provost Owner to PIM-eligible. Leave the external identity in the directory for formal Sprint 6 access review rather than deleting it mid-cutover.

**Rationale:** An external, MFA-less, dormant account with standing subscription Owner is a severe standing-privilege risk in a regulated financial tenant. Removing it directly without a replacement Owner risked stranding subscription management, so the replacement path was established first.

## AD-010: PIM tiering gradient for directory and resource roles

**Sprint:** 4

**Date:** 2026-07-28

**Decision:** Activation duration tightens as blast radius grows; approval reserved for crown-jewel roles only.

| Role | Duration | Approval |
|---|---|---|
| Global Administrator | 2h | Yes |
| Security Administrator | 4h | No |
| User Administrator | 8h | No |
| Azure subscription Owner | 4h | No |

**Rationale:** Gating every role behind approval trains admins to route around the control. Approval stays on the roles that can compromise the entire tenant. Operational roles get MFA and justification without an approval gate.

## AD-011: Dedicated app-assignment group over department group

**Sprint:** 5

**Date:** 2026-07-29

**Decision:** Create a dedicated group (app-saml-toolkit-users) with assigned membership for app access, rather than reusing a Sprint 2 dynamic department group.

**Rationale:** App access is a deliberate grant that should be governable on its own in Sprint 6 (access packages, access reviews), not a side effect of a department attribute. Assigned membership keeps the "who approved this access" story clean and reviewable.

## AD-012: OIDC app uses no client secret

**Sprint:** 5

**Date:** 2026-07-29

**Decision:** Register oidc-meridian-webapp with no client secret. Document that production would use a certificate or workload identity federation.

**Rationale:** A client secret is a shared string that can leak, be committed, or be stolen. Certificates keep the private key with the app; federated credentials remove the stored secret entirely. Client secrets are the weakest option and stolen app secrets are a common breach vector. Choosing the stronger model demonstrates security judgment.

## AD-013: SCIM demonstrated to the connection boundary

**Sprint:** 5

**Date:** 2026-07-30

**Decision:** Demonstrate the full Entra-side SCIM provisioning configuration up to the connection test, and document mappings and scoping as concepts, rather than standing up a live SCIM endpoint.

**Rationale:** Real SaaS SCIM targets gate the endpoint behind paid enterprise tiers; a self-hosted endpoint needs an Azure App Service. Test Connection against a reserved .invalid placeholder returned CredentialValidationUnavailable as expected, confirming Entra reaches and authenticates to the endpoint. This honestly shows the skill and the environment boundary. A live endpoint is a future enhancement.

## AD-014: Dormant external account dispositioned (Sprint 3-4-6 arc closed)

**Sprint:** 6

**Date:** 2026-07-30

**Decision:** Disable (not delete) the dormant external account meridianfg_outlook.com#EXT# (Object ID 8f12858c-...), staged for deletion after a grace period. Dispositioned directly rather than via a guest access review.

**Rationale:** Account confirmed fully orphaned (0 groups, roles, licenses). Disable-first is reversible and guards against non-interactive dependencies; direct disposition avoids per-guest Governance billing. Closes the arc: detected S3, Owner removed S4, dispositioned S6.

## AD-015: Consistent approver identity across governance mechanisms

**Sprint:** 6

**Date:** 2026-07-31

**Decision:** Use admin-approver as the specific approver for the access package, matching its role as PIM approver (S4) and access reviewer (S6).

**Rationale:** One approver persona across PIM, access reviews, and entitlement management gives a clean, consistent segregation-of-duties story.

## AD-016: Entitlement catalog kept internal-only

**Sprint:** 6

**Date:** 2026-07-31

**Decision:** Meridian-App-Access catalog not enabled for external users.

**Rationale:** Matches the internal self-service scenario and avoids per-guest Entra ID Governance billing (in effect since 1/15/2026).

## AD-017: Leaver workflow relies on account disable as the access cut

**Sprint:** 6

**Date:** 2026-07-31

**Decision:** Accept that the remove-from-all-groups task cannot remove users from dynamic groups; account disable is the definitive access cut. Note attribute-clear as a production enhancement.

**Rationale:** Dynamic group membership is attribute-computed; a departed user still matching department eq 'Risk and Compliance' persists in sg-dyn-risk-compliance. A disabled account has no usable access regardless.

## AD-018: Managed identity for all automation, no stored secrets

**Sprint:** 8

**Original label:** AD-011 (Sprint 8), renumbered to resolve collision.

**Decision:** Every automated identity (Logic App, Automation Account) uses a system-assigned managed identity. No client secrets in any workflow.

**Rationale:** Managed identities remove stored credentials entirely. Granting Graph app permissions to a managed identity has no portal UI; done via Graph PowerShell app-role assignments.

## AD-019: Least privilege differentiated by function

**Sprint:** 8

**Original label:** AD-012 (Sprint 8), renumbered to resolve collision.

**Decision:** Containment Logic App gets User.ReadWrite.All and Directory.ReadWrite.All (must disable and revoke). Hygiene runbook gets User.Read.All and AuditLog.Read.All only (must never modify).

**Rationale:** A read-only reporter cannot cause harm if compromised. Permissions scale to function, not convenience.

## AD-020: Approval gate built with built-in actions, email connector deferred

**Sprint:** 8

**Original label:** AD-013 (Sprint 8), renumbered to resolve collision.

**Decision:** The Office 365 Outlook approval connector requires a REST-enabled Exchange mailbox, which the P2-only trial lacks (MailboxNotEnabledForRESTAPI). Build the gate with a Condition node instead; document email or Teams approval as the licensed-tenant integration point.

**Rationale:** Honest-boundary pattern, the same approach used for the Sprint 5 SCIM connection boundary (AD-013) and the Sprint 7 workload identity boundary (AD-010). The approval-gate design stands; only the specific connector was unavailable.

## AD-021: Log retention delivered as design, not live build

**Sprint:** 9

**Decision:** Deliver Block 3 (log retention) as a validated design plus documentation rather than a live build, because the Azure subscription was disabled and read-only at implementation time, blocking resource creation.

**Rationale:** A disabled subscription is a billing state, not an identity-engineering task. Documenting the full retention design (categories, storage destination, lifecycle and immutability controls, cost model) still demonstrates the architecture, which is the skill being evaluated. Consistent with the honest-boundary pattern (AD-010, AD-013, AD-020).

**Follow-up:** Re-enable the subscription, then execute the build steps in the log-retention design document.

## AD-022: Break-glass accounts must be true break-glass and excluded from all access reviews

**Sprint:** 9

**Decision:** Break-glass accounts must be permanent active Global Administrator and explicitly excluded from every access review and every Conditional Access policy. Access reviews of privileged roles must use a named reviewer who is never a subject of the same review, and auto-apply with remove-on-non-response must never be armed on a review whose reviewer routing cannot resolve to a valid, non-subject reviewer.

**Rationale:** A Global Administrator access review with auto-apply removed the GA role from every privileged account, including both break-glass accounts and the primary admin, causing a full tenant lockout. Root cause was a break-glass configuration that could be swept into an automated review, combined with a reviewer routing (Managers) that could not resolve to a valid reviewer for admin accounts. A break-glass account an automated control can touch is not break-glass. Fail-closed non-response is only safe when a valid reviewer is guaranteed. This corrects the incomplete implementation noted in AD-003.

**Corrective actions (on access restoration):** rebuild both break-glass accounts as permanent active GA; confirm exclusion from all CA policies; exclude them from all access review scopes; recreate the recertification with admin-approver as a named reviewer; document a separate manual break-glass recertification process (two-person integrity check, credential rotation).
