#if canImport(CoreData)
@_exported import CoreData
#endif

public final class Database: Sendable {
    public init(
        models: [any Model.Type],
        dbFileName: String
    ) {
        #if canImport(CoreData)
            fatalError("TODO")
        #else
            fatalError("TODO")
        #endif
    }

    public func select<T: Model>(
        from _: T.Type = T.self,
        orderBy sortFields: [SortItem<T>] = [],
        where predicate: (TableProxy<T>) -> ExpressionProxy<Bool>
    ) -> QueryWrapper<T> {
        return .init(db: self, sortFields: sortFields, expression: predicate(.init()))
    }
}

public enum SortDirection {
    case asc, desc
}

public struct SortItem<T: Model> {
    var keyPath: PartialKeyPath<T>
    var direction: SortDirection

    public init<U>(_ keyPath: WritableKeyPath<T, U>, direction: SortDirection = .asc) {
        self.keyPath = keyPath
        self.direction = direction
    }
}

public struct QueryWrapper<T: Model> {
    unowned var db: Database
    var sortFields: [SortItem<T>]
    var expression: ExpressionProxy<Bool>

    public func count() async -> Int64 {
        fatalError("TODO")
    }

    public func collect<C: RangeReplaceableCollection>(as _: C.Type) async -> C
    where C.Element == T {
        fatalError("TODO")
    }

    public func collect() async -> [T] {
        await collect(as: Array.self)
    }
}
