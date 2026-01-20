# AI Instructions

A centralized instruction management system for AI coding assistants (Claude Code, GitHub Copilot, Cursor, etc.).

## Why?

AI coding assistants work better when they understand your codebase, conventions, and tools. But maintaining instructions across multiple projects is painful:

- **Copy-paste hell** - Same instructions duplicated everywhere
- **Drift** - Updates in one project don't propagate to others
- **Inconsistency** - Different projects have different (outdated) instructions

**AI Instructions** solves this with a central library of instructions that are symlinked into each project. Update once, apply everywhere.

## How It Works

```
~/projects/
├── .ai-instructions/           # Central library (this gets set up)
│   ├── core/                   # Always loaded
│   │   └── coding-standards.md
│   ├── domains/                # Domain-specific knowledge
│   │   ├── web/
│   │   │   └── react-patterns.md
│   │   └── backend/
│   │       └── api-conventions.md
│   └── tools/                  # Tool-specific instructions
│       ├── docker.md
│       └── terraform.md
│
├── project-a/
│   └── .github/instructions/   # Symlinks to central library
│       ├── coding-standards.md → ../../.ai-instructions/core/...
│       └── react-patterns.md   → ../../.ai-instructions/domains/web/...
│
└── project-b/
    └── .github/instructions/
        └── ...
```

Both **Claude Code** and **GitHub Copilot** automatically read all `.md` files in `.github/instructions/`. By using symlinks, all your projects share the same instructions from one source of truth.

## Quick Start

### 1. Install

```bash
# Clone the repository
git clone https://github.com/piertwo/ai-instructions.git
cd ai-instructions

# Run setup (creates ~/.ai-instructions and adds instr to PATH)
./setup.sh
```

### 2. Create Your First Instruction

```bash
# Create a coding standards file
cat > ~/.ai-instructions/core/coding-standards.md << 'EOF'
# Coding Standards

## General Rules
- Use meaningful variable names
- Keep functions under 50 lines
- Write tests for new functionality

## Git Commits
- Use conventional commits: feat, fix, docs, refactor, test, chore
- Keep commits atomic and focused
EOF
```

### 3. Add Instructions to a Project

```bash
cd ~/projects/my-project

# Sync default instructions (creates .github/instructions/ with symlinks)
instr sync .

# Or use the interactive picker
instr pick
```

## The `instr` Command

### Core Commands

```bash
instr list                      # List all available instructions
instr show [project]            # Show what's loaded in a project
instr sync [project|--all]      # Sync symlinks to central library
instr pick [project]            # Interactive picker - select by number
```

### Adding & Removing

```bash
instr add . domain:web          # Add all files from domains/web/
instr add . tool:docker         # Add tools/docker.md
instr add . core:coding-standards  # Add specific core file
instr remove . docker.md        # Remove an instruction
```

### Advanced

```bash
instr upload file.md web        # Move local file to domain, symlink everywhere
instr audit                     # Find local files that could be centralized
instr check --all               # Check for broken symlinks
```

## Project Categories

Define categories to automatically load the right instructions for different project types:

Edit `~/.ai-instructions/config.yaml`:

```yaml
categories:
  web:
    domains: [web]
    tools: [docker, npm]

  backend:
    domains: [backend, database]
    tools: [docker, terraform]

  mobile:
    domains: [mobile, api]
    tools: [fastlane]

# Map directories to categories
routing:
  "*/frontend/*": web
  "*/backend/*": backend
  "*/mobile/*": mobile
```

Then `instr sync` automatically loads the right instructions based on project location.

## Directory Structure

### Core (`core/`)
Instructions that apply to **all** projects. Things like:
- Coding standards
- Git workflow
- Documentation conventions

### Domains (`domains/`)
Knowledge specific to a technology or problem domain:
- `domains/web/` - React, CSS, accessibility
- `domains/backend/` - API design, database patterns
- `domains/devops/` - CI/CD, monitoring

### Tools (`tools/`)
Instructions for specific tools:
- `tools/docker.md` - Docker best practices
- `tools/terraform.md` - Terraform conventions
- `tools/kubernetes.md` - K8s patterns

## Writing Good Instructions

### Keep It Actionable

```markdown
# Bad
Docker is a containerization platform that...

# Good
## Docker Commands

Build and run:
```bash
docker build -t myapp .
docker run -p 8080:8080 myapp
```
```

### Be Specific

```markdown
# Bad
Use good naming conventions

# Good
## Naming Conventions

- **Components**: PascalCase (`UserProfile.tsx`)
- **Hooks**: camelCase with `use` prefix (`useAuth.ts`)
- **Utils**: camelCase (`formatDate.ts`)
- **Constants**: SCREAMING_SNAKE_CASE (`API_BASE_URL`)
```

### Include Examples

```markdown
## API Error Handling

Always return structured errors:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "field": "email"
  }
}
```
```

## Migrating Existing Instructions

If you have instructions scattered across projects:

```bash
# Find all instruction files
find ~/projects -path "*/.github/instructions/*.md" -type f

# Use instr audit to identify candidates for centralization
instr audit

# Upload a local file to the central library
cd ~/projects/some-project
instr upload .github/instructions/my-standards.md core
```

## Integration with AI Tools

### Claude Code
Claude Code automatically reads all `.md` files in `.github/instructions/`. No additional configuration needed.

### GitHub Copilot
Copilot Chat reads `.github/instructions/` in VS Code. The symlinks work seamlessly.

### Cursor
Cursor respects `.cursorrules` but also reads instruction files. You can symlink your standards there too.

## Tips

### 1. Start Small
Begin with 2-3 core instruction files. Add more as patterns emerge.

### 2. Keep Instructions Fresh
Review and update instructions quarterly. Remove outdated content.

### 3. Make It Team-Wide
For teams, put the central library in a shared location or sync via git.

### 4. Use Front Matter
Copilot supports `applyTo` front matter to scope instructions:

```markdown
---
applyTo: "**/*.tsx"
---

# React Component Guidelines
...
```

## Troubleshooting

### Symlinks not working?
```bash
instr check .        # Check for broken symlinks
instr sync .         # Recreate symlinks
```

### Instructions not loading?
- Ensure files have `.md` extension
- Check the file is in `.github/instructions/`
- Restart your AI tool after adding new instructions

### Command not found?
```bash
source ~/.bashrc     # Reload shell config
# Or add to PATH manually:
export PATH="$HOME/.ai-instructions/bin:$PATH"
```

## License

MIT License - Use freely, contribute back if you can.

---

Built with frustration at copy-pasting the same instructions into every project.
