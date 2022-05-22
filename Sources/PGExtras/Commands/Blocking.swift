import ArgumentParser
import TextTable
import Foundation


struct Blocking: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}


extension Blocking: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (Int?, String?, Decimal?, Int?, String?, Decimal?)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Blocked PID", value: $0 ?? "NULL", align: .center),
                Column(title: "Blocking Stmt", value: $1 ?? "NULL"),
                Column(title: "Blocking Duration", value: $2 ?? "NULL", align: .right),
                Column(title: "Blocking PID", value: $3 ?? "NULL", align: .center),
                Column(title: "Blocked Stmt", value: $4 ?? "NULL"),
                Column(title: "Blocked Duration", value: $5 ?? "NULL", align: .right),

            ]
        }
    }

    static let sql = """
        -- blocking
        SELECT bl.pid AS blocked_pid,
          ka.query AS blocking_statement,
          now() - ka.query_start AS blocking_duration,
          kl.pid AS blocking_pid,
          a.query AS blocked_statement,
          now() - a.query_start AS blocked_duration
        FROM pg_catalog.pg_locks bl
        JOIN pg_catalog.pg_stat_activity a
          ON bl.pid = a.pid
        JOIN pg_catalog.pg_locks kl
          JOIN pg_catalog.pg_stat_activity ka
            ON kl.pid = ka.pid
        ON bl.transactionid = kl.transactionid AND bl.pid != kl.pid
        WHERE NOT bl.granted
        """
}
