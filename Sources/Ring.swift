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
