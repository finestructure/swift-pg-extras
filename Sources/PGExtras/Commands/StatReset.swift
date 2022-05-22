import ArgumentParser
import TextTable


struct StatReset: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.runQuery(credentials: options.credentials)
        print("pg_stat has been reset.")
    }
}



extension StatReset: PGExtrasCommand {
    struct Row: TableRow {
        typealias Values = (String, String?, Int)

        var values: Values

        static let table = TextTable<Row.Values> { _ in [] }
    }

    static let sql = """
        -- stat-reset
        select pg_stat_reset()
        """
}
