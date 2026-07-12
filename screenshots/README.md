# Screenshot Index

| Filename | Sprint | What it shows |
|----------|--------|---------------|
| 02-entra-tenant-overview.png | 1 | Tenant overview showing the Meridian Financial Group tenant name, tenant ID, and primary domain |
| 03-security-defaults-enabled.png | 1 | Security Defaults enabled, confirming Architecture Decision AD-004 |
| 04-adm-account-created.png | 1 | Creation of the Tier 0 administrative account (`adm-provost`) |
| 05-adm-global-admin-assigned.png | 1 | Global Administrator role assigned to `adm-provost` |
| 06-auth-methods-tap-passkey-enabled.png | 1 | Authentication Methods policy showing Passkeys (FIDO2) and Temporary Access Pass enabled |
| 07-bg-accounts-created.png | 1 | Break-glass accounts `bg-emergency-01` and `bg-emergency-02` visible in the Users list |
| 08-bg-global-admin-assigned.png | 1 | Permanent direct Global Administrator assignment on a break-glass account |
| 09-bg-password-never-expires.png | 1 | Microsoft Graph PowerShell output confirming `PasswordPolicies = DisablePasswordExpiration` for both break-glass accounts |
| 10-bg01-passkey-registered.png | 1 | Device-bound passkey successfully registered for `bg-emergency-01` |
| 10-bg02-passkey-registered.png | 1 | Device-bound passkey successfully registered for `bg-emergency-02` |
| 11-bg-signin-detail-passkey.png | 1 | Sign-in log showing a successful device-bound passkey authentication with user approval, serving as evidence for Architecture Decision AD-003 |
| 12-ca-exclusion-group.png | 1 | `sg-ca-exclude-breakglass` membership showing only the two break-glass accounts |
| 13-tenant-owner-role-removed.png | 1 | Signup (tenant owner) account with no Microsoft Entra directory roles assigned |

> **Note:** Screenshot **01** was intentionally not captured because the Microsoft Entra tenant creation experience changed twice during Sprint 1, making the onboarding screens inconsistent with the final environment documented in this repository.
