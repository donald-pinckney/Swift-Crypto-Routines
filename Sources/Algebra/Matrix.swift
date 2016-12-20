//
//  Matrix.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/16/16.
//
//

import Utils

public struct MatrixFamily<R: Ring> {
    public let ring: R

    public init(ring: R) {
        self.ring = ring
    }
    
    public func zeroMatrix(width: Int, height: Int) -> Matrix<R> {
        return Matrix(family: self, width: width, data: Array(repeating: ring.additiveIdentity, count: width*height))
    }
    
    public func identityMatrix(n: Int) -> Matrix<R> {
        var zeros = zeroMatrix(width: n, height: n)
        
        for i in 0..<n {
            zeros[i, i] = ring.multiplicativeIdentity
        }
        return zeros
    }
    
    public func dataMatrix(width: Int, data: [R.Element]) -> Matrix<R> {
        return Matrix(family: self, width: width, data: data)
    }
}

public struct Matrix<R: Ring> {
    public let family: MatrixFamily<R>
    public let width: Int
    public let height: Int
    public var data: [R.Element]

    internal init(family: MatrixFamily<R>, width: Int, data: [R.Element]) {
        self.family = family
        self.width = width
        self.data = data
        height = data.count / width
    }

    public subscript(row: Int, column: Int) -> R.Element {
        get {
            return data[width*row + column]
        }
        set(val) {
            data[width*row + column] = val
        }
    }
    
    public subscript(rows: Range<Int>, columns: Range<Int>) -> Matrix<R> {
        get {
            let width = columns.count
            var values: [R.Element] = []
            for i in rows.lowerBound..<rows.upperBound {
                for j in columns.lowerBound..<columns.upperBound {
                    values.append(self[i, j])
                }
            }
            return Matrix(family: family, width: width, data: values)
        }
        set(subMatrix) {
            precondition(rows.count == subMatrix.height)
            precondition(columns.count == subMatrix.width)
            
            for r in rows.lowerBound..<rows.upperBound {
                let subR = r - rows.lowerBound
                
                for c in columns.lowerBound..<columns.upperBound {
                    let subC = c - columns.lowerBound
                    
                    self[r, c] = subMatrix[subR, subC]
                }
            }
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: Range<Int>) -> Matrix<R> {
        get {
            return self[Range(rows), columns]
        }
        set(m) {
            self[Range(rows), columns] = m
        }
    }
    public subscript(rows: Range<Int>, columns: ClosedRange<Int>) -> Matrix<R> {
        get {
            return self[rows, Range(columns)]
        }
        set(m) {
            self[rows, Range(columns)] = m
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: ClosedRange<Int>) -> Matrix<R> {
        get {
            return self[Range(rows), Range(columns)]
        }
        set(m) {
            self[Range(rows), Range(columns)] = m
        }
    }
    
    
    

    
    public static func +(_ x: Matrix<R>, _ y: Matrix<R>) -> Matrix<R> {
        let elements = componentWiseExtend(x.family.ring.add)(x.data, y.data)
        return Matrix(family: x.family, width: x.width, data: elements)
    }
    public static prefix func -(_ x: Matrix<R>) -> Matrix<R> {
        let elements = x.data.map(x.family.ring.additiveInverse)
        return Matrix(family: x.family, width: x.width, data: elements)
    }
    
    public func transpose() -> Matrix<R> {
        var result = family.zeroMatrix(width: height, height: width)
        for i in 0..<result.height {
            for j in 0..<result.width {
                result[i, j] = self[j, i]
            }
        }
        return result
    }
    
    public static func *(_ x: Matrix<R>, _ y: Matrix<R>) -> Matrix<R> {
        var result = x.family.zeroMatrix(width: y.width, height: x.height)
        
        for i in 0..<result.height { // i is row
            for j in 0..<result.width { // j is column
                var sum = x.family.ring.additiveIdentity
                for k in 0..<x.width {
                    sum = x.family.ring.add(sum, x.family.ring.multiply(x[i, k], y[k, j]))
                }
                
                result[i, j] = sum
            }
        }
        return result
    }
}

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        guard lhs.width == rhs.width && lhs.height == rhs.height else {
            return false
        }
        
        for i in 0..<lhs.data.count {
            let x = lhs.data[i]
            let y = rhs.data[i]
            if lhs.family.ring.equal(lhs: x, rhs: y) == false {
                return false
            }
        }
        return true
    }
}
