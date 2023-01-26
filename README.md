# GitHub Action for differential code linting

This action is built on top of [VCS Diff Lint](https://github.com/fedora-copr/vcs-diff-lint) tool.

## Example

```yml
name: Differential Linters

on:
  pull_request:
    branches: [ main ]

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Repository checkout
        uses: actions/checkout@v3

      - name: VCS Diff Lint
        uses: fedora-copr/vcs-diff-lint-action@v1
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
