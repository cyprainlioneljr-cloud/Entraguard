Sprint 3: Authentication and Access Foundations. Build and validation complete. Enforcement cutover is the only remaining step and is the first action of the next session.

## Architecture Decisions

- **AD (CA numbering correction):** A policy targeting all users (Azure management MFA) was created in the admin block as CA11. Renamed to CA04 to sit in the global range CA01-09. Rename changes display name only, not behavior. Global block now fills in creation order rather than planned order.
- **AD (registration before enforcement):** With all 25 workforce users MFA Not-Capable, an MFA enforcement policy would lock out the entire workforce at cutover. CA03 (require MFA registration, targeting the Register security information user action) built as the enforcement on-ramp. Must soak before enforcement.
- **AD (Chicago named location simulated):** Chicago-Office trusted IP range uses an RFC 5737 documentation block, not a real ISP egress. Flagged as simulated so no reader mistakes it for live infrastructure.
- **AD (high-risk countries logic):** HighRisk-Countries location scoped by no-business-presence logic, IP-based resolution, include-unknown-countries left unchecked. Not referenced by any policy yet.
- **AD (portfolio material deferred):** Resume accomplishments, STAR stories, LinkedIn drafts, and interview Q&A deferred to end-of-lab as one consolidated package rather than per-sprint. Sprint discoveries remain captured in each sprint doc's Lessons Learned.

## Policies (Conditional Access board)

All report-only.

| Policy | Scope | Control |
|--------|-------|---------|
| CA01-AllUsers-BlockLegacyAuth | All users | Block legacy auth |
| CA02-AllUsers-RequireMFA-AnyApp | All users | Require MFA |
| CA03-AllUsers-RequireMFARegistration-AnyContext | All users | Require MFA registration |
| CA04-AllUsers-MFA-AzureManagement | All users | Require MFA for Azure management |
| CA10-Admins-PhishingResistantMFA | Admins | Phishing-resistant MFA |

All exclude the break-glass group.

## Named Locations

| Location | Type | Trusted | Referenced by policy |
|----------|------|---------|----------------------|
| Meridian-Chicago-Office | IP ranges | Yes | No |
| Meridian-HighRisk-Countries | Countries (IP) | No | No |

## Lessons Learned

- **TAP masks the MFA enforcement gap.** A Temporary Access Pass satisfies an MFA requirement, so report-only testing with a TAP returns misleading Success verdicts. Validate enforcement policies with the credential class the target population actually uses. Confirmed by re-testing password-only (Tom = TAP = Success; David = password = User action required).
- **Diagnose from evidence.** A registration prompt was first attributed to Security Defaults; confirming Security Defaults was disabled ruled that out. The revised diagnosis pointed to the auth methods policy and CA report-only evaluation.

## Known Issues / Open Items

- Email OTP still enabled in the authentication methods policy. Disable at cutover.
- Dormant guest-format account with zero authentication methods flagged for access review in a later sprint.
- Break-glass accounts use device-bound passkeys in Authenticator, not separate hardware keys. Hardware-key pairing noted as a future enhancement.
- David Okonkwo left in a partial-registration state from the password-only test. Note before any re-test.
- Chicago isolated IP-range blade was not captured standalone; the both-locations list (screenshot 32) covers the requirement.

## Licensing / Trial Clock

Entra ID P2 trial expiry unchanged: 8/15/2026. Sprint 4 (PIM) must complete before expiry. Decision checkpoint 8/9/2026.

## Screenshots Added

Global sequential index continued: 27, 27a, 28, 29, 29b, 30, 31, 32, 33, 35, 36, 36a, 37. See `/screenshots/README.md`. Only screenshot 37 required masking (personal technical-contact email); all other visible addresses are fictional tenant UPNs.

## Next Session

1. Disable Email OTP.
2. Execute cutover: break-glass session open, confirm exclusions, flip report-only to On in deliberate order, verify after each.
3. Build the high-risk country block policy that consumes Meridian-HighRisk-Countries.
4. Close Sprint 3, open Sprint 4 (PIM).
