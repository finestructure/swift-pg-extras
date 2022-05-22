import PostgresNIO
import TextTable


protocol PGExtrasCommand {
    associatedtype Row: PGExtrasCommandRow
    static var sql: String { get }
}


extension PGExtrasCommand {
    static func runQuery(
        credentials: Credentials,
        process: (PostgresRowSequence) async throws -> Void = { _ in }
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

    static func printTable(_ data: [Row.Values], style: TextTableStyle.Type) {
        guard !data.isEmpty else {
            print("Query returned no data.")
            return
        }
        Row.table.print(data, style: style)
    }
}


// MARK: - run overloads

extension PGExtrasCommand {
    // 1
    static func run<T0: PostgresDecodable>(_ type: T0.Type,
                                           credentials: Credentials,
                                           _ transform: (T0) -> Row) async throws {
        typealias Tuple = T0
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 2
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable>(_ type: (T0, T1).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1)) -> Row) async throws {
        typealias Tuple = (T0, T1)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 3
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable>(_ type: (T0, T1, T2).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 3
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable>(_ type: (T0, T1, T2, T3).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2, T3)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 5
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 6
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable,
                    T5: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4, T5).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }

    // 7
    static func run<T0: PostgresDecodable,
                    T1: PostgresDecodable,
                    T2: PostgresDecodable,
                    T3: PostgresDecodable,
                    T4: PostgresDecodable,
                    T5: PostgresDecodable,
                    T6: PostgresDecodable>(_ type: (T0, T1, T2, T3, T4, T5, T6).Type,
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5, T6)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5, T6)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
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
                                           credentials: Credentials,
                                           _ transform: ((T0, T1, T2, T3, T4, T5, T6, T7)) -> Row) async throws {
        typealias Tuple = (T0, T1, T2, T3, T4, T5, T6, T7)
        var data: [Tuple] = []
        try await runQuery(credentials: credentials, process: { rows in
            for try await row in rows.decode(Tuple.self, context: .default) {
                data.append(row)
            }
        })
        printTable(data.map(transform).map(\.values), style: Style.psql)
    }
}
