import ArgumentParser
import TextTable


public struct SeqScans: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension SeqScans: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, Int)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Name", value: $0),
                Column(title: "Count", value: $1),

            ]
        }
    }

    static let sql = """
        -- seq-scans
        SELECT relname AS name,
               seq_scan as count
        FROM
          pg_stat_user_tables
        ORDER BY seq_scan DESC
        """
}
