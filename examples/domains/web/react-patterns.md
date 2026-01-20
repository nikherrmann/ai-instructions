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

## Naming Conventions

- **Components**: PascalCase (`UserProfile.tsx`)
- **Hooks**: camelCase with `use` prefix (`useAuth.ts`)
- **Utils**: camelCase (`formatDate.ts`)
- **Constants**: SCREAMING_SNAKE_CASE (`API_BASE_URL`)
