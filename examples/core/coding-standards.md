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
