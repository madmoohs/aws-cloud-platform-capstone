# Contributing

## Branch Strategy

- `main` - Production-ready code
- `develop` - Integration branch for features

## Workflow

1. Create a feature branch from `develop`
2. Make changes and commit
3. Push and create a PR to `develop`
4. CI pipeline runs (TFLint, Checkov, Trivy, Helm lint)
5. After review, merge to `develop`
6. Deploy to staging via PR to `main`
7. Deploy to production via `main` with approval

## Commit Convention

```
feat: new feature
fix: bug fix
chore: maintenance
docs: documentation
infra: infrastructure changes