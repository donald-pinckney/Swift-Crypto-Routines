//
//  Group.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

protocol Group {
    associatedtype Element
    
    // It must be that additiveIdentity + x = x, x + additiveIdentity = x, for all x.
    var additiveIdentity: Element { get }
    
    // Add must be associative.
    func add(_ x: Element, _ y: Element) -> Element
    
    // additiveInverse must be that x + (-x) = (-x) + x = additiveIdentity
    func additiveInverse(_ x: Element) -> Element
}

protocol AbelianGroup: Group {
    // add(x, y) MUST be commutative.
}
