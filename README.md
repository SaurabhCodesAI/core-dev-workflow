# Core Dev Workflow

Elite-level automation and tooling workflows for development logging, analysis, and simulations.

## Git Workflow Tools

### Git Log Comparison

To compare commits between your current branch and the main branch, use:

```bash
git log origin/main..HEAD
```

If this command fails with an "unknown revision" error, use one of these helper scripts:

#### Quick Setup
```bash
./utils/setup-git.sh
```

#### Interactive Git Log with Auto-Setup
```bash
./utils/git-log-diff.sh [git log options]
```

The helper scripts automatically configure the `origin/main` reference if it's not available locally.