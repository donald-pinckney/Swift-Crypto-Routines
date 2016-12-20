//
//  AESHelpers.swift
//  Swift Crypto Routines
//
//  Created by Donald Pinckney on 12/19/16.
//
//

import Types
import Algebra

internal let AES_irreduciblePolynomial: Byte = 0x1b
internal let AES_field = ByteField(irreduciblePolynomial: AES_irreduciblePolynomial)
internal let AES_stateFamily: MatrixFamily = MatrixFamily(ring: AES_field)


typealias Word = (Byte, Byte, Byte, Byte)

internal func ^(x: Word, y: Word) -> Word {
    return (x.0 ^ y.0, x.1 ^ y.1, x.2 ^ y.2, x.3 ^ y.3)
}



internal func subByte(_ b: Byte) -> Byte {
    let inv = b == 0x00 ? 0x00 : AES_field.multiplicativeInverse(b)
    
    // Copy it so we don't modify the original
    var res = inv
    
    let c: Byte = 0b0110_0011
    
    for i: Byte in 0..<8 {
        res ^= (0b0000_0001 & ((inv >> ((i+4) % 8)) ^ (inv >> ((i+5) % 8)) ^ (inv >> ((i+6) % 8)) ^ (inv >> ((i+7) % 8)) ^ (c >> i))) << i
    }
    return res
}
