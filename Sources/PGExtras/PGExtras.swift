import ArgumentParser


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: [CacheHit.self]
    )

    public init() { }

    public func run() async throws { }
}
