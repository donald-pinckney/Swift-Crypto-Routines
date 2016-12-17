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

protocol Ring: AbelianGroup {
    
    // It must be that multiplicativeIdentity * x = x * multiplicativeIdentity = x, for all x.
    var multiplicativeIdentity: Element { get }
    
    // Multiply must be associative, and distributive over addition: a*(b+c) = (a*b) + (a*c)
    func multiply(_ x: Element, _ y: Element) -> Element
}

protocol Field: Ring {
    // multiplicativeInverse must be that x * (x^-1) = (x^-1) * x = multiplicativeIdentity, for all x not equal to additiveIdentity
    func multiplicativeInverse(_ x: Element) -> Element
}

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
        return []
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
        return 0x00
    }
}


let irreduciblePolynomial1 = [1, 1, 0, 1, 1, 0, 0, 0]
let irreduciblePolynomial2 = 0b1101_1000

let GF256 = FiniteField(p: 2, irreduciblePolynomial: [1, 1, 0, 1, 1, 0, 0, 0])
print(GF256.multiply([1, 1, 1, 0, 1, 0, 1, 0], [1, 1, 0, 0, 0, 0, 0, 1]))

