import ArgumentParser
import PostgresNIO
import Foundation


struct CacheHit: AsyncParsableCommand {
    func run() async throws {
        print("cache hit")

        let config = PostgresConnection.Configuration(
            connection: .init(
                host: "localhost",
                port: 6432
            ),
            authentication: .init(
                username: "spi_dev",
                database: "spi_dev",
                password: "xxx"
            ),
            tls: .disable
        )

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
                print(name, ratio)
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
