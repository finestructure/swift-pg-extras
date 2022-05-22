import ArgumentParser
import TextTable


struct TableIndexesSize: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension TableIndexesSize: PGExtrasCommand {
    struct Row: PGExtrasCommandRow {
        typealias Values = (String, String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Table", value: $0),
                Column(title: "Index Size", value: $1, align: .right),

            ]
        }
    }

    static let sql = """
        -- table-indexes-size
        SELECT c.relname AS table,
          pg_size_pretty(pg_indexes_size(c.oid)) AS index_size
        FROM pg_class c
        LEFT JOIN pg_namespace n ON (n.oid = c.relnamespace)
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind='r'
        ORDER BY pg_indexes_size(c.oid) DESC
        """
}
