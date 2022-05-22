import ArgumentParser
import TextTable


struct TotalTableSize: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension TotalTableSize: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Name", value: $0),
                Column(title: "Size", value: $1, align: .right),

            ]
        }
    }

    static let sql = """
        -- total-table-size
        SELECT c.relname AS name,
          pg_size_pretty(pg_total_relation_size(c.oid)) AS size
        FROM pg_class c
        LEFT JOIN pg_namespace n ON (n.oid = c.relnamespace)
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind='r'
        ORDER BY pg_total_relation_size(c.oid) DESC
        """
}
