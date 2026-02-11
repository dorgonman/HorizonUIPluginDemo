# AGENTS.md — HorizonUIPluginDemo

Unreal Engine 5.7 plugin demo project. Build/test via `Build/Script/` local overrides and `Build/Base/Script/` shared scripts.

## Quick Start

From repo root (Git Bash on Windows):
```sh
./git_submodule_update.sh
./git_checkout_main.sh
```

## Build Commands

**ALL shell scripts MUST be run via pixi.** This ensures consistent toolchain versions (pixi-managed environments) regardless of the developer's local setup.

```sh
cd Build/Base
pixi run <task>
# Example: UNREAL_ENGINE_ROOT="D:/_work/UnrealEngine" pixi run editor-dev
```

**Pixi configuration location:** `Build/Base/pixi.toml`

**Available engines:**
- Installed (Launcher) engine: auto-detected
- Source engine: `D:/_work/UnrealEngine` (set `UNREAL_ENGINE_ROOT` env var)

**Key tasks:**
- `editor-dev` — Editor development build
- `standalone-dev` — Standalone game development build
- `plugin-ship` — Plugin shipping build
- `server-dev` — Server development build (NOTE: not applicable for plugin demo projects - no server target exists)

**Source Engine Location:** `D:/_work/UnrealEngine` (set via `UNREAL_ENGINE_ROOT` env var)

## Test Commands

**Run full test suite:**
```sh
./Build/Base/Script/platform/win64/editor/gauntlet/test_no_coverage.sh
```

**Run single automation test:**
```sh
export EXTRA_PARAMETERS='-ExecCmds="Automation RunTests Plugin.SmokeTest.HorizonUI.Success; Quit"'
AUTOMATION_TEST_FILTER='Plugin.SmokeTest.HorizonUI.Success' ./Build/Base/Script/platform/win64/editor/gauntlet/test_no_coverage.sh
```

Available tests:
- `Plugin.SmokeTest.HorizonUI.Success` (Plugins/HorizonUIPlugin/Source/HorizonUI/Private/Test/SmokeTests.cpp)
- `Plugin.UnitTests.HorizonUI` (Plugins/HorizonUIPlugin/Source/HorizonUI/Private/Test/ProductTests.cpp)

## Code Style & Conventions

### Naming (Unreal Standard)
- `U` prefix: UObject-derived classes
- `A` prefix: AActor-derived classes
- `S` prefix: Slate widgets
- `F` prefix: structs
- `E` prefix: enums
- `T` prefix: template types
- `b` prefix: bool variables (e.g., `bIsEnabled`)

### Includes & Headers
- Use `#pragma once` in all headers
- Include generated header **last**: `#include "<File>.generated.h"`
- In `.cpp`: include matching header first, then local module headers, then engine headers
- Prefer forward declarations in headers

### Types & Ownership
- Prefer Unreal types: `int32`, `uint8`, `float`, `FString`, `FName`, `FText`, `FVector2D`
- Use UE containers: `TArray`, `TMap`, `TOptional`
- For UObjects:
  - `TObjectPtr<T>` for owning UPROPERTY references (UE5)
  - `TWeakObjectPtr<T>` for weak references
  - `TSoftObjectPtr<T>` for soft asset references

### Error Handling & Logging
- Use UE assertion macros: `check`, `checkf` (fatal), `ensure`, `ensureMsgf` (non-fatal)
- Plugin logging category: `LogHorizonUI`
- Convenience macros in `HorizonUIPrivate.h`:
  - `UE_HORIZONUI_FATAL/ERROR/WARNING/DISPLAY/LOG/VERBOSE/VERY_VERBOSE`
- For editor warnings: `FMessageLog("HorizonUI")`

### Performance Instrumentation
Use scoped profiling from `HorizonUIPrivate.h`:
```cpp
DECLARE_HORIZONUI_QUICK_SCOPE_CYCLE_COUNTER(ClassName, FunctionName)
```

