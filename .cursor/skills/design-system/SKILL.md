---
name: design-system
description: >-
  Apply Brain Rush design tokens and ThemeData. Use when editing Flutter UI,
  colors, typography, spacing, radius, shadows, ThemeData, AppColors, screens,
  or widgets in this repo.
---

# Design System

Read `lib/theme/app_colors.dart` before adding or changing colors. Reuse those tokens. Do not invent a new palette.

## Current tokens

`AppColors` in `lib/theme/app_colors.dart`:

- Brand: `bgBlue` `0xFF0B3D91`, `bgBlueDeep` `0xFF072E6E`, `bgBlueLight` `0xFF0D6EFE`, `yellow` `0xFFFFC107`, `cardBg` `0xFF0A2F70`, `borderGray` `0xFFBEBEBE`, `bgLight` `Color.fromARGB(255, 245, 249, 249)`
- Menu gradients: `yellowGradient`, `greenGradient`, `blueGradient`, `purpleGradient`
- Icon gradients: `redIconGradient`, `yellowIconGradient`, `blueIconGradient`, `purpleIconGradient`, `greenIconGradient`

Font: `NunitoSans` only. Declared weights are 400, 500, 600, 700. Do not use `FontWeight.w800` or `w900` on new text. The logo painter in `lib/widgets/brain_rush_title.dart` already uses `w900`; do not copy that into UI text.

Material 3 stays on. There is no typography file, spacing file, or shadow file yet.

## ThemeData

`lib/main.dart` seeds `ColorScheme` from `AppColors.bgBlue`, with `primary` blue and `secondary` yellow. Do not switch it back to `Colors.teal`.

When touching `ThemeData` or a screen that uses `Theme.of(context)` / `FilledButton` / `SnackBar`:

- Seed or explicit scheme from `AppColors.bgBlue` and `AppColors.yellow`, not `Colors.teal`.
- Keep `fontFamily: 'NunitoSans'`.
- Keep `useMaterial3: true`.
- Do not add a theme package.

## Rules

- New hex values go in `lib/theme/`, not in screens or widgets.
- Import `AppColors` instead of copying `0xFF0B3D91`, `0xFF072E6E`, `0xFFFFC107`, or `0xFF0A2F70`.
- Borders use `AppColors.borderGray`. Do not introduce `0xFFBFBFBF` (`MenuRow` has this off-by-one gray).
- Game background `0xFFF5F6FA` and `AppColors.bgLight` are not the same. Pick `bgLight` unless a task explicitly needs a different surface.
- Option colors in `lib/screens/game_screen.dart` (`0xFF1976D2`, `0xFF43A047`, `0xFFFDD835`, `0xFF8E24AA`) are not tokens. If you restyle answers, move those colors into `AppColors` first, then reference them.
- Do not add semantic colors that the screens do not use yet, except `correct` / `incorrect` / timer-warning when implementing answer or timer feedback. Derive them from existing greens, reds, and `yellow` rather than a new brand.

## Spacing, radius, shadow

Do not create a token class for a value used once. When a value is copied to a second widget, add it under `lib/theme/` and use the token.

Values already repeated, so they are the token scale if you add files:

- Space: 4, 8, 12, 16, 20, 24. Do not copy the home `top: 1` inset.
- Radius: 12 answers, 16 question card, 20 menu and loading bar, 100 player chip. Progress bar 8 can stay local.
- Shadow, menu and player chip: `Color(0x66000000)`, offset `(2, 4)`, blur `10`.
- Shadow, game card and answers: `Color(0x22000000)`, offset `(0, 2)` or `(0, 3)`, blur `4` or `8`.

Name those two shadows if you extract them. Do not invent a third shadow style.

## Text

There is no `TextTheme` customization. When adding text roles, map only sizes already on screen:

- 13–14 caption, 16–17 body, 20 button/row title, 23 screen title, 28 question prompt.

Logo sizes 48 and 52 belong to `BrainRushTitle`, not to a text role.

## Do not

- Add `google_fonts`, a design-token package, or a second font.
- Restyle `BrainRushTitle` or menu gradients as part of a token cleanup.
- Recolor every screen in one pass unless the user asked for a visual pass. Fix the file you are editing, plus `ThemeData` if widgets inherit Material colors.
