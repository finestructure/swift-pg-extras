import ArgumentParser
import TextTable


struct VacuumStats: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        try await Self.run(Row.Values.self,
                           credentials: options.credentials,
                           Row.init)
    }
}



extension VacuumStats: PGExtrasCommand {
    struct Row: PGExtrasCommandRow {
        typealias Values = (String, String, String?, String?, String, String, String, String?)

        var values: Values

        static let table = TextTable<Row.Values> {
            [
                Column(title: "Schema", value: $0),
                Column(title: "Table", value: $1),
                Column(title: "Last Vacuum", value: $2 ?? "NULL", align: .center),
                Column(title: "Last Autovacuum", value: $3 ?? "NULL", align: .center),
                Column(title: "Row Count", value: $4),
                Column(title: "Dead Row Count", value: $5),
                Column(title: "Autovacuum Thresh.", value: $6),
                Column(title: "Expect Autovacuum", value: $7 ?? "NULL", align: .center),

            ]
        }
    }

    static let sql = """
        -- vacuum-stats
        WITH table_opts AS (
          SELECT
            pg_class.oid, relname, nspname, array_to_string(reloptions, '') AS relopts
          FROM
             pg_class INNER JOIN pg_namespace ns ON relnamespace = ns.oid
        ), vacuum_settings AS (
          SELECT
            oid, relname, nspname,
            CASE
              WHEN relopts LIKE '%autovacuum_vacuum_threshold%'
                THEN substring(relopts, '.*autovacuum_vacuum_threshold=([0-9.]+).*')::integer
                ELSE current_setting('autovacuum_vacuum_threshold')::integer
              END AS autovacuum_vacuum_threshold,
            CASE
              WHEN relopts LIKE '%autovacuum_vacuum_scale_factor%'
                THEN substring(relopts, '.*autovacuum_vacuum_scale_factor=([0-9.]+).*')::real
                ELSE current_setting('autovacuum_vacuum_scale_factor')::real
              END AS autovacuum_vacuum_scale_factor
          FROM
            table_opts
        )
        SELECT
          vacuum_settings.nspname AS schema,
          vacuum_settings.relname AS table,
          to_char(psut.last_vacuum, 'YYYY-MM-DD HH24:MI') AS last_vacuum,
          to_char(psut.last_autovacuum, 'YYYY-MM-DD HH24:MI') AS last_autovacuum,
          to_char(pg_class.reltuples, '9G999G999G999') AS rowcount,
          to_char(psut.n_dead_tup, '9G999G999G999') AS dead_rowcount,
          to_char(autovacuum_vacuum_threshold
               + (autovacuum_vacuum_scale_factor::numeric * pg_class.reltuples), '9G999G999G999') AS autovacuum_threshold,
          CASE
            WHEN autovacuum_vacuum_threshold + (autovacuum_vacuum_scale_factor::numeric * pg_class.reltuples) < psut.n_dead_tup
            THEN 'yes'
          END AS expect_autovacuum
        FROM
          pg_stat_user_tables psut INNER JOIN pg_class ON psut.relid = pg_class.oid
            INNER JOIN vacuum_settings ON pg_class.oid = vacuum_settings.oid
        ORDER BY 1
        """
}

