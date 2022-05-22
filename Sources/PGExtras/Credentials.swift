import Foundation

import ArgumentParser


struct Credentials: ExpressibleByArgument, Decodable {
    var host: String
    var port: Int
    var username: String
    var database: String
    var password: String
    var tls: TLS? = .disable

    init?(argument: String) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: argument)),
              let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = decoded
    }

    enum TLS: String, Decodable {
        case disable
        case require
    }
}
