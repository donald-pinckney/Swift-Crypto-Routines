//
//  CommonRings.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//


// The integers form a ring
public struct IntRing: Ring {
    public typealias Element = Int
    
    // Group
    public let additiveIdentity = 0
    public func add(_ x: Int, _ y: Int) -> Int {
        return x + y
    }
    public func additiveInverse(_ x: Int) -> Int {
        return -x
    }
    
    // Ring
    public var multiplicativeIdentity: Int { return 1 }
    public func multiply(_ x: Int, _ y: Int) -> Int {
        return x * y
    }
}

// Ring of Z/n, n >= 2
public struct IntMod: Ring {
    public typealias Element = Int // with each element such that 0 <= element < N
    
    public let n: Int
    
    // Group
    public let additiveIdentity = 0
    public func add(_ x: Int, _ y: Int) -> Int {
        return (x + y) % n
    }
    public func additiveInverse(_ x: Int) -> Int {
        return (n - x) % n
    }
    
    // Ring
    public let multiplicativeIdentity = 1
    public func multiply(_ x: Int, _ y: Int) -> Int {
        return (x * y) % n
    }
}
