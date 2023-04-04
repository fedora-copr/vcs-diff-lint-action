# GitHub Action for differential code linting

This action is built on top of [VCS Diff Lint](https://github.com/fedora-copr/vcs-diff-lint) tool.

## Example

```yml
name: Differential Linters

on:
  push:
  pull_request:
    branches: [ main ]

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest
    if: github.event_name != 'push'
    permissions:
      # required for all workflows
      security-events: write

      # only required for workflows in private repositories
      actions: read
      contents: read

    steps:
      - name: Repository checkout
        uses: actions/checkout@v3

      - id: VCS_Diff_Lint
        name: VCS Diff Lint
        uses: fedora-copr/vcs-diff-lint-action@v1

      - name: Upload artifact with detected defects in SARIF format
        uses: actions/upload-artifact@v3
        with:
          name: VCS Diff Lint SARIF
          path: ${{ steps.VCS_Diff_Lint.outputs.sarif }}
        if: ${{ always() }}

      - name: Upload SARIF to GitHub using github/codeql-action/upload-sarif
        uses: github/codeql-action/upload-sarif@v2
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

Comma-separated list of linter tags (selectors) for the `vcs-diff-lint` utility (see the `--linter-tags` option). By default all linters are selected. Avaliable linter tags are `mypy`, `pylint`, and `python`.

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
