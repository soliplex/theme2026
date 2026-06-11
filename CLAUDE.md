# Theme Template

AI chat application built on [soliplex_frontend](https://github.com/soliplex/frontend).

## Quick Reference

Use Dart MCP server tools instead of shell commands:

- **Run tests:** `mcp__dart__run_tests` (must pass)
- **Analyze:** `mcp__dart__analyze_files` (must be 0 issues)
- **Format:** `mcp__dart__dart_format`
- **Install deps:** `mcp__dart__pub` with command `get`
- **Run app:** `mcp__dart__launch_app` with device from `mcp__dart__list_devices`
- **Lint markdown:** `npx markdownlint-cli "**/*.md"` (shell command)

## Project Structure

```text
lib/
├── main.dart                # Entry point (calls runSoliplexShell)
├── classifications.dart     # Example sensitivity markings
└── consent_notice.dart      # Example consent banner

assets/branding/theme_template/  # App icons and branding
docs/                            # Setup documentation
```

This app is a thin wrapper around `soliplex_frontend`. All core functionality
(chat, history, settings, etc.) comes from the library.

## Architecture

**Customization Points:**

- `standard()` in main.dart - App name and configuration
- `assets/branding/theme_template/` - Custom icons and branding
- Platform configs - Bundle IDs, entitlements, signing

**For core functionality changes**, modify the soliplex_frontend library instead.

## Development Rules

- KISS, YAGNI, SOLID - simple solutions over clever ones
- Edit existing files; don't create new ones without need
- Match surrounding code style exactly
- Fix broken things immediately when found

## Code Quality

**After any code modification, run these checks:**

1. **Format:** `mcp__dart__dart_format` (formats files in place)
2. **Analyze:** `mcp__dart__analyze_files` (must be 0 issues)
3. **Test:** `mcp__dart__run_tests` (must pass)

Warnings indicate real bugs. Fix all errors, warnings, AND hints immediately.

**Never use `// ignore:` directives.** Restructure code to eliminate the warning.

## Configuration

- `pubspec.yaml` - Dependencies (soliplex_frontend from git)
- `docs/app-setup.md` - Platform-specific setup instructions

## Critical Rules

1. Run `mcp__dart__dart_format` then verify with
   `dart format --set-exit-if-changed .`
2. `mcp__dart__analyze_files` MUST report 0 errors AND 0 warnings
3. `mcp__dart__run_tests` must pass before changes are complete
4. Keep dependencies up to date: check `pubspec.yaml` against <https://pub.dev>
5. After editing any `.md` file, run `npx markdownlint-cli <file>` and fix all errors
