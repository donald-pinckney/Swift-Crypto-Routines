//
//  AESSubRoutines.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/19/16.
//
//

import Types
import Algebra

internal func subBytes(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    var res = state
    for i in 0..<state.width {
        for j in 0..<state.height {
            res[j, i] = subByte(res[j, i])
        }
    }
    return res
}

internal func addRoundKey(_ state: Matrix<ByteField>, _ key: ArraySlice<Word>) -> Matrix<ByteField> {
    var res = state
    
    for c in 0..<state.width {
        let w = key[key.startIndex + c]
        res[0, c] ^= w.0
        res[1, c] ^= w.1
        res[2, c] ^= w.2
        res[3, c] ^= w.3
    }
    return res
}

internal func shiftRows(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    var res = state
    for r in 1..<4 {
        for c in 0..<state.width {
            res[r, c] = state[r, (c + r) % state.width]
        }
    }
    return res
}


internal func mixColumns(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    let mixData: [Byte] = [
        0x02, 0x03, 0x01, 0x01,
        0x01, 0x02, 0x03, 0x01,
        0x01, 0x01, 0x02, 0x03,
        0x03, 0x01, 0x01, 0x02
    ]
    // let mixMatrix = Matrix(family: state.family, width: 4, data: mixData)
    let mixMatrix = state.family.dataMatrix(width: 4, data: mixData)
    
    var res = state
    
    for c in 0..<state.width {
        res[0..<res.height, c...c] = mixMatrix * res[0..<state.height, c...c]
    }
    return res
}
