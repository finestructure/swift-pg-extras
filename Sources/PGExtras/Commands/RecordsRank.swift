import ArgumentParser
import TextTable


public struct RecordsRank: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension RecordsRank: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, Int)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Name", value: $0),
                Column(title: "Estimated Count", value: $1),

            ]
        }
    }

    static let sql = """
        -- records-rank
        SELECT
          relname AS name,
          n_live_tup AS estimated_count
        FROM
          pg_stat_user_tables
        ORDER BY
          n_live_tup DESC
        """
}