### Threading & Constructor Safety
- Avoid constructor-time asset loading
- UWidget construction can happen off-game-thread in UE5
- Defer asset loads to safe runtime points (e.g., NativeConstruct, NativeOnInitialized)

### Formatting
- **Indentation:** 4 spaces (UTF-8, max line 120 chars)
- **YAML files:** 2 spaces
- See `.editorconfig` for baseline

## Module Structure

**HorizonUI (Runtime)**
- Location: `Plugins/HorizonUIPlugin/Source/HorizonUI/`
- Public headers: `Public/`
- Private implementation: `Private/`
- Logging/macros: `Private/HorizonUIPrivate.h`

**Key Components:**
- `HorizonFlipbookWidget`: PaperFlipbook support in UMG
- `HorizonDialogueMsgTextBlock`: Rich text + dialogue text widget
- `HorizonTileView`: Enhanced tile view widget
- Decorators: Custom text decoration system

## Automation Tests

Tests are guarded by `WITH_DEV_AUTOMATION_TESTS`. When adding tests:
1. Follow existing pattern in `Plugins/HorizonUIPlugin/Source/HorizonUI/Private/Test/*.cpp`
2. Use `FAutomationTestBase` or `FSimpleAutomationTestBase`
3. Register with `IMPLEMENT_SIMPLE_AUTOMATION_TEST` macro
4. Name format: `Plugin.Category.PluginName.TestName`

## Work Item / Backlog System

All work items use the **Kano Agent Backlog Skill** (`kob` CLI). When you say "開工項" (start a work item), you mean using this system.

**Backlog location (shared):** `~/.agents/skills/kano/_kano/backlog/products/HorizonUIPluginDemo/`

**Product config:** `.kano/backlog_config.toml`

### Daily Workflow

```sh
# 1. Sync sequences (after clone/pull)
kob admin sync-sequences --product HorizonUIPluginDemo

# 2. Create item
kob item create --type task --title "Description" --agent sisyphus --product HorizonUIPluginDemo

# 3. Fill Ready gate
kob workitem set-ready <item-id> \
  --context "..." --goal "..." --approach "..." \
  --acceptance-criteria "..." --risks "..." \
  --product HorizonUIPluginDemo

# 4. State transitions
kob workitem update-state <item-id> --state InProgress --product HorizonUIPluginDemo
kob workitem update-state <item-id> --state Done --product HorizonUIPluginDemo

# 5. Refresh dashboards
kob view refresh --agent sisyphus --product HorizonUIPluginDemo
```

### Item Types
- `task` — single focused implementation
- `bug` — defect/regression (link to original item)
- `feature` — new capability
- `epic` — multi-release milestone
- `userstory` — single user-facing outcome

### ID Format
`HR-<TYPE>-<NUMBER>` (e.g., `HR-TSK-0001`)

### Validation
```sh
kob validate uids --product HorizonUIPluginDemo
```

## CI/CD

- Azure Pipelines: `.azure-pipelines/`
- Uses EpicGames templates
- UAT invoked via `RunUAT.*` in `ue_ci_scripts/function/sh/public/ue_build_function.sh`

## Important Notes

- Prefer `Build/Script/` overrides first, then `Build/Base/Script/` shared scripts
- Shared scripts contain MSYS/Git-Bash conditionals (`OSTYPE == msys`)
- On Windows, run scripts from **Git Bash**
- No dedicated lint command; use IDE tooling for formatting
- No Cursor/Copilot rules found (`.cursorrules`, `.github/copilot-instructions.md`)

## Useful Paths

- Plugin descriptor: `Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin`
- Private headers: `Plugins/HorizonUIPlugin/Source/HorizonUI/Private/HorizonUIPrivate.h`
- Tests: `Plugins/HorizonUIPlugin/Source/HorizonUI/Private/`
- Build scripts: `horizon_ci_scripts/job/sh/win64/`
- CI config: `.azure-pipelines/`
