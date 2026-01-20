#!/usr/bin/env bash
#
# AI Instructions - Setup Script
#
# Creates the central instruction library and adds the instr command to PATH.
#
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }

# Configuration
INSTALL_DIR="${AI_INSTRUCTIONS_DIR:-$HOME/.ai-instructions}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     AI Instructions - Setup            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if already installed
if [[ -d "$INSTALL_DIR" ]]; then
    warn "Directory already exists: $INSTALL_DIR"
    read -p "Overwrite? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Create directory structure
log "Creating directory structure..."
mkdir -p "$INSTALL_DIR"/{core,domains,tools,bin}
success "Created: $INSTALL_DIR"

# Copy the instr script
log "Installing instr command..."
cp "$SCRIPT_DIR/bin/instr" "$INSTALL_DIR/bin/instr"
chmod +x "$INSTALL_DIR/bin/instr"
success "Installed: instr"

# Create default config
log "Creating default configuration..."
cat > "$INSTALL_DIR/config.yaml" << 'EOF'
# AI Instructions Configuration
#
# Define categories and their default instruction sets.
# When you run `instr sync` in a project, it loads instructions
# based on the project's category.

# Category definitions
categories:
  # Default category (fallback)
  default:
    core: [coding-standards]
    domains: []
    tools: []

  # Web frontend projects
  web:
    core: [coding-standards]
    domains: [web]
    tools: [docker, npm]

  # Backend/API projects
  backend:
    core: [coding-standards]
    domains: [backend]
    tools: [docker]

  # Full-stack projects
  fullstack:
    core: [coding-standards]
    domains: [web, backend]
    tools: [docker]

  # Infrastructure projects
  infra:
    core: [coding-standards]
    domains: [devops]
    tools: [docker, terraform, kubernetes]

# Directory routing (optional)
# Maps path patterns to categories
routing:
  # "*/frontend/*": web
  # "*/backend/*": backend
  # "*/infra/*": infra
EOF
success "Created: config.yaml"

# Create example instruction files
log "Creating example instruction files..."

cat > "$INSTALL_DIR/core/coding-standards.md" << 'EOF'
# Coding Standards

## General Principles

- **Clarity over cleverness** - Write code that's easy to understand
- **Consistency** - Follow existing patterns in the codebase
- **Small functions** - Keep functions focused and under 50 lines
- **Meaningful names** - Variables and functions should describe their purpose

## Code Style

- Use the project's existing formatting (Prettier, Black, etc.)
- Add comments for complex logic, not obvious code
- Keep files under 300 lines when possible

## Git Workflow

### Commit Messages
Use conventional commits:
```
feat: Add user authentication
fix: Resolve login redirect issue
docs: Update API documentation
refactor: Extract validation logic
test: Add unit tests for auth service
chore: Update dependencies
```

### Branches
- `main` - Production-ready code
- `feature/*` - New features
- `fix/*` - Bug fixes
- `docs/*` - Documentation updates

## Code Review

Before submitting:
- [ ] Code compiles/runs without errors
- [ ] Tests pass
- [ ] No console.log/print statements left behind
- [ ] Complex logic is documented
EOF

cat > "$INSTALL_DIR/tools/docker.md" << 'EOF'
# Docker Instructions

## Building Images

```bash
# Build with tag
docker build -t myapp:latest .

# Build with build args
docker build --build-arg ENV=production -t myapp:prod .
```

## Running Containers

```bash
# Run with port mapping
docker run -p 8080:8080 myapp

# Run with environment variables
docker run -e DATABASE_URL=postgres://... myapp

# Run in background
docker run -d --name myapp myapp:latest
```

## Docker Compose

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Rebuild and restart
docker compose up -d --build

# Stop and remove
docker compose down
```

## Cleanup

```bash
# Remove unused images
docker image prune -a

# Remove all stopped containers
docker container prune

# Nuclear option - remove everything
docker system prune -a
```
EOF

cat > "$INSTALL_DIR/domains/web/react-patterns.md" << 'EOF'
# React Patterns

## Component Structure

```tsx
// Prefer functional components with hooks
export function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading } = useUser(userId);

  if (isLoading) return <Skeleton />;
  if (!user) return <NotFound />;

  return (
    <div className="user-profile">
      <Avatar src={user.avatar} />
      <h1>{user.name}</h1>
    </div>
  );
}
```

## State Management

- **Local state**: `useState` for component-specific state
- **Shared state**: Context or state library (Zustand, Jotai)
- **Server state**: React Query or SWR

## Performance

- Use `React.memo` for expensive pure components
- Use `useMemo` for expensive calculations
- Use `useCallback` for callbacks passed to memoized children
- Don't prematurely optimize

## File Structure

```
src/
├── components/       # Reusable UI components
├── features/         # Feature-based modules
│   └── auth/
│       ├── components/
│       ├── hooks/
│       └── api/
├── hooks/           # Shared hooks
├── utils/           # Helper functions
└── types/           # TypeScript types
```
EOF

mkdir -p "$INSTALL_DIR/domains/backend"
cat > "$INSTALL_DIR/domains/backend/api-design.md" << 'EOF'
# API Design Guidelines

## REST Conventions

### HTTP Methods
- `GET` - Retrieve resources (idempotent)
- `POST` - Create resources
- `PUT` - Replace resources (idempotent)
- `PATCH` - Partial update
- `DELETE` - Remove resources (idempotent)

### Status Codes
- `200` - Success
- `201` - Created
- `204` - No Content (successful DELETE)
- `400` - Bad Request (client error)
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Server Error

### URL Structure
```
GET    /users              # List users
GET    /users/:id          # Get single user
POST   /users              # Create user
PUT    /users/:id          # Replace user
PATCH  /users/:id          # Update user
DELETE /users/:id          # Delete user
GET    /users/:id/posts    # Nested resources
```

## Error Responses

Always return structured errors:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "email", "message": "Email is required" }
    ]
  }
}
```

## Pagination

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 100,
    "total_pages": 5
  }
}
```
EOF

success "Created example instruction files"

# Add to PATH
log "Configuring PATH..."

SHELL_RC=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

PATH_LINE="export PATH=\"\$HOME/.ai-instructions/bin:\$PATH\""

if [[ -n "$SHELL_RC" ]]; then
    if ! grep -q ".ai-instructions/bin" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# AI Instructions CLI" >> "$SHELL_RC"
        echo "$PATH_LINE" >> "$SHELL_RC"
        success "Added to PATH in $SHELL_RC"
    else
        warn "PATH already configured in $SHELL_RC"
    fi
else
    warn "Could not detect shell config file"
    echo "Add this to your shell config:"
    echo "  $PATH_LINE"
fi

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Setup Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Installation directory: $INSTALL_DIR"
echo ""
echo "Next steps:"
echo ""
echo "  1. Reload your shell:"
echo "     ${CYAN}source $SHELL_RC${NC}"
echo ""
echo "  2. Add instructions to a project:"
echo "     ${CYAN}cd ~/your-project${NC}"
echo "     ${CYAN}instr sync .${NC}"
echo ""
echo "  3. Or use the interactive picker:"
echo "     ${CYAN}instr pick${NC}"
echo ""
echo "  4. Customize your instructions:"
echo "     ${CYAN}ls $INSTALL_DIR${NC}"
echo ""
echo "Documentation: https://github.com/piertwo/ai-instructions"
echo ""
