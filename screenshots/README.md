# Screenshot Index

| Filename | Sprint | What it shows |
|----------|--------|---------------|
| 01-tenant-created-manage-tenants.png | 1 | Manage tenants view at creation: Default Directory, primary domain, tenant ID |
| 02-entra-tenant-overview.png | 1 | Tenant overview, org name, tenant ID, primary domain |
| 03-security-defaults-enabled.png | 1 | Security defaults confirmed enabled (AD-004) |
| 04-adm-account-created.png | 1 | Tier 0 admin account (adm-provost) creation |
| 05-adm-global-admin-assigned.png | 1 | Global Administrator assigned to adm-provost |
| 06-auth-methods-tap-passkey-enabled.png | 1 | Passkey (FIDO2) and Temporary Access Pass policies enabled |
| 07-bg-accounts-created.png | 1 | Break-glass accounts bg-emergency-01/02 in the Users list |
| 08-bg-global-admin-assigned.png | 1 | Permanent direct Global Administrator on a break-glass account |
| 09-bg-password-never-expires.png | 1 | Graph PowerShell, DisablePasswordExpiration verified on both bg- accounts |
| 10-bg01-passkey-registered.png | 1 | Device-bound passkey on bg-emergency-01 (Security info) |
| 10-bg02-passkey-registered.png | 1 | Device-bound passkey on bg-emergency-02 (Security info) |
| 11-bg-signin-detail-passkey.png | 1 | Sign-in log detail: passkey ceremony, succeeded, user approved (AD-003 evidence) |
| 12-ca-exclusion-group.png | 1 | sg-ca-exclude-breakglass members: exactly the two bg- accounts |
| 13-tenant-owner-role-removed.png | 1 | Signup (tenant owner) account with no directory roles assigned |
| 14-p2-trial-activated.png | 2 | Entra ID P2 trial in Meridian, license assigned to adm-provost, expiry 8/15/2026 |
| 15-first-user-properties.png | 2 | First workforce user (Sarah Mitchell) with full attribute set, portal method |
| 16-bulk-user-script-run.png | 2 | Graph bulk creation: 24 users created, department summary verification |
| 17-workforce-user-list.png | 2 | Populated directory after bulk provisioning |
| 18-dynamic-group-trading.png | 2 | sg-dyn-trading members: 4 traders via rule, zero manual assignment |
| 19-dynamic-groups-script-run.png | 2 | Scripted creation of remaining 7 dynamic groups with rules |
| 20-dynamic-groups-all.png | 2 | All 8 sg-dyn groups, Security type, Dynamic membership |
| 21-dynamic-group-counts.png | 2 | Scripted member counts, all 8 populated, total 25 |
| 22-au-hr-created.png | 2 | au-hr Administrative Unit with the 3 HR members |
| 23-au-scoped-role.png | 2 | Patricia Nguyen User Administrator scoped to au-hr (Resource Name column) |
| 24-au-delegation-reset-success.png | 2 | Scoped admin resets password inside au-hr (temporary password masked) |
| 25-au-delegation-denied.png | 2 | Same admin denied on user outside the AU: the boundary working |
| 26-au-audit-trail.png | 2 | Audit log: three correlated entries for the allowed reset, attributed to the scoped admin |
| 27-group-based-licensing.png | 2 | P2 inherited via all 8 dynamic groups, 26/100 assigned |
| 27-auth-methods-registration-details-before.png | 3 | Pre-enforcement registration baseline. Three accounts MFA-capable, all 25 workforce users Not-Capable. |
| 27a-auth-methods-policy-before.png | 3 | Authentication methods policy. FIDO2, Authenticator, TAP enabled; SMS and Voice disabled. |
| 28-ca01-blocklegacyauth-details.png | 3 | CA01 block-legacy-auth policy details, report-only. |
| 29-ca-policies-inventory.png | 3 | Conditional Access board, four policies, zero Microsoft-managed. |
| 29b-ca04-renamed-from-ca11.png | 3 | Numbering correction. CA11 renamed to CA04 into the global block. |
| 30-ca03-registration-target-useraction.png | 3 | CA03 targeting the Register security information user action. |
| 31-ca03-report-only-created.png | 3 | Full five-policy persona board, all report-only. |
| 32-named-locations-both-chicago-trusted.png | 3 | Named locations list. Chicago (trusted) and HighRisk-Countries, neither in a policy yet. |
| 33-named-location-highrisk-countries.png | 3 | High-risk countries location created (interim, before Chicago added). |
| 35-signin-report-only-verdicts-tom.png | 3 | Tom Gallagher, TAP sign-in. CA02 report-only verdict Success (TAP satisfies MFA). |
| 36-signin-report-only-useraction-david-passwordonly.png | 3 | David Okonkwo, password-only. CA02 report-only verdict User action required. The enforcement-gap proof. |
| 36a-david-registration-prompt.png | 3 | David pushed into Authenticator registration during the password-only test. |
| 37-security-defaults-disabled-confirmed.png | 3 | Tenant Properties confirming Security Defaults Disabled. Personal technical-contact email masked. |
| `38-admin-approver-created.png` | 4 | The dedicated `admin-approver` account created via portal with 0 roles and 0 group memberships, before P2 and passkey assignment |
| `39-pim-global-admin-role-settings.png` | 4 | Global Administrator role settings, Activation tab: 2h max duration, Azure MFA, require justification, require approval, with `admin-approver` named as approver |
| `40-pim-adm-provost-eligible-created.png` | 4 | `adm-provost` under the Eligible assignments tab for Global Administrator |
| `41-pim-activation-blocked-already-active.png` | 4 | Activation request panel filled in; this attempt failed with "role already active" because standing GA was still held |
| `42-pim-activation-pending-approver-view.png` | 4 | Signed in as `admin-approver`, pending GA activation request from ADM-Provost visible under Approve requests |
| `43-pim-approval-decision.png` | 4 | Approval panel with request details (2h window, 14:01 to 16:01) and approver justification entered |
| `44-pim-activation-active.png` | 4 | Requester side: `adm-provost` GA now Activated with end time 4:12 PM, not Permanent |
| `45-pim-user-admin-role-settings.png` | 4 | User Administrator role settings: 8h max duration, Azure MFA, justification required, no approval (operational tier) |
| `46-pim-patricia-eligible-created.png` | 4 | Patricia Nguyen under Eligible assignments for User Administrator, after conversion from standing |
| `47-pim-security-admin-role-settings.png` | 4 | Security Administrator role settings: 4h max duration, Azure MFA, justification required, no approval |
| `48-pim-azure-owner-external-finding-before.png` | 4 | IAM role assignments showing two standing Owner grants to the dormant external account, plus the Azure elevated-access warning banner (the finding) |
| `49-pim-azure-owner-external-removed.png` | 4 | IAM after remediation: only adm-provost holds Owner, external account grants removed, privileged count reduced |
| `50-pim-azure-owner-role-settings.png` | 4 | Azure resource Owner role settings: 4h activation, MFA and justification, time-bound eligibility (1yr max, no permanent) |
| `51-pim-azure-owner-eligible-created.png` | 4 | adm-provost as eligible Owner with a one-year time-bound eligibility window |
| `52-pim-alerts-clean.png` | 4 | Entra role PIM alerts blade showing no results after the cutover (clean board as remediation evidence) |
| `53-app-saml-toolkit-group-created.png` | 5 | Dedicated app-assignment group app-saml-toolkit-users with two test members (David Okonkwo, Tom Gallagher), assigned membership |
| `54-saml-toolkit-app-added.png` | 5 | Microsoft Entra SAML Toolkit added to the tenant, Application ID and Object ID visible |
| `55-saml-toolkit-group-assigned.png` | 5 | The assignment group attached to the app under Users and groups (group-based assignment) |
| `56-saml-basic-configuration.png` | 5 | Committed Basic SAML Configuration: Identifier, Reply URL, Sign on URL all set |
| `57-saml-claims-reviewed.png` | 5 | Attributes and claims after trimming givenname and surname to least privilege |
| `58-saml-sso-test-success.png` | 5 | SAML Toolkit greeting the federated user by UPN, confirming successful SSO round trip |
| `59-saml-toolkit-configuration-view.png` | 5 | Toolkit SP-side SAML configuration page showing matching Entity ID |
| `60-oidc-app-registration-created.png` | 5 | OIDC app registration overview: single-tenant, web redirect URI, activated |
| `61-oidc-api-permissions.png` | 5 | API permissions showing only Microsoft Graph User.Read delegated (least privilege) |
| `62-scim-app-created.png` | 5 | Non-gallery provisioning app, get-started overview with the three configuration tasks |
| `63-scim-provisioning-mode-automatic.png` | 5 | Provisioning Mode set to Automatic, Admin Credentials section revealed |
| `64-scim-admin-credentials-fields.png` | 5 | SCIM Connectivity page: Bearer authentication, Tenant URL, Secret Token fields |
| `65-scim-test-connection-expected-failure.png` | 5 | Test Connection failure (CredentialValidationUnavailable) against a placeholder endpoint, confirming the connection boundary |




