import ArgumentParser
import TextTable


public struct TotalIndexSize: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension TotalIndexSize: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Size", value: $0)
            ]
        }
    }

    static let sql = """
        -- total-index-size
        SELECT pg_size_pretty(sum(c.relpages::bigint*8192)::bigint) AS size
        FROM pg_class c
        LEFT JOIN pg_namespace n ON (n.oid = c.relnamespace)
        WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
        AND n.nspname !~ '^pg_toast'
        AND c.relkind='i'
        """
}
