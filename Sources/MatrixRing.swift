//
//  Matrix.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

struct MatrixRing<R: Ring>: Ring {
    let ring: R
    let n: Int
    typealias Matrix = [R.Element]
    typealias Element = Matrix

    init(ring: R, n: Int) {
        self.n = n
        self.ring = ring
        additiveIdentity = Array(repeating: ring.additiveIdentity, count: n*n)
        
        var I = additiveIdentity
        for i in 0..<n {
            I[n*i + i] = ring.multiplicativeIdentity
        }
        multiplicativeIdentity = I
    }
    
    // Group
    let additiveIdentity: Matrix
    func add(_ x: Matrix, _ y: Matrix) -> Matrix {
        return componentWiseExtend(ring.add)(x, y)
    }
    func additiveInverse(_ x: Matrix) -> Matrix {
        return x.map(ring.additiveInverse)
    }
    
    
    // Ring
    let multiplicativeIdentity: Matrix
    func multiply(_ x: Matrix, _ y: Matrix) -> Matrix {
        var result = additiveIdentity
        
        for i in 0..<n { // i is row
            for j in 0..<n { // j is column
                var sum = ring.additiveIdentity
                for k in 0..<n {
                    sum = ring.add(sum, ring.multiply(x[i*n + k], y[k*n + j]))
                }
                
                result[i*n + j] = sum
            }
        }
        return result
    }
}
