import ArgumentParser
import TextTable


struct IndexUsage: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension IndexUsage: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, String?, Int)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Table Name", value: $0),
                Column(title: "% of times idx used", value: $1 ?? "NULL"),
                Column(title: "Rows", value: $2),

            ]
        }
    }

    static let sql = """
        -- index-usage
        SELECT relname,
           CASE idx_scan
             WHEN 0 THEN 'Insufficient data'
             ELSE (100 * idx_scan / (seq_scan + idx_scan))::text
           END percent_of_times_index_used,
           n_live_tup rows_in_table
         FROM
           pg_stat_user_tables
         ORDER BY
           n_live_tup DESC
        """
}
