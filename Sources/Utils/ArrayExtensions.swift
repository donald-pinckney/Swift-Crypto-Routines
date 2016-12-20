public extension Array {
    static func ||(left: Array, right: Array) -> Array {
        return left + right
    }
}

public extension ArraySlice {
    static func ||(left: ArraySlice, right: ArraySlice) -> ArraySlice {
        return left + right
    }

    func copy() -> Array<Element> {
        return Array(self)
    }
}
