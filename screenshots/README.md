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
