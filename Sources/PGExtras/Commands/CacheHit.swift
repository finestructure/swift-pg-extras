import ArgumentParser
import PostgresNIO
import Foundation


struct CacheHit: AsyncParsableCommand {
    @OptionGroup var options: PGExtras.Options

    func run() async throws {
        print("cache hit")

        let config = PostgresConnection.Configuration(credentials: options.credentials)

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try? eventLoopGroup.syncShutdownGracefully() }

        let logger = Logger(label: "pg-extras")

        let conn = try await PostgresConnection.connect(on: eventLoopGroup.next(),
                                                        configuration: config,
                                                        id: 1,
                                                        logger: logger)

        do {
            let rows = try await conn.query(.init(stringLiteral: Self.sql), logger: logger)
            for try await (name, ratio) in rows.decode((String, Decimal?).self, context: .default) {
                print(name, ratio ?? "NULL")
            }
        }

        try await conn.close()
    }
}

extension CacheHit {
    static let sql = """
        -- cache-hit
        SELECT
        'index hit rate' AS name,
        (sum(idx_blks_hit)) / nullif(sum(idx_blks_hit + idx_blks_read),0) AS ratio
        FROM pg_statio_user_indexes
        UNION ALL
        SELECT
        'table hit rate' AS name,
        sum(heap_blks_hit) / nullif(sum(heap_blks_hit) + sum(heap_blks_read),0) AS ratio
        FROM pg_statio_user_tables
        """

}


extension PostgresConnection.Configuration {
    init(credentials: PGExtras.Credentials) {
        self.init(
            connection: .init(
                host: credentials.host,
                port: credentials.port
            ),
            authentication: .init(
                username: credentials.username,
                database: credentials.database,
                password: credentials.password
            ),
            tls: .disable
//            tls: .require(.init(configuration: .clientDefault))
        )
    }
}
