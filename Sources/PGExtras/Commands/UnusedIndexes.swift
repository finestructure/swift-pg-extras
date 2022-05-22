import ArgumentParser
import TextTable


public struct UnusedIndexes: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension UnusedIndexes: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, String, String, Int)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Table", value: $0),
                Column(title: "Index", value: $1),
                Column(title: "Index Size", value: $2, align: .right),
                Column(title: "Index Scans", value: $3, align: .right),

            ]
        }
    }

    static let sql = """
        -- unused-indexes
        SELECT
          schemaname || '.' || relname AS table,
          indexrelname AS index,
          pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size,
          idx_scan as index_scans
        FROM pg_stat_user_indexes ui
        JOIN pg_index i ON ui.indexrelid = i.indexrelid
        WHERE NOT indisunique AND idx_scan < 50 AND pg_relation_size(relid) > 5 * 8192
        ORDER BY pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) DESC NULLS FIRST,
        pg_relation_size(i.indexrelid) DESC
        """
}

