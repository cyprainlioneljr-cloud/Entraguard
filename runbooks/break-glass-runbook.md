## Purpose

Emergency access accounts exist to recover the tenant when all normal administrative access has failed. They are the last door into the building. This runbook defines when they may be used, how they are used, and what must happen afterward.

## The accounts

| Account | Role | Credential design |
|---|---|---|
| `bg-emergency-01@meridianfgoutlook.onmicrosoft.com` | Global Administrator (permanent, direct) | Password (vaulted, never expires) + device-bound passkey |
| `bg-emergency-02@meridianfgoutlook.onmicrosoft.com` | Global Administrator (permanent, direct) | Password (vaulted, never expires) + device-bound passkey |

**Design principles applied**

- Cloud-only accounts with no dependency on federation, hybrid infrastructure, or external identity
- Permanent active Global Administrator accounts that are never PIM-eligible because activation workflows may be unavailable during an emergency
- Phishing-resistant passkeys that satisfy MFA requirements without relying on Conditional Access
- Members of `sg-ca-exclude-breakglass`, which is excluded from every Conditional Access policy
- Credentials stored outside the tenant they protect in a password manager to eliminate circular dependencies

## When to use and when not to

**Valid triggers (any one)**

- All normal admin accounts are locked out because of a Conditional Access misconfiguration, MFA outage, or credential loss
- Microsoft Entra MFA or hybrid authentication service outage prevents administrator sign-in
- The primary administrator account (`adm-provost`) is compromised and must be recovered using an independent account

**Not valid**

- Convenience ("my phone is charging")
- Routine administration
- Testing outside the scheduled quarterly verification

## Emergency procedure

1. Open a private browser session on a trusted device.
2. Sign in at `entra.microsoft.com` as `bg-emergency-01` (`bg-emergency-02` if `bg-emergency-01` fails).
3. Authenticate with the passkey. Use the password from the vault only if necessary.
4. Perform only the actions required to restore normal administrative access.
5. Sign out completely and close the browser.
6. Begin the post-use procedure immediately.

## Post-use procedure (mandatory, same day)

| # | Action | Why |
|---|---|---|
| 1 | Record who used the account, when it was used, why it was used, and what was changed | Creates an audit trail because any use is considered a security event |
| 2 | Review sign-in logs for both break-glass accounts | Confirms that only the documented activity occurred |
| 3 | Reset the password for the account that was used and update the password vault | Maintains credential hygiene after exposure |
| 4 | Re-register the passkey if a non-standard device was used | Restores the account to a known-good authentication state |
| 5 | Review audit logs for every change that was made | Verifies that only the minimum required changes occurred |

## Detection

These accounts must never sign in during normal operations. Any sign-in should be treated as a security incident until it is confirmed to be either a documented emergency or a scheduled verification test.

- **Current state (Sprint 1):** Manual review in **Entra ID > Monitoring & health > Sign-in logs**, filtering for UPNs containing `bg-emergency`
- **Planned (Sprint 7):** Forward sign-in logs to Log Analytics and create a Microsoft Sentinel analytics rule that alerts on any `bg-` account sign-in. Monitor membership changes to `sg-ca-exclude-breakglass` through a watchlist.

**Known gap:** Real-time alerting is not available until Sprint 7. Until then, quarterly verification tests and manual log reviews serve as compensating controls. This limitation is tracked in the Project Bible under Known Issues.

## Quarterly verification test

Every quarter, or after any authentication-related tenant change:

1. Sign in with each `bg-` account using its passkey.
2. Confirm that Global Administrator access works.
3. Verify the sign-in appears in the logs and that the authentication method is recorded as a passkey.
4. Record the test date and result in the Project Bible.
5. Sign out and confirm the password vault entries remain current.

## Lab vs. production

| Aspect | This lab | Production standard |
|---|---|---|
| Passkey storage | Both passkeys stored in one Authenticator app on one phone | Two hardware FIDO2 security keys from different vendors stored in separate physical locations |
| Credential custody | Single operator using one password manager | Dual custody with the password and second factor held separately by different people or secure locations |
| Alerting | Manual log review until Sprint 7 | Real-time SIEM alert on every break-glass account sign-in |
| Account naming | Discoverable (`bg-emergency-`) with monitoring used as the compensating control | Naming conventions vary. Some organizations use less obvious account names to reduce directory reconnaissance opportunities |
