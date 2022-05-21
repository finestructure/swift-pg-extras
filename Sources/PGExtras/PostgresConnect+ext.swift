import PostgresNIO


extension PostgresConnection.Configuration {
    init(credentials: PGExtras.Credentials) throws {
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
            tls: try .init(tls: credentials.tls ?? .disable)
        )
    }
}


extension PostgresConnection.Configuration.TLS {
    init(tls: PGExtras.Credentials.TLS) throws {
        switch tls {
            case .disable:
                self = .disable
            case .require:
                self = try .require(.init(configuration: .clientDefault))
        }
    }
}
