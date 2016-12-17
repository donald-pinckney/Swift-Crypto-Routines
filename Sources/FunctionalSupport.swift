// Let f: U x V -> W.  Then, define the component-wise extension of f as:
// f': ∏U x ∏U -> ∏W, with
// f'(u1 x u2 x ... x um, v1 x v2 x ... x vn) = f(u1, v1) x f(u2, v2) x ... x f(uk, vk).
// Where k = min(m, n)
func componentWiseExtend<U, V, W>(_ f: @escaping (U, V) -> W) -> (([U], [V]) -> [W]) {
    return { (left: [U], right: [V]) in
        return zip(left, right).map(f) // Yes, zip does work with differently sized arrays.
    }
}
func componentWiseExtend<U, V>(_ f: @escaping (U) -> V) -> (([U]) -> [V]) {
    return { (left: [U]) in
        return left.map(f)
    }
}


// Lots of hard-coded currying functions
func curryLeft<A, B, C, D, E, F>(_ f: @escaping (A, B, C, D, E) -> F, value a: A) -> ((B, C, D, E) -> F) {
    return { (b, c, d, e) in
        return f(a, b, c, d, e)
    }
}
func curryLeft<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E, value a: A) -> ((B, C, D) -> E) {
    return { (b, c, d) in
        return f(a, b, c, d)
    }
}
func curryLeft<A, B, C, D>(_ f: @escaping (A, B, C) -> D, value a: A) -> ((B, C) -> D) {
    return { (b, c) in
        return f(a, b, c)
    }
}
func curryLeft<A, B, C>(_ f: @escaping (A, B) -> C, value a: A) -> ((B) -> C) {
    return { (b) in
        return f(a, b)
    }
}
func curryLeft<A, B>(_ f: @escaping (A) -> B, value a: A) -> (() -> B) {
    return { () in
        return f(a)
    }
}
