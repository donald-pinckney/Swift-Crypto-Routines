//
//  Group.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

public protocol Group {
    associatedtype Element
    
    // It must be that additiveIdentity + x = x, x + additiveIdentity = x, for all x.
    var additiveIdentity: Element { get }
    
    // Add must be associative.
    func add(_ x: Element, _ y: Element) -> Element
    
    // additiveInverse must be that x + (-x) = (-x) + x = additiveIdentity
    func additiveInverse(_ x: Element) -> Element
    
    func equal(lhs: Element, rhs: Element) -> Bool // Because Swift's type system is mature enough to put a : Equatable constraint on Element.
}

public extension Group where Element: Equatable {
    func equal(lhs: Element, rhs: Element) -> Bool {
        return lhs == rhs
    }
}


public protocol AbelianGroup: Group {
    // add(x, y) MUST be commutative.
}

// Any group has a natural definition for integer multiplication
public extension Group {
    func integerMultiply(_ x: Element, _ n: Int) -> Element {
        var y = self.additiveIdentity
        for _ in 0..<n {
            y = self.add(y, x)
        }
        return y
    }
}
