import ArgumentParser
import Foundation


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: [CacheHit.self]
    )

    public init() { }

    public func run() async throws { }
}


extension PGExtras {
    struct Options: ParsableArguments {
        @Option(name: .shortAndLong, help: "Path to Postgres DB credentials.")
        var credentials: Credentials
    }

    struct Credentials: ExpressibleByArgument, Decodable {
        var host: String
        var port: Int = 5432
        var username: String
        var database: String
        var password: String
        var tls: TLS! = .disable

        init?(argument: String) {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: argument)),
                  let decoded = try? JSONDecoder().decode(Self.self, from: data)
            else {
                return nil
            }
            self = decoded
        }

        enum TLS: String, Decodable {
            case disable
            case require
        }
    }
}
