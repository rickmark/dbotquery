# Contributing to DBotQuery

Thanks for your interest in improving DBotQuery! Bug reports, feature requests,
and pull requests are all welcome.

By participating in this project you agree to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).

## Getting started

1. Fork the repository and clone your fork.
2. Install dependencies:
   ```bash
   bin/setup
   ```
3. Make sure the test suite passes before you change anything:
   ```bash
   bundle exec rake spec
   ```

Requires Ruby `>= 3.3` and Bundler.

## Reporting bugs and requesting features

Open an issue at <https://github.com/rickmark/dbotquery/issues>. For bug reports,
please include:

- What you expected to happen and what actually happened.
- The exact command you ran (with any relevant flags).
- A minimal, **sanitized** snippet of the Dependabot export that reproduces the
  problem. Never paste real tokens, secrets, or private vulnerability data into
  an issue.
- Your Ruby version (`ruby -v`) and OS.

## Development workflow

1. Create a topic branch off `main`:
   ```bash
   git checkout -b my-feature
   ```
2. Make your change, adding or updating tests and documentation as needed.
3. Run the full check suite locally (see below).
4. Commit with a clear message, push to your fork, and open a pull request
   against `main`.

Keep pull requests focused — one logical change per PR makes review easier.

## Quality checks

All of the following should pass before you open a pull request. CI runs them
too.

```bash
bundle exec rake spec        # RSpec test suite
bundle exec rubocop          # style / lint
bundle exec steep check      # RBS / Steep type checking
```

Guidelines:

- **Tests.** New behavior needs test coverage; bug fixes should include a test
  that fails before the fix and passes after. Fixtures live under `spec/fixtures`.
- **Types.** This project uses inline RBS (`# rbs_inline: enabled`) with signatures
  in `sig/`. When you change a public method, update the corresponding `.rbs`
  signature so `steep check` stays green.
- **Style.** Follow the existing code style; RuboCop is the source of truth. Match
  the surrounding code's naming, structure, and comment density.
- **Documentation.** Update `README.md` and command doc comments when you add or
  change a command or option.

## Architecture at a glance

- `lib/d_bot_query/cli.rb` — Thor-based command-line interface (argument parsing).
- `lib/d_bot_query/commands/` — one class per subcommand. Each command is thin and
  delegates to the models, which keeps the CLI and the logic independently
  testable.
- `lib/d_bot_query/models/` — data models wrapping the Dependabot export
  (alerts, advisories, packages, repositories, CVSS/CWE, etc.).
- `lib/d_bot_query/octokit.rb` — optional Octokit extensions for fetching alerts
  live from the GitHub API.

When adding a new report, add a command class under `commands/`, wire it into
`cli.rb`, and put the actual computation on the appropriate model so it can be
unit-tested without the CLI.

## Security

Do not commit secrets. `GITHUB_TOKEN` and any `.env` file are git-ignored — keep
it that way. If you discover a security issue, please avoid filing a public issue
with sensitive details; contact the maintainer directly instead.

## License

By contributing, you agree that your contributions will be licensed under the
[MIT License](LICENSE.txt) that covers the project.
