import Foundation

import ArgumentParser
import PostgresNIO
import TextTable


struct CacheHit: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        let config = try PostgresConnection.Configuration(credentials: options.credentials)

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try? eventLoopGroup.syncShutdownGracefully() }

        let logger = Logger(label: "pg-extras")

        let conn = try await PostgresConnection.connect(on: eventLoopGroup.next(),
                                                        configuration: config,
                                                        id: 1,
                                                        logger: logger)

        let rows = try await conn.query(.init(stringLiteral: Self.sql), logger: logger)
        var data: [Row] = []
        for try await row in rows
            .decode(Row.Values.self, context: .default)
            .map(Row.init) {
            data.append(row)
        }
        Row.table.print(data, style: Style.psql)

        try await conn.close()
    }
}

extension CacheHit {
    struct Row {
        typealias Values = (String, Decimal?)

        var values: Values

        static let table = TextTable<Row> {
            [
                Column(title: "Name", value: $0.values.0),
                Column(title: "Ratio", value: $0.values.1 ?? "NULL"),

            ]
        }
    }

    static let sql = """
        -- cache-hit
        SELECT
        'index hit rate' AS name,
        (sum(idx_blks_hit)) / nullif(sum(idx_blks_hit + idx_blks_read),0) AS ratio
        FROM pg_statio_user_indexes
        UNION ALL
        SELECT
        'table hit rate' AS name,
        sum(heap_blks_hit) / nullif(sum(heap_blks_hit) + sum(heap_blks_read),0) AS ratio
        FROM pg_statio_user_tables
        """
}
