EntraGuard - Enterprise Identity Security and Governance Lab
Meridian Financial Group

Status: Build and validation complete. Enforcement cutover is the final gated step.

---

## Introduction

This sprint replaces the tenant's blunt, one-size-fits-all protection with a Conditional Access persona architecture and phishing-resistant authentication. It moves Meridian from Security Defaults toward a designed access model where protection scales with privilege.

Everything here was built in report-only mode first, validated against real sign-in data, and staged for a controlled cutover to enforcement. The cutover itself is the sprint's closing step and is documented as a ready-to-execute procedure.

## Business Scenario

Meridian Financial Group is a regulated financial-services firm. Before this sprint, every identity in the tenant carried the same protection, whether a trader, a contractor, or a Global Administrator. That posture cannot be defended to an auditor, and it violates least privilege.

A regulated firm needs protection that maps to risk. A Global Administrator and a marketing coordinator should not authenticate under identical rules. This sprint builds that differentiation using Conditional Access personas, and it makes phishing-resistant authentication mandatory for the accounts that matter most.

The compliance drivers are concrete. SOX requires access controls and segregation of duties around financial reporting systems. GLBA requires protection of customer financial data. Both point to the same conclusion: authentication strength and access conditions must be deliberate, documented, and auditable.

## Objectives

| # | Objective | Status |
|---|-----------|--------|
| 1 | Configure the authentication methods policy for phishing-resistant and passwordless methods | Complete |
| 2 | Confirm workforce MFA registration state before any enforcement | Complete |
| 3 | Build the Conditional Access persona architecture in report-only | Complete |
| 4 | Build named locations for trusted and high-risk signals | Complete |
| 5 | Validate report-only behavior against real sign-in data | Complete |
| 6 | Execute controlled cutover to enforcement | Gated final step |

## Certification Mapping

| Exam | Domain |
|------|--------|
| SC-300 | Plan and implement Conditional Access |
| SC-300 | Implement authentication methods |
| AZ-500 | Manage Microsoft Entra identity and access |
| SC-200 | Sign-in and audit log analysis feeding detection |

## Technologies Used

Microsoft Entra ID, Conditional Access, authentication methods policy, named locations, Temporary Access Pass, FIDO2 passkeys, Microsoft Authenticator, report-only mode, sign-in logs.

## Architecture

### Conditional Access persona board

The naming convention encodes persona, scope, and control in each policy name, and reserves numbering blocks so the board stays legible as it grows.

| Block | Range | Purpose |
|-------|-------|---------|
| Global | CA01 to CA09 | Policies targeting all users |
| Admins | CA10 to CA19 | Policies targeting privileged personas |

### Policies built this sprint

| Policy | Scope | Control | State |
|--------|-------|---------|-------|
| CA01-AllUsers-BlockLegacyAuth | All users | Block legacy authentication | Report-only |
| CA02-AllUsers-RequireMFA-AnyApp | All users | Require MFA | Report-only |
| CA03-AllUsers-RequireMFARegistration-AnyContext | All users | Require MFA registration | Report-only |
| CA04-AllUsers-MFA-AzureManagement | All users | Require MFA for Azure management | Report-only |
| CA10-Admins-PhishingResistantMFA | Admins | Require phishing-resistant MFA | Report-only |

All policies exclude the break-glass group. That exclusion is non-negotiable and is the primary defense against locking every administrator out of the tenant at cutover.

### Named locations

| Location | Type | Trusted | Purpose |
|----------|------|---------|---------|
| Meridian-Chicago-Office | IP ranges | Yes | Positive signal for known-good sign-ins |
| Meridian-HighRisk-Countries | Countries (IP) | No | Negative signal, feeds a future block policy |

Neither location is referenced by a policy yet. They are components staged for use once report-only analysis confirms the baseline.

## Step-by-Step Implementation

### 1. Authentication methods policy

The tenant defaults were already strong: Passkey (FIDO2), Microsoft Authenticator, and Temporary Access Pass enabled; SMS and Voice call disabled. Number matching was confirmed enabled on Authenticator to defeat MFA fatigue attacks.

**Why phishing-resistant methods matter.** SMS and voice MFA are defeated by SIM swap and real-time phishing proxies that relay the one-time code in seconds. FIDO2 defeats this structurally, because the credential is cryptographically bound to the origin and a proxy domain cannot satisfy the challenge. This is the strongest single control in the sprint.

Open item carried forward: Email OTP remains enabled and should be disabled. Email is not a valid second factor when the mailbox is itself the asset being protected.

### 2. Confirm registration state before enforcement

The User registration details report was captured as the pre-enforcement baseline. Result: three accounts MFA-capable (the primary admin and two break-glass accounts), and all 25 workforce users Not-Capable across every method column.

This finding drove the sprint sequence. A policy requiring MFA would lock out the entire workforce the moment it enforced, because no workforce user has a second factor to satisfy the grant. Registration must come before enforcement.

The break-glass accounts registered device-bound passkeys in Microsoft Authenticator, not separate hardware security keys. This is logged as a known limitation with a hardware-key upgrade noted as a future enhancement.

A dormant guest-format account carrying zero authentication methods was flagged during this review and logged for access review in a later sprint.

### 3. Build the persona board in report-only

Each policy was created in report-only, which evaluates every sign-in and records the verdict without enforcing it. This is what makes a safe cutover possible: you see exactly what a policy would do before it does it.

