---
name: dev-env
description: >
  REQUIRED for managing personal dotfiles and development environment configuration.
  Use when editing configs like nvim, bashrc, hyprland, git config, terminal configs, or any dotfiles.
  Instead of editing ~/.config/* directly, edit the source in the dev-env repository.
  Triggers: dotfiles, config, nvim, bashrc, zshrc, gitconfig, environment, shell config, hyprland, dev-env, renewal.
  IMPORTANT: AI MUST NEVER directly modify ANY files. AI must only provide instructions and guidance to the user.
---

# Dev Environment Repository Skill

Manage dev environment configs through the dev-env repository.

**⚠️ CRITICAL RULE: AI MUST NEVER DIRECTLY MODIFY ANY FILES IN THIS SYSTEM. ⚠️**

**AI's role is INSTRUCTIONS-ONLY. The user applies all changes.**

The dev-env repo is the source of truth. All configurations are managed through this repository and deployed via renewal scripts.

## How the System Works

The dev-env repo uses a deployment workflow:

1. **Source of truth** — Configs live in this repository under `dev-env/config/` and `dev-env/scripts/`
2. **Renewal scripts** — Each service has a `dev-env-renew-<service>` script that copies/deploys configs to `~/.config/`
3. **Deploy changes** — User runs `dev-env update` or the specific renewal script to apply changes to the system

```
dev-env repo (source) → renewal script → ~/.config/* (deployed)
```

## AI Behavior Rules

**WHEN FILE MODIFICATION IS REQUESTED:**

1. **IMMEDIATELY** — Read the entire dev-env repository to understand the full context and structure
2. **NEVER EDIT DIRECTLY** — Do NOT use any tool to modify files in dev-env/config/, dev-env/scripts/, or ~/.config/*
3. **ALWAYS PROVIDE INSTRUCTIONS** — Give the user:
   - Exact file path (relative to the repository root)
   - Current content (if helpful for context)
   - Exact changes needed (show old and new)
   - Why this change is needed
   - Deployment command(s) to apply it: `dev-env-renew-<service>` or `dev-env update`
4. **WAIT FOR USER** — The user applies all changes. AI does not touch the filesystem for edits.

**EXCEPTION:** AI CAN read files to understand the current state and provide context. Reading is always safe.

## When This Skill MUST Be Used

**ALWAYS use this skill when ANY changes are needed to:**

- Neovim/Vim configuration
- Hyprland configuration (keybinds, monitors, window rules)
- Shell configuration (bashrc, zshrc)
- Git configuration
- Terminal configs (alacritty, foot, kitty, ghostty)
- Any other dotfiles or hidden configuration files

**Personal dotfiles like `~/.config/nvim/*`, `~/.bashrc`, `~/.gitconfig` are GENERATED from this repo.**

**When this skill is triggered, AI MUST read the entire dev-env repository before responding to ensure full understanding of the current state and structure.**

## The Workflow (AI's Role)

When a user requests a change to config files:

1. **STOP AND READ THE REPO** — Before responding, read the entire dev-env repository to understand the full context, current structure, and what files need to be changed

2. **ANALYZE** — Determine:
   - Which source file in the repo needs modification (not the deployed copy)
   - The exact location and what needs to change
   - Which renewal script will deploy this change

3. **PROVIDE INSTRUCTIONS ONLY** — Show the user:
   ```
   File location in repo: dev-env/config/nvim/lua/plugins/example.lua
   
   Current content: [show excerpt]
   
   Change needed:
   [old]
   →
   [new]
   
   Reason: [explain why]
   
   To apply: Run `dev-env-renew-nvim` or `dev-env update`
   ```

4. **WAIT** — The user edits the file and applies the deployment command. AI does nothing more.

**ABSOLUTELY NO DIRECT FILE EDITS. AI PROVIDES INSTRUCTIONS ONLY.**

## Repository Structure

```
dev-env/
├── config/
│   ├── nvim/              # Neovim config (deployed to ~/.config/nvim/)
│   ├── initcpio/          # Arch Linux initramfs config
│   └── [other configs]/
├── scripts/
│   ├── dev-env-renew-nvim          # Deploy nvim config
│   ├── dev-env-renew-hypr          # Deploy hyprland config
│   ├── dev-env-update-configs      # Deploy all configs
│   ├── hyprland.lua                # Hyprland keybinds (deployed by renewal script)
│   └── [other renewal scripts]/
└── [installation & management scripts]/
```

## Adding New Configs

To extend the system with a new service:

1. Create `dev-env/config/<service>/` with your config files
2. Create `dev-env/scripts/dev-env-renew-<service>` with deployment logic
3. Make it executable: `chmod +x dev-env/scripts/dev-env-renew-<service>`
4. The renewal script will be called by `dev-env update`

Use `$PATH_DEV_ENV` environment variable in scripts for repo path.

## Example: Editing Nvim Config

**Scenario:** Add a new plugin to nvim config

1. **Edit the source:** `dev-env/config/nvim/lua/plugins/[plugin-file].lua`
2. **Test changes** (optional: verify syntax)
3. **Deploy:** User runs `dev-env-renew-nvim` or `dev-env update`
4. **Result:** `~/.config/nvim/` is updated with the new plugin

## Example: Editing Hyprland Keybinds

**Scenario:** Add a new keybind

1. **Edit the source:** `dev-env/scripts/hyprland.lua`
2. **Deploy:** User runs `dev-env-renew-hypr` or `dev-env update`
3. **Result:** `~/.config/hypr/dev-env_hypr.lua` is updated and `hyprctl reload` is run

## Why This Workflow

This approach ensures:
- **Consistency** — one source of truth for all environments
- **Reproducibility** — same configs on all systems
- **Version control** — all changes tracked in git
- **Safety** — can revert any change with git
- **Extensibility** — easy to add new services

## Out of Scope

This skill does NOT allow AI to:
- Directly edit any files in the dev-env repository
- Directly edit any files in `~/.config/` or any dotfiles
- Use the edit, create, or file-modifying tools in any way
- Bypass the instruction-only model

This skill DOES allow AI to:
- Read and inspect all files to understand the configuration
- Provide detailed instructions and guidance to the user
- Explain the reasoning behind changes
- Suggest deployment commands
- Answer questions about the dev-env structure

## Deployment Commands

```bash
# Deploy all configs
dev-env update

# Deploy a specific service
dev-env-renew-nvim
dev-env-renew-hypr

# Add to shell config (aliases, paths, custom lines)
dev-env add alias
dev-env add path
dev-env add custom
```
