# Entraguard
Enterprise IAM lab built on Microsoft Entra ID , identity governance, Conditional Access, PIM, and lifecycle automation for a simulated financial services firm.
## Sprint Status

| Sprint | Name | Status | Completed |
|--------|------|--------|-----------|
| 1 | Foundation & Tenant Design |  ✅ Complete| — |
| 2 | Identity Lifecycle & Structure |  ✅ Complete | — |
| 3 | Authentication & Access Foundations | ✅ Complete | — |
| 4 | Privileged Access | ✅ Complete | — |
| 5 | Federation & App Integration | ✅  | — |
| 6 | Identity Governance | ⬜ Backlog | — |
| 7 | Identity Protection & Monitoring | ⬜ Backlog | — |
| 8 | Identity Automation | ⬜ Backlog | — |
| 9 | Governance, Audit & Compliance | ⬜ Backlog | — |
| 10 | Portfolio Finalization & Live Operations | ⬜ Backlog | — |


## Architecture Decisions (append)

### AD-009: Dormant external account held standing subscription Owner (finding + remediation)
**Date:** 2026-07-28
**Finding:** During the Azure resource PIM audit, the subscription had two standing
Owner assignments belonging to `meridianfg_outlook.com#EXT#@meridianfgoutlook.onmicrosoft.com`
(Object ID 8f12858c-9c4c-4807-89f5-b1e03fed18dd), an external MicrosoftAccount with
zero authentication methods, zero licenses, and zero group memberships. This is the
same dormant guest-format account flagged in Sprint 3. It is the original account
that bootstrapped the subscription. Azure's own IAM banner flagged the elevated access.
**Decision:** Remediate by granting adm-provost Owner first (safe management path),
then removing both external Owner grants, then converting adm-provost Owner to
PIM-eligible. Leave the external identity in the directory for formal Sprint 6 access
review rather than deleting it mid-cutover.
**Rationale:** An external, MFA-less, dormant account with standing subscription Owner
is a severe standing-privilege risk in a regulated financial tenant. Removing it
directly without a replacement Owner risked stranding subscription management, so the
replacement path was established first.

### AD-010: PIM tiering gradient for directory and resource roles
**Date:** 2026-07-28
**Decision:** Activation duration tightens as blast radius grows; approval reserved for
crown-jewel roles only.
| Role | Duration | Approval |
| Global Administrator | 2h | Yes |
| Security Administrator | 4h | No |
| User Administrator | 8h | No |
| Azure subscription Owner | 4h | No |
**Rationale:** Gating every role behind approval trains admins to route around the
control. Approval stays on the roles that can compromise the entire tenant. Operational
roles get MFA and justification without an approval gate.

---

## Lessons Learned (append)

- Break-glass is not always needed to remove standing access. It was required in Part 1
  because an account cannot cleanly remove its own standing assignment (self-referential
  block). Patricia's User Admin removal, done by the higher-privileged adm-provost on a
  different account, completed cleanly without break-glass.
- The most dangerous standing privilege was on the resource plane (subscription Owner),
  not the identity plane. It surfaced only because the audit extended to Azure resource
  roles. Cover both planes.
- Azure resource PIM enforces time-bound eligibility by default (1-year max, no permanent
  eligibility). Entra role PIM allows permanent eligibility. The Azure default is
  stricter and arguably better hygiene.
- A clean post-cutover alert board is evidence the remediation worked, not a non-event.

---

## Known Issues / Open Items (append)

- Root-scope elevated access: adm-provost holds User Access Administrator inherited from
  root (Tenant Root Group). This is the elevation path used to manage the subscription.
  Azure's "elevated access" banner refers to this after the external-Owner remediation.
  Separate root-scope cleanup, deferred and noted.
- Subscription is named "Azure subscription 1" (default). In a production tenant this
  would be renamed to something meaningful (e.g. meridian-prod-01). Not changed to avoid
  mid-sprint churn.
