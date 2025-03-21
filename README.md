# GitHub Action: Run ast-grep with reviewdog

[![Test](https://github.com/reviewdog/action-ast-grep/workflows/Test/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-ast-grep/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-ast-grep/workflows/depup/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-ast-grep/workflows/release/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-ast-grep?logo=github&sort=semver)](https://github.com/reviewdog/action-ast-grep/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This is an action to run [ast-grep(sg)][ast-grep] with [reviewdog][reviewdog].

[ast-grep]: https://github.com/ast-grep/ast-grep
[reviewdog]: https://github.com/reviewdog/reviewdog

## Examples

![demo1](https://github.com/user-attachments/assets/1c767bc0-43c4-4a60-ab97-b8b8e916ddc8)
![demo2](https://github.com/user-attachments/assets/3c341c29-536c-4032-b5f4-f9ec06731dfe)

## Inputs

### `github_token`

GITHUB_TOKEN
The default is `${{ github.token }}`.

### `workdir`

Working directory relative to the root directory.
The default is `.`.

### `tool_name`

Tool name to use for reviewdog reporter.
The default is `ast-grep`.

### `level`

Report level for reviewdog [info,warning,error].
The default is `error`.

### `reporter`

Reporter of reviewdog command [github-check,github-pr-review,github-pr-check].
The default is `github-check`.

### `filter_mode`

Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is `added` except that sarif reporter uses `nofilter`.

### `fail_level`

Optional. If set to `none`, always use exit code 0 for reviewdog.
Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
Possible values: [`none`, `any`, `info`, `warning`, `error`]
Default is `none`.

### `fail_on_error`

Deprecated, use `fail_level` instead.
Exit code for reviewdog when errors are found [true,false].
The default is `false`.

### `reviewdog_flags`

Additional reviewdog flags.

### `output_dir`

Output directory of reviewdog result. Useful for -reporter=sarif
The default is `../reviewdog-results`.

### `sg_version`

ast-grep version.

### `sg_config`

The path to the ast-grep config file.
The default is `sgconfig.yml`.

### `sg_flags`

Additional ast-grep flags.

## Usage

### Basic

Create `sgconfig.yml` and some rules in your repository by following the [project setup guide][sg-scan-guide].

Add a workflow to run action-ast-grep that triggered by pull request event.

```yaml
name: reviewdog
on: [pull_request]
jobs:
  ast-grep:
    name: runner / ast-grep
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: reviewdog/action-ast-grep@1d5fcb951c6e512f0de62e62031a27dd9d62fec0 # v1.26.6
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          # Change reviewdog reporter if you need [github-check,github-pr-review,github-pr-check].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
          # path to the sgconfig.yml
          sg_config: sgconfig.yml
```

Reviewdog will report `ast-grep scan` result.

[sg-scan-guide]: https://ast-grep.github.io/guide/scan-project.html

### Advanced: Use Custom Language Parser

ast-grep experimentally supports custom languages. ([ref][sg-custom-lang])

To use this feature with this action, build tree-sitter parsers before calling this action on your workflow.

For building tree-sitter parsers, [rinx/setup-tree-sitter-parser][rinx/setup-tree-sitter-parser] is useful.

```yaml
name: reviewdog
on: [pull_request]
jobs:
  ast-grep:
    name: runner / ast-grep / fennel
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - name: Build tree-sitter grammar for fennel
        uses: rinx/setup-tree-sitter-parser@e0242ba833bf1c7f89d758f46da25653b2feba12 # v1.0.1
        with:
          # this action will place the build artifact here.
          parser_dir: ./
          parser_repository: alexmozaidze/tree-sitter-fennel
      - name: Run ast-grep with reviewdog
        uses: reviewdog/action-ast-grep@1d5fcb951c6e512f0de62e62031a27dd9d62fec0 # v1.26.6
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          level: info
          reporter: github-pr-review
```

[sg-custom-lang]: https://ast-grep.github.io/advanced/custom-language.html
[rinx/setup-tree-sitter-parser]: https://github.com/rinx/setup-tree-sitter-parser

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action itself is integrated with reviewdog to run lints
which is useful for [action composition] based actions.

[action composition]:https://docs.github.com/en/actions/creating-actions/creating-a-composite-action

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-shfmt](https://github.com/reviewdog/action-shfmt)
- [reviewdog/action-actionlint](https://github.com/reviewdog/action-actionlint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)
- [reviewdog/action-alex](https://github.com/reviewdog/action-alex)

### Dependencies Update Automation
This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)
