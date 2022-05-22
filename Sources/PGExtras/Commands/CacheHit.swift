import Foundation

import ArgumentParser
import TextTable


public struct CacheHit: AsyncParsableCommand {
    @OptionGroup var options: Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}

extension CacheHit: PGExtrasCommand {
    struct Row: TableRow {
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
