import ArgumentParser


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: []
    )

    public init() { }

    public func run() async throws { }
}
