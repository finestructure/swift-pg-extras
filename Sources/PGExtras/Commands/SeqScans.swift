import ArgumentParser
import TextTable


struct SeqScans: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension SeqScans: PGExtrasCommand {
    struct Row: PGExtrasCommandRow {
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