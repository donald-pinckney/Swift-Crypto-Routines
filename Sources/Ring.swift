//
//  Ring.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

protocol Ring: AbelianGroup {
    
    // It must be that multiplicativeIdentity * x = x * multiplicativeIdentity = x, for all x.
    var multiplicativeIdentity: Element { get }
    
    // Multiply must be associative, and distributive over addition: a*(b+c) = (a*b) + (a*c)
    func multiply(_ x: Element, _ y: Element) -> Element
}

// Any ring has a natural definition for integer exponentiation
extension Ring {
    func integerExponentiate(_ x: Element, _ p: Int) -> Element {
        var y = self.multiplicativeIdentity
        for _ in 0..<p {
            y = self.multiply(y, x)
        }
        return y
    }
}
