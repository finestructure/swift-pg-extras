import ArgumentParser
import TextTable
import Foundation


public struct LongRunningQueries: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    public func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }

    public init() { }
}



extension LongRunningQueries: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (Int, Decimal, String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "PID", value: $0),
                Column(title: "Duration", value: $1),
                Column(title: "Query", value: $2),

            ]
        }
    }

    static let sql = """
        -- long-running-queries
        SELECT
          pid,
          now() - pg_stat_activity.query_start AS duration,
          query AS query
        FROM
          pg_stat_activity
        WHERE
          pg_stat_activity.query <> ''::text
          AND state <> 'idle'
          AND now() - pg_stat_activity.query_start > interval '5 minutes'
        ORDER BY
          now() - pg_stat_activity.query_start DESC
        """
}
