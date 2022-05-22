import TextTable


#warning("rename to TableRow")
protocol PGExtrasCommandRow {
    associatedtype Values

    var values: Values { get }

    static var table: TextTable<Self.Values> { get }
}
