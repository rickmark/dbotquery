# DBotQuery

Command-line reports for [GitHub Dependabot](https://docs.github.com/en/code-security/dependabot) exports.

DBotQuery reads a JSON export of Dependabot alerts and produces machine-readable
(JSON) reports — vulnerability summaries, SLA compliance statistics, and package
usage searches. It is designed so that people who don't have direct access to
GitHub (or who want the data in another system) can still see and process an
organization's vulnerability posture.

The tool does not need to talk to GitHub to produce reports: it takes an exported
Dependabot JSON file as input, along with some options, and writes a JSON document
to standard output. (Optional live fetching via the GitHub API is also supported —
see [Fetching data from GitHub](#fetching-data-from-github).)

## Requirements

- Ruby `>= 3.3`
- [Bundler](https://bundler.io/)

## Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/rickmark/dbotquery.git
cd dbotquery
bin/setup
```

To install the executable onto your machine as a gem:

```bash
bundle exec rake install
```

You can then run `dbotquery` directly. Otherwise, prefix commands with
`bundle exec` as shown below.

## Usage

Every command takes a Dependabot JSON export via `-f`/`--file` and prints a JSON
report to standard output.

```bash
bundle exec dbotquery <command> -f dependabot.json [options]
```

Run `bundle exec dbotquery help` to list commands, or
`bundle exec dbotquery help <command>` for details on a specific one.

### `summary` — count vulnerabilities

Counts findings in the export, optionally filtered by state and/or severity.

```bash
# All findings
bundle exec dbotquery summary -f dependabot.json

# Only dismissed findings
bundle exec dbotquery summary -f dependabot.json --state dismissed

# Only open, critical findings
bundle exec dbotquery summary -f dependabot.json --state open --severity critical
```

| Flag | Required | Description | Values |
| :--- | :--- | :--- | :--- |
| `-f`, `--file` | yes | Path to the Dependabot JSON export | `dependabot.json` |
| `--state` | no | Only count findings in this state | `open`, `fixed`, `dismissed` |
| `--severity` | no | Only count findings of this severity | `critical`, `high`, `medium`, `low` |

Output:

```json
{ "count": 42 }
```

### `sla_stats` — SLA breaches by severity

Counts vulnerabilities that have been open longer than the allowed SLA, broken
out by severity. The SLA (in days) is:

| Severity | Days |
| :--- | :--- |
| Low | 60 |
| Medium | 30 |
| High | 15 |
| Critical | 5 |

```bash
# Using the current time to calculate age
bundle exec dbotquery sla_stats -f dependabot.json

# Using a fixed point in time (ISO 8601)
bundle exec dbotquery sla_stats -f dependabot.json -t 2023-01-01T00:00:00Z
```

| Flag | Required | Description | Example |
| :--- | :--- | :--- | :--- |
| `-f`, `--file` | yes | Path to the Dependabot JSON export | `dependabot.json` |
| `-t`, `--time` | no | Point in time used to calculate age (ISO 8601) | `2023-01-01T00:00:00Z` |

Output:

```json
{ "low": 1, "medium": 2, "high": 0, "critical": 3, "total": 6 }
```

### `repo_sla_stats` — SLA breaches by repository

The same report as `sla_stats`, but broken out per repository so teams can see
the findings specific to their code.

```bash
bundle exec dbotquery repo_sla_stats -f dependabot.json
bundle exec dbotquery repo_sla_stats -f dependabot.json -t 2023-01-01T00:00:00Z
```

Flags are identical to `sla_stats`. Output:

```json
{
  "org/repo":  { "low": 1, "medium": 0, "high": 2, "critical": 1, "total": 4 },
  "org/repo2": { "low": 0, "medium": 1, "high": 0, "critical": 0, "total": 1 }
}
```

### `package_search` — where is a package used?

Answers "do we use library X?" by listing every repository where the given
package appears.

```bash
bundle exec dbotquery package_search -f dependabot.json --package sinatra
bundle exec dbotquery package_search -f dependabot.json --package node-forge
```

| Flag | Required | Description | Example |
| :--- | :--- | :--- | :--- |
| `-f`, `--file` | yes | Path to the Dependabot JSON export | `dependabot.json` |
| `--package` | yes | The package name to search for | `sinatra`, `puma`, `node-forge` |

Output:

```json
["org/repo", "org/repo2"]
```

## Fetching data from GitHub

DBotQuery ships with [Octokit](https://github.com/octokit/octokit.rb) extensions
for pulling Dependabot alerts directly from the GitHub API, which can be used from
the console or in your own scripts:

```ruby
client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
client.dependabot_org_alerts("my-org")
client.dependabot_repo_alerts("my-org", "my-repo")
```

Provide the token via a `GITHUB_TOKEN` environment variable — for local
development you can place it in a `.env` file, which is **git-ignored** and must
never be committed. Treat these tokens as secrets and rotate them if exposed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then:

```bash
bundle exec rake spec   # run the test suite
bin/console             # interactive prompt for experimentation
```

The project also uses:

- [RuboCop](https://rubocop.org/) for linting (`bundle exec rubocop`)
- [Steep](https://github.com/soutaro/steep) / [RBS](https://github.com/ruby/rbs)
  for type checking (`bundle exec steep check`)
- [YARD](https://yardoc.org/) for documentation (`bundle exec rake yard`)

To release a new version, update the version number in
`lib/d_bot_query/version.rb`, then run `bundle exec rake release`, which creates a
git tag, pushes commits and the tag, and pushes the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/rickmark/dbotquery>. Please read
[CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request. This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

Available as open source under the terms of the [MIT License](LICENSE.txt).
