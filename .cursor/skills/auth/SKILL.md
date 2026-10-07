---
name: auth
description: >-
  Brain Rush login and account flows. Use when editing auth, login, sign up,
  Google, Facebook, email OTP, phone OTP, Firebase Auth, session, or Settings
  log out. Follow requirements.md in this folder before implementing.
---

# Auth

Read [requirements.md](requirements.md) before adding or changing login. That file is the product requirement. This skill only says where code should live.

## Where

- Firebase Auth is the session source of truth. Do not invent a second user table for passwords.
- Keep guest play: Splash → Home and games work without login. Do not force login after splash.
- Wire **Đăng xuất** on `SettingsScreen` to real sign-out when auth ships. Do not leave `comingSoon` for log out after that.
- Home player chip shows Firebase display name / photo when signed in; otherwise keep `l10n.playerName`.
- All new user-facing strings go in `app_en.arb` and `app_vi.arb`.
- UI follows `brain-rush-ui-ux` and `design-system`. Prefer branded screens over stock FirebaseUI unless skinned.

## Which sections

- Provider choice and packages: requirements §2.
- Guest vs required login: §3.
- Google / Facebook / email / phone flows: §4.
- Validation and OTP rules: §6–§8.
- Screens and navigation: §9.
- Out of scope and DoD: §11–§13.
- Firebase console steps: [SETUP.md](SETUP.md).
- Phase 1 phone = option B (OTP each sign-in). Password on phone sign-up is stored via `updatePassword` for later linking.
