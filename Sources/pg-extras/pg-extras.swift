import ArgumentParser
import PGExtras


@main
public struct PGExtras: AsyncParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "PG Extras",
        subcommands: [
            CacheHit.self,
            Bloat.self,
            Blocking.self,
            IndexSize.self,
            IndexUsage.self,
            Locks.self,
            LongRunningQueries.self,
            RecordsRank.self,
            SeqScans.self,
            StatReset.self,
            TableIndexesSize.self,
            TableSize.self,
            TotalIndexSize.self,
            TotalTableSize.self,
            UnusedIndexes.self,
            VacuumStats.self
        ]
    )

    public init() { }

    public func run() async throws { }
}
