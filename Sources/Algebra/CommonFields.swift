//
//  CommonFields.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

import Types
import Utils

// Field isomorphic to GF(p^n), with p prime.
public struct FiniteField: Field {
    // Represented by polynomials, with coefficients in arrays.
    // The value at index i corresponds to the coefficient for x^i.
    // Every array will have length n.
    public typealias Coefficient = IntMod.Element
    public typealias Element = [Coefficient]
    public typealias Polynomial = Element
    
    let coefficientMod: IntMod
    let irreduciblePolynomial: Polynomial
    let n: Int
    
    // p MUST be prime
    // Note that n in p^n is implicit from the irreduciblePolynomial, since it must have degree n-1.
    // Implicit is that x^n = -irreduciblePolynomial
    public init(p: Int, irreduciblePolynomial: Polynomial) {
        coefficientMod = IntMod(n: p)
        self.irreduciblePolynomial = irreduciblePolynomial
        n = irreduciblePolynomial.count
    }
    
    
    // Group
    public var additiveIdentity: Polynomial { return Polynomial(repeating: coefficientMod.additiveIdentity, count: n) }
    public func add(_ x: Polynomial, _ y: Polynomial) -> Polynomial {
        return componentWiseExtend(coefficientMod.add)(x, y)
    }
    public func additiveInverse(_ x: Polynomial) -> Polynomial {
        return x.map(coefficientMod.additiveInverse)
    }
    
    // Ring
    public var multiplicativeIdentity: Polynomial { return [coefficientMod.multiplicativeIdentity] + Polynomial(repeating: coefficientMod.additiveIdentity, count: n-1) }
    
    private func cmult(_ x: Polynomial, _ c: Coefficient) -> Polynomial {
        return x.map(curryLeft(coefficientMod.multiply, value: c))
    }
    
    private func xmult(_ x: Polynomial) -> Polynomial {
        let shifted = [coefficientMod.additiveIdentity] + x.dropLast()
        return add(shifted, cmult(additiveInverse(irreduciblePolynomial), x.last!))
    }
    
    public func multiply(_ px: Polynomial, _ qx: Polynomial) -> Polynomial {
        // Compute x^k * px
        var xMults: [Polynomial] = [px]
        for _ in 1..<n {
            xMults.append(xmult(xMults.last!))
        }
        
        // Compute q_k * x^k * px
        let terms = xMults.enumerated().map { (i, pxxn) in cmult(pxxn, qx[i]) }
        
        // Add up all the terms
        return terms.reduce(additiveIdentity, add)
    }
    
    
    public func equal(lhs: [Coefficient], rhs: [Coefficient]) -> Bool {
        return lhs == rhs
    }
    
    public func multiplicativeInverse(_ x: [Coefficient]) -> [Coefficient] {
        fatalError("Implement me!")
    }
}


// Field isomorphic to GF(2^8), but optimized to be implemented with bytes.
public class ByteField: Field {
    public typealias Element = Byte
    
    let irreduciblePolynomial: Byte
    
    public init(irreduciblePolynomial: Byte) {
        self.irreduciblePolynomial = irreduciblePolynomial
    }
    
    
    // Group
    public var additiveIdentity: Byte { return 0x00 }
    public func add(_ x: Byte, _ y: Byte) -> Byte {
        return x ^ y
        
    }
    public func additiveInverse(_ x: Byte) -> Byte {
        return x
    }
    
    // Ring
    public var multiplicativeIdentity: Byte { return 0x01 }
    
    
    private func xmult(_ x: Byte) -> Byte {
        let shifted = x << 1
        let result: Byte
        if x & 0b1000_0000 == 0 {
            result = shifted
        } else {
            result = shifted ^ irreduciblePolynomial
        }
        return result
    }
    
    public func multiply(_ px: Byte, _ qx: Byte) -> Byte {
        var px = px
        var qx = qx
        
        var result = additiveIdentity
        
        while qx != 0 {
            if qx & 0b0000_0001 != 0 {
                result = add(result, px)
            }
            px = xmult(px)
            qx = qx >> 1
        }
        
        return result
    }
    
    private var inverseTable: [Byte] = Array(repeating: 0x00, count: 256)
    public func multiplicativeInverse(_ x: Byte) -> Byte {
        let idx = Int(x)
        if inverseTable[idx] != 0 {
            return inverseTable[idx]
        }
        
        for inv: Byte in 0x01...0xFF {
            if multiply(x, inv) == multiplicativeIdentity {
                inverseTable[idx] = inv
                return inv
            }
        }
        
        return 0
    }
}


