# GitHub Action for differential code linting

This action is built on top of [VCS Diff Lint](https://github.com/fedora-copr/vcs-diff-lint) tool.

## Example

```yml
name: Differential Linters

on:
  # For push, we "do nothing".  But it needs to be specified, see #17
  push:
  pull_request:
    branches: [ main ]

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest

    permissions:
      # required for all workflows
      security-events: write

      # only required for workflows in private repositories
      actions: read
      contents: read

    steps:
      - name: Repository checkout
        uses: actions/checkout@v4

      - id: VCS_Diff_Lint
        name: VCS Diff Lint
        uses: fedora-copr/vcs-diff-lint-action@v1

      - name: Upload artifact with detected defects in SARIF format
        uses: actions/upload-artifact@v4
        with:
          name: VCS Diff Lint SARIF
          path: ${{ steps.VCS_Diff_Lint.outputs.sarif }}
        if: ${{ always() }}

      - name: Upload SARIF to GitHub using github/codeql-action/upload-sarif
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: ${{ steps.VCS_Diff_Lint.outputs.sarif }}
        if: ${{ always() }}
```

## Options

```yml
# ...

- name: VCS Diff Lint
  uses: fedora-copr/vcs-diff-lint-action@v1
  with:
    subdirectory: <path>
    subdirectories: <list of paths>
    linter_tags: <list of linter tags>
    debug: <true or false>

# ...
```

### subdirectory

Sub-directory to step in before the linting is performed. The sub-directory must contain the `.vcs-diff-lint.yml` file, or RPM spec file.

* default value: `undefined`
* requirements: `optional`

### subdirectories

Equivalent to `subdirectory` option, but multiplied. Space separated list of sub-directories to analyze. The linter is executed multiple times, for each sub-diretory separately.

* default value: `undefined`
* requirements: `optional`

### linter_tags

Space-separated list of linter tags (selectors) for the `vcs-diff-lint` utility
(see the `--linter-tags` option). By default all linters are selected. Avaliable
linter tags are `mypy`, `pylint`, `ruff`, and `python`.

* default value: `undefined`
* requirements: `optional`

### install\_rpm\_packages

Space-separated list of RPM packages that are automatically installed into the
testing environment (= Docker container).

* default value: `undefined`
* requirements: `optional`

### debug

Turn on debugging info.

* default value: `false`
* requirements: `optional`

## Outputs

VCS Diff Lint GitHub Action exposes following [outputs](https://docs.github.com/en/actions/using-jobs/defining-outputs-for-jobs).

### sarif

Relative path to SARIF file containing detected defects.
