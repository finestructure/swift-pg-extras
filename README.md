# swift-pg-extras

Commands providing shortcuts to common Postgres introspection queries. This package is a port of [heroku-pg-extras](https://github.com/heroku/heroku-pg-extras).

Most of the commands have been ported, except for a few that need special database configuration or where it's unclear how to port them.

## Installation

Via mint:

```
mint install finestructure/swift-pg-extras
```

Or clone the repository and run/install it like any other Swift command line utility.

## How to run

Get a list of all available commands:

```
pg-extras --help
```

Example command:

```
pg-extras -c .credentials cache-hits
+----------------+---------------------+
| Name           | Ratio               |
+----------------+---------------------+
| index hit rate | 0.9993522581171029  |
| table hit rate | 0.9993522581171029  |
+----------------+---------------------+
```

where `.credentials` containes your Postgres database connection details:

```json
{
    "host": "localhost",
    "port": 5432,
    "username": "foo",
    "database": "bar",
    "password": "pass"
}
```

The credentials file supports an optional field `tls` to `disable` or `require` TLS:

```json
{
    ...
    "tls": "require"
}
```

## Available commands

* [x] bloat
* [x] blocking
* [x] cache-hits
* [ ] calls
  - requires `create extension pg_stat_statements` and loading pg_stat_statements via shared_preload_libraries
* [ ] extensions
	- `ERROR:  unrecognized configuration parameter "extwlist.extensions"`
* [ ] fdwsql
  - looks like it requires `postgres_fdw` setup
* [x] index-size
* [x] index-usage
* [x] locks
* [x] long-running-queries
* [ ] mandelbrot
  - gimmick
* [x] records-rank
* [x] seq-scans
* [x] table-indexes-size
* [x] table-size
* [x] total-index-size
* [x] total-table-size
* [ ] outliers
  - requires `create extension pg_stat_statements` and loading pg_stat_statements via shared_preload_libraries
* [x] unused-indexes
* [ ] user-connections
  - unsure how this works in the original, no SQL in command
* [x] vacuum-stats
