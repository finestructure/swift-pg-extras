import Foundation

import ArgumentParser
import TextTable
import PostgresNIO


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: [
            CacheHit.self,
            Bloat.self,
            Blocking.self,
            IndexSize.self,
            IndexUsage.self,
            Locks.self,
            LongRunningQueries.self,
            RecordsRank.self,
            SeqScans.self,
            TableIndexesSize.self,
            TableSize.self,
            TotalIndexSize.self,
            TotalTableSize.self,
            UnusedIndexes.self,
            VacuumStats.self
        ]
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
    private static func runQuery(
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

    static func print(_ data: [Row.Values], style: TextTableStyle.Type) {
        guard !data.isEmpty else {
            Swift.print("Query returned no data.")
            return
        }
        Row.table.print(data, style: style)
    }
}


// MARK: - run overloads

extension PGExtrasCommand {
    // 1
    static func run<T0: PostgresDecodable>(_ type: T0.Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: (T0) -> Row) async throws {
        typealias Tuple = T0
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 2
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable>(_ type: (T0, T1).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1)) -> Row) async throws {
        typealias Tuple = (T0, T1)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 3
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable>(_ type: (T0, T1, T2).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 3
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable>(_ type: (T0, T1, T2, T3).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2, T3)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 5
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 6
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable,
                    T5: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4, T5).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 7
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable,
                    T5: PostgresDecodable,
                    T6: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4, T5, T6).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5, T6)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5, T6)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }

    // 8
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable,
                    T5: PostgresDecodable,
                    T6: PostgresDecodable,
                    T7: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4, T5, T6, T7).Type,
                                           credentials: PGExtras.Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5, T6, T7)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5, T6, T7)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        print(data.map(transform).map(\.values), style: Style.psql)
    }
}


protocol PGExtrasCommandRow {
    associatedtype Values

    var values: Values { get }

    static var table: TextTable<Self.Values> { get }
}


