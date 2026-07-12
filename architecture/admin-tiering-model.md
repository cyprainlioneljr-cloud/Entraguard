## Principle

Separate identities by privilege level so that compromising a lower-privileged account cannot lead to a higher-privileged one. Every administrative identity has a single, well-defined purpose, and the Tier 0 population remains small, documented, and fully justified.

## Current Tier 0 population (end of Sprint 1)

| Identity | Purpose | Roles | Protection |
|---|---|---|---|
| `adm-provost` | Daily administrative work | Global Administrator (direct; becomes PIM-eligible in Sprint 4) | Password + Authenticator MFA |
| `bg-emergency-01` | Emergency access only | Global Administrator (permanent by design) | Passkey + vaulted, never-expiring password |
| `bg-emergency-02` | Emergency access only | Global Administrator (permanent by design) | Passkey + vaulted, never-expiring password |
| Signup account ("tenant owner") | Azure billing ownership only | **None** (Global Administrator removed at the end of Sprint 1) | Vaulted credentials; any sign-in is treated as a security incident |

Total Global Administrators: **3**. This aligns with Microsoft's recommendation to keep the number of Global Administrators below five, and every account has a clearly documented business justification.

## Attack surface rationale

| Anti-pattern avoided | How |
|---|---|
| Forgotten first administrator account retaining Global Administrator rights | The signup account was stripped of all directory roles once alternative administrative accounts were validated |
| Administrative account used for email or daily productivity | The `adm-` account is reserved exclusively for administration. A separate workforce identity is introduced in Sprint 2 |
| Single point of administrative failure | Two independent break-glass accounts provide separate recovery paths and are tested regularly |
| Excessive standing privilege | Sprint 4 converts the `adm-` account to PIM-eligible access, leaving only the break-glass accounts with permanent Global Administrator privileges |

## Planned evolution

| Sprint | Change |
|---|---|
| 2 | Introduce Administrative Units to provide delegated administration for departments |
| 4 | Implement Privileged Identity Management. The `adm-` account becomes eligible instead of permanently assigned. Configure role settings, approval workflows, activation alerts, and additional tiered administrator roles such as User Administrator scoped to Administrative Units |
| 7 | Implement Microsoft Sentinel alerting for administrator sign-ins and role changes |

## Interview framing

> "Our tenant maintains three Global Administrators: one operational administrator that transitions to PIM-eligible access, two permanent break-glass accounts for emergency recovery, and a billing owner with no Microsoft Entra directory roles. Every Global Administrator has a documented business justification, so any account outside that list is immediately investigated."
