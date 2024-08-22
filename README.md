# action-ast-grep

[![Test](https://github.com/reviewdog/action-ast-grep/workflows/Test/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-ast-grep/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-ast-grep/workflows/depup/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-ast-grep/workflows/release/badge.svg)](https://github.com/reviewdog/action-ast-grep/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-ast-grep?logo=github&sort=semver)](https://github.com/reviewdog/action-ast-grep/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![demo1](https://github.com/user-attachments/assets/1c767bc0-43c4-4a60-ab97-b8b8e916ddc8)
![demo2](https://github.com/user-attachments/assets/3c341c29-536c-4032-b5f4-f9ec06731dfe)

This is an action to run [ast-grep][ast-grep] with [reviewdog][reviewdog].

[ast-grep]: https://github.com/ast-grep/ast-grep
[reviewdog]: https://github.com/reviewdog/reviewdog

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  tool_name:
    description: 'Tool name to use for reviewdog reporter.'
    default: 'ast-grep'
  level:
    description: 'Report level for reviewdog [info,warning,error].'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-check,github-pr-review,github-pr-check].'
    default: 'github-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false].
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags.'
    default: ''
  ### Flags for ast-grep ###
  sg_version:
    description: 'ast-grep version.'
    default: ''
  sg_config:
    description: 'path to the ast-grep config file'
    default: 'sgconfig.yml'
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  ast-grep:
    name: runner / ast-grep
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: reviewdog/action-ast-grep@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-check,github-pr-review,github-pr-check].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

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
