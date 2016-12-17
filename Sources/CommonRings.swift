//
//  CommonRings.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//


// The integers form a ring
extension Int: Ring {
    typealias Element = Int
    
    // Group
    var additiveIdentity: Int { return 0 }
    func add(_ x: Int, _ y: Int) -> Int {
        return x + y
    }
    func additiveInverse(_ x: Int) -> Int {
        return -x
    }
    
    // Ring
    var multiplicativeIdentity: Int { return 1 }
    func multiply(_ x: Int, _ y: Int) -> Int {
        return x * y
    }
}

// Ring of Z/n, n >= 2
struct IntMod: Ring {
    typealias Element = Int // with each element such that 0 <= element < N
    
    let n: Int
    
    // Group
    let additiveIdentity = 0
    func add(_ x: Int, _ y: Int) -> Int {
        return (x + y) % n
    }
    func additiveInverse(_ x: Int) -> Int {
        return (n - x) % n
    }
    
    // Ring
    let multiplicativeIdentity = 1
    func multiply(_ x: Int, _ y: Int) -> Int {
        return (x * y) % n
    }
}
