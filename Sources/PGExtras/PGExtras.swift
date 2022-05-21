import Foundation

import ArgumentParser
import TextTable
import PostgresNIO


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: [CacheHit.self, Bloat.self]
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
        var tls: TLS? = .disable

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


protocol PGExtrasCommand {
    associatedtype Row: PGExtrasCommandRow
    static var sql: String { get }
}


extension PGExtrasCommand {
    static func runQuery(
        credentials: PGExtras.Credentials,
        process: (PostgresRowSequence) async throws -> Void
    ) async throws {
        let config = try PostgresConnection.Configuration(credentials: credentials)

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try? eventLoopGroup.syncShutdownGracefully() }

        let logger = Logger(label: "pg-extras")

        let conn = try await PostgresConnection.connect(on: eventLoopGroup.next(),
                                                        configuration: config,
                                                        id: 1,
                                                        logger: logger)

        let rows = try await conn.query(.init(stringLiteral: Self.sql), logger: logger)

        try await process(rows)

        try await conn.close()
    }

    static func print(data: [Row.Values]) {
        Row.table.print(data, style: Style.psql)
    }
}


protocol PGExtrasCommandRow {
    associatedtype Values

    var values: Values { get }

    static var table: TextTable<Self.Values> { get }
}


