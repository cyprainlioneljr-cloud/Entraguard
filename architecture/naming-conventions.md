## Why naming matters

Names are the first security control nobody thinks of as one. A consistent naming scheme makes anomalies visible. An account that doesn't match any pattern becomes a finding, administrative accounts are immediately recognizable in log entries, and delegation scoping such as dynamic groups and Administrative Units can rely on predictable prefixes.

## Identity objects

| Object type | Pattern | Example | Notes |
|---|---|---|---|
| Standard user | `firstname.lastname@<domain>` | `jane.doe@meridianfgoutlook.onmicrosoft.com` | Workforce identities (Sprint 2) |
| Tier 0 admin account | `adm-<name>` | `adm-provost` | Visually distinct in all logs; separate from workforce identities |
| Break-glass account | `bg-emergency-<nn>` | `bg-emergency-01` | Discoverable by design with monitoring as the compensating control |
| Service account | `svc-<system>-<purpose>` | `svc-hr-provisioning` | Reserved for Sprint 5 and later |

## Groups

| Group purpose | Pattern | Example |
|---|---|---|
| Security group | `sg-<purpose>` | `sg-ca-exclude-breakglass` |
| Conditional Access exclusion group | `sg-ca-exclude-<what>` | `sg-ca-exclude-breakglass` |
| Dynamic department group | `sg-dyn-<department>` | `sg-dyn-finance` (Sprint 2) |
| Microsoft 365 collaboration group | `m365-<team>` | `m365-risk-compliance` (Sprint 2) |

## Conditional Access policies (Sprint 3 onward)

**Pattern**

`CA<nn>-<persona>-<action>-<condition>`

**Example**

`CA01-AllUsers-RequireMFA-AnyApp`

Numbering is reserved by persona family to leave room for future growth. For example, CA01 to CA09 is reserved for global policies, CA10 to CA19 for administrator policies, and CA20 to CA29 for workforce policies. The complete numbering strategy is documented in the Sprint 3 Persona Architecture document.

## Architecture decisions

Architecture decisions use the pattern `AD-###`. Numbers are assigned sequentially, never reused, and recorded in the Project Bible with the decision, rationale, and date.

Current register: `AD-001` through `AD-004`.

## Repository artifacts

| Artifact | Convention | Example |
|---|---|---|
| Screenshots | `NN-description-in-hyphens.png`, indexed in `screenshots/README.md` when captured | `11-bg-signin-detail-passkey.png` |
| Scripts | `verb-noun-purpose.ps1` | `set-breakglass-password-policy.ps1` |
| Commit messages | `Sprint N: what changed` | `Sprint 1: repository scaffold` |
| Documentation | Lowercase filenames with hyphens and the `.md` extension | `break-glass-runbook.md` |

## Rules

1. Use lowercase letters and hyphens in every filename. Do not use spaces or timestamps as filenames.
2. Every prefix has a defined purpose. Never reuse a prefix for a different object type.
3. Any object that does not follow one of the documented naming patterns must either be documented here or renamed.