The registration policy (CA03) is the enforcement on-ramp. It targets the "Register security information" user action rather than a cloud app. Users with no method are pushed into combined registration, so that enforcement policies have something to check against.

A numbering correction was made and documented. A policy targeting all users had been created in the admin block. It was renamed from CA11 to CA04 to sit in the correct global range. Renaming a Conditional Access policy changes the display name only, not its behavior.

### 4. Named locations

Two named locations were built. The Chicago office uses a trusted IP range. Because this is a lab with no real office egress, the range uses an RFC 5737 documentation block and is clearly labeled as simulated, so no reader mistakes it for live infrastructure.

The high-risk countries location uses IP-based country resolution, with "include unknown countries" left unchecked to avoid sweeping unresolved IPs into a block. The country set follows a defensible "no business presence" logic rather than any editorial judgement.

## Validation

The core validation was a paired report-only test that produced a genuine finding.

**Test 1: Tom Gallagher, front-office persona, signed in with a Temporary Access Pass.**

CA02 (Require MFA) returned a verdict of Success. This was unexpected until diagnosed: Entra treats a Temporary Access Pass as a strong method that satisfies an MFA requirement. So the TAP masked the very enforcement gap the test was meant to reveal.

**Test 2: David Okonkwo, advisory persona, signed in with password only.**

CA02 returned "User action required." This is the enforcement-gap proof. At real cutover, a password-only user with no registered method would be interrupted and required to complete MFA they cannot yet do, and would be blocked.

The contrast between the two tests is the sprint's headline result:

| User | Credential used | CA02 report-only verdict |
|------|-----------------|--------------------------|
| Tom Gallagher | Temporary Access Pass | Success |
| David Okonkwo | Password only | User action required |

Same policy, opposite verdicts, driven entirely by credential class.

Security Defaults was confirmed Disabled on the tenant Properties page. This clears the mutual-exclusivity blocker for cutover, and it also means the tenant currently has no active MFA enforcement, since all policies remain in report-only. That unprotected window is itself the argument for proceeding to enforcement.

## Lessons Learned

**A Temporary Access Pass satisfies MFA and will mask an enforcement gap.** Report-only testing with a TAP flatters the result. Enforcement policies must be validated using the same credential class the target population actually uses. Testing with a TAP a population that will sign in with passwords produces misleading Success verdicts. This was caught by re-running the test password-only, and the two verdicts side by side became the strongest evidence in the sprint.

**Diagnose from evidence, not assumption.** A registration prompt seen during testing was first attributed to Security Defaults. Confirming Security Defaults was disabled ruled that out and pointed to the auth methods policy and CA report-only evaluation as the real drivers. The correction is kept in the record because reasoning from evidence, including revising a wrong first read, is the actual skill.

**Registration must precede enforcement.** With all 25 workforce users Not-Capable, enforcing MFA before a registration path exists would lock out the entire workforce. The registration policy exists precisely to prevent this, and it must soak before enforcement.

**Break-glass exclusions are the safety net.** Every policy excludes the break-glass group. This is the single control preventing a full administrative lockout at cutover.

## Enterprise Best Practices

- Build every Conditional Access policy in report-only, validate against real sign-in data, then cut over deliberately.
- Keep a break-glass session open in a separate browser during any enforcement change.
- Use a naming convention that encodes persona, scope, and control, with reserved numbering blocks.
- Prefer phishing-resistant methods (FIDO2) for privileged accounts, and pair location signals with MFA rather than relying on location alone.
- Label all simulated infrastructure clearly so documentation cannot be mistaken for a live environment.

## Cutover Procedure (ready to execute)

This is the sprint's final step, staged and not yet run.

1. Disable Email OTP in the authentication methods policy.
2. Open a separate browser signed in as a break-glass account. Keep it open throughout.
3. Confirm the break-glass exclusion on all five policies one more time.
4. Ensure a registration path exists for the workforce before enforcing MFA, so Not-Capable users are not locked out.
5. Flip policies from report-only to On in a deliberate order, verifying access after each.
6. Confirm the break-glass account is unaffected.
7. Capture post-cutover verdicts and screenshots.

## Screenshots

| File | Shows |
|------|-------|
| 27-auth-methods-registration-details-before.png | Pre-enforcement registration baseline, workforce Not-Capable |
| 29-ca04-renamed-from-ca11.png | Numbering correction, CA11 renamed to CA04 |
| 30-ca03-registration-target-useraction.png | CA03 targeting the Register security information user action |
| 31-ca03-report-only-created.png | Full five-policy board in report-only |
| 32-named-location-chicago-trusted.png | Chicago trusted IP range |
| 33-named-location-highrisk-countries.png | High-risk countries location |
| 35-signin-report-only-verdicts-tom.png | Tom, TAP sign-in, CA02 Success |
| 36-signin-report-only-useraction-david-passwordonly.png | David, password-only, CA02 User action required |

## Conclusion

Sprint 3 moved Meridian from undifferentiated protection to a designed persona architecture, built and validated entirely in report-only. The paired report-only test proved the enforcement gap with evidence and surfaced a subtle, real lesson about how a Temporary Access Pass masks that gap. The board is staged, break-glass exclusions are in place, and Security Defaults is cleared. Enforcement day is the final step.
