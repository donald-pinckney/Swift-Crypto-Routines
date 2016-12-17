//
//  Matrix.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

struct MatrixRing<F: Field>: Ring {
    typealias Matrix = [F]
    typealias Element = Matrix

    // Group
    let additiveIdentity: Matrix = []
    func add(_ x: Matrix, _ y: Matrix) -> Matrix {
        return []
    }
    func additiveInverse(_ x: Matrix) -> Matrix {
        return []
    }
    
    
    // Ring
    let multiplicativeIdentity: Matrix = []
    func multiply(_ x: Matrix, _ y: Matrix) -> Matrix {
        return []
    }
}
