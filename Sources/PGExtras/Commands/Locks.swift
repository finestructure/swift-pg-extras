import ArgumentParser
import TextTable


struct Locks: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension Locks: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (Int, String, Int, String, String, String)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "PID", value: $0),
                Column(title: "Table", value: $1),
                Column(title: "Transaction ID", value: $2),
                Column(title: "Granted", value: $3),
                Column(title: "Query", value: $4),
                Column(title: "Age", value: $5),

            ]
        }
    }

    static let sql = """
        -- locks
          SELECT
            pg_stat_activity.pid,
            pg_class.relname,
            pg_locks.transactionid,
            pg_locks.granted,
            pg_stat_activity.query AS query_snippet,
            age(now(),pg_stat_activity.query_start) AS "age"
          FROM pg_stat_activity,pg_locks left
          OUTER JOIN pg_class
            ON (pg_locks.relation = pg_class.oid)
          WHERE pg_stat_activity.query <> '<insufficient privilege>'
            AND pg_locks.pid = pg_stat_activity.pid
            AND pg_locks.mode = 'ExclusiveLock'
            AND pg_stat_activity.pid <> pg_backend_pid() order by query_start
        """
}

