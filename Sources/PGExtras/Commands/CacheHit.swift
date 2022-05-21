import Foundation

import ArgumentParser
import PostgresNIO
import TextTable


struct CacheHit: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.runQuery(credentials: options.credentials) { rows in
            var data: [Row.Values] = []
            for try await row in rows.decode(Row.Values.self, context: .default) {
                data.append(row)
            }
            Self.print(data: data)
        }
    }
}

extension CacheHit: PGExtrasCommand {
    struct Row: PGExtrasCommandRow {
        typealias Values = (String, Decimal?)

        var values: Values

        static let table = TextTable<Values> {
            [
                Column(title: "Name", value: $0),
                Column(title: "Ratio", value: $1 ?? "NULL"),

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
