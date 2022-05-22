import ArgumentParser
import TextTable


public struct IndexSize: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension IndexSize: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Name", value: $0),
                Column(title: "Size", value: $1),

            ]
        }
    }

    static let sql = """
        -- index-size
        SELECT c.relname AS name,
          pg_size_pretty(sum(c.relpages::bigint*8192)::bigint) AS size
        FROM pg_class c
        LEFT JOIN pg_namespace n ON (n.oid = c.relnamespace)
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind='i'
        GROUP BY c.relname
        ORDER BY sum(c.relpages) DESC
        """
}
