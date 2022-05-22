import ArgumentParser


struct Options: ParsableArguments {
    @Option(name: .shortAndLong, help: "Path to Postgres DB credentials.")
    var credentials: Credentials
}
