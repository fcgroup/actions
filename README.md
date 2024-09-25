# GitHub Actions Workflows

Reusable GitHub Action workflows for FCG projects.

Runs on `ubuntu` and `macos`.

## Usage

### Validation Workflow

Runs `pre-commit` validation and executes the projects `lint` script from `package.json`.

```yaml
jobs:
  ci:
    name: Validation
    uses: fcgroup/actions/.github/workflows/validation.yaml@main
    with:
      runPreCommit: true # optional
      runDefaultLinters: true # optional
      additionalHomebrewPackages: tflint tfsec # optional
      runDefaultTests: true # optional
```

### Semantic Release Workflow

```yaml
jobs:
  cd:
    name: Release
    uses: fcgroup/actions/.github/workflows/semantic-release.yaml@main
    secrets:
      GIT_TOKEN_BASIC: ${{ secrets.GIT_TOKEN_BASIC }} # required
      NPM_ACCESS_TOKEN: ${{ secrets.NPM_ACCESS_TOKEN }} # optional
```

Note that `NPM_ACCESS_TOKEN` is required when accessing private packages and/or publishing packages.
