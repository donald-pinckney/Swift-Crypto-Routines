//
//  CommonFields.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

// Field isomorphic to GF(p^n), with p prime.
struct FiniteField: Field {
    // Represented by polynomials, with coefficients in arrays.
    // The value at index i corresponds to the coefficient for x^i.
    // Every array will have length n.
    typealias Coefficient = IntMod.Element
    typealias Element = [Coefficient]
    typealias Polynomial = Element
    
    let coefficientMod: IntMod
    let irreduciblePolynomial: Polynomial
    let n: Int
    
    // p MUST be prime
    // Note that n in p^n is implicit from the irreduciblePolynomial, since it must have degree n-1.
    // Implicit is that x^n = -irreduciblePolynomial
    init(p: Int, irreduciblePolynomial: Polynomial) {
        coefficientMod = IntMod(n: p)
        self.irreduciblePolynomial = irreduciblePolynomial
        n = irreduciblePolynomial.count
    }
    
    
    // Group
    var additiveIdentity: Polynomial { return Polynomial(repeating: coefficientMod.additiveIdentity, count: n) }
    func add(_ x: Polynomial, _ y: Polynomial) -> Polynomial {
        return zip(x, y).map(coefficientMod.add)
        
    }
    func additiveInverse(_ x: Polynomial) -> Polynomial {
        return x.map(coefficientMod.additiveInverse)
    }
    
    // Ring
    var multiplicativeIdentity: Polynomial { return [coefficientMod.multiplicativeIdentity] + Polynomial(repeating: coefficientMod.additiveIdentity, count: n-1) }
    
    private func cmult(_ x: Polynomial, _ c: Coefficient) -> Polynomial {
        return x.map { a in coefficientMod.multiply(a, c) }
    }
    
    private func xmult(_ x: Polynomial) -> Polynomial {
        let shifted = [coefficientMod.additiveIdentity] + x.dropLast()
        return add(shifted, cmult(additiveInverse(irreduciblePolynomial), x.last!))
    }
    
    func multiply(_ px: Polynomial, _ qx: Polynomial) -> Polynomial {
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
    
    func multiplicativeInverse(_ x: Polynomial) -> Polynomial {
        fatalError("TODO: Implement me!")
    }
    
}


// Field isomorphic to GF(2^8), but optimized to be implemented with bytes.
struct ByteField: Field {
    typealias Element = Byte
    
    let irreduciblePolynomial: Byte
    
    init(irreduciblePolynomial: Byte) {
        self.irreduciblePolynomial = irreduciblePolynomial
    }
    
    
    // Group
    var additiveIdentity: Byte { return 0x00 }
    func add(_ x: Byte, _ y: Byte) -> Byte {
        return x ^ y
        
    }
    func additiveInverse(_ x: Byte) -> Byte {
        return x
    }
    
    // Ring
    var multiplicativeIdentity: Byte { return 0x01 }
    
    
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
    
    func multiply(_ px: Byte, _ qx: Byte) -> Byte {
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
    
    func multiplicativeInverse(_ x: Byte) -> Byte {
        fatalError("TODO: Implement me!")
    }
}