- Dormant external account (meridianfg_outlook.com#EXT#) remains in the directory,
  Owner role removed, flagged for Sprint 6 access review and possible deletion.

---

## Current Sprint (update)

Sprint 4 (Privileged Access) COMPLETE. Both identity-plane roles (Global Admin, User
Admin, Security Admin) and resource-plane (subscription Owner) converted to just-in-time.
Standing access eliminated except by-design break-glass. Headline finding (dormant
external Owner) remediated. Next: Sprint 5 (Federation and App Integration).

P2 trial expires 8/15/2026. Decision checkpoint 8/9/2026. Sprints 5 and 6 lean on
P2/Governance features; prioritize before the deadline.
## Architecture Decisions (append)

### AD-011: Dedicated app-assignment group over department group
**Date:** 2026-07-29
**Decision:** Create a dedicated group (app-saml-toolkit-users) with assigned
membership for app access, rather than reusing a Sprint 2 dynamic department group.
**Rationale:** App access is a deliberate grant that should be governable on its own
in Sprint 6 (access packages, access reviews), not a side effect of a department
attribute. Assigned membership keeps the "who approved this access" story clean and
reviewable.

### AD-012: OIDC app uses no client secret
**Date:** 2026-07-29
**Decision:** Register oidc-meridian-webapp with no client secret. Document that
production would use a certificate or workload identity federation.
**Rationale:** A client secret is a shared string that can leak, be committed, or be
stolen. Certificates keep the private key with the app; federated credentials remove
the stored secret entirely. Client secrets are the weakest option. Stolen app secrets
are a common breach vector (app authenticates with no user). Choosing the stronger
model demonstrates security judgment.

### AD-013: SCIM demonstrated to the connection boundary (Path A)
**Date:** 2026-07-30
**Decision:** Demonstrate the full Entra-side SCIM provisioning configuration up to the
connection test, and document mappings/scoping as concepts, rather than standing up a
live SCIM endpoint.
**Rationale:** Real SaaS SCIM targets gate the endpoint behind paid enterprise tiers; a
self-hosted endpoint needs an Azure App Service (possible cost, unsupported .NET sample).
Test Connection against a reserved .invalid placeholder returned CredentialValidationUnavailable
as expected, confirming Entra reaches and authenticates to the endpoint. This honestly
shows the skill and the environment boundary. A live endpoint is a future enhancement.

---

## Lessons Learned (append)

- Gallery apps pre-populate SAML Identifier and Reply URL; custom non-gallery apps do not.
- NameID format matters: the SAML Toolkit expects emailAddress format. UPN worked only
  because UPN and email aligned on the .onmicrosoft.com domain. A mismatch fails sign-in.
- Delegated vs application permissions is a core interview distinction: delegated acts as
  the signed-in user (bounded); application acts as the app with no user (higher risk).
- Not creating something can be the stronger security stance (OIDC client secret).
- SCIM mappings and scoping blades unlock only after a validated live connection.

---

## Applications Registered (append)

- Microsoft Entra SAML Toolkit (gallery, SAML SSO, group-assigned, claims trimmed) - SSO validated
- oidc-meridian-webapp (App registration, OIDC, single-tenant, User.Read, no secret)
- scim-meridian-provisioning (non-gallery, SCIM provisioning config to connection boundary)

---

## Current Sprint (update)

Sprint 5 (Federation and App Integration) COMPLETE. Three integrations demonstrated:
SAML SSO (live federated sign-in proven), OIDC (least-privilege, secure credential
choice), SCIM (configured to connection boundary, mappings/scoping documented). All on
P1, no P2 clock consumed. Next: Sprint 6 (Identity Governance), which is P2-dependent.

P2 trial expires 8/15/2026. Decision checkpoint 8/9/2026. Sprint 6 leans on P2/Governance
(access reviews, entitlement management, lifecycle workflows); prioritize before deadline.

