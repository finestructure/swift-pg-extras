import TextTable


protocol TableRow {
    associatedtype Values

    var values: Values { get }

    static var table: TextTable<Self.Values> { get }
}
