//
//  AES128.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/17/16.
//
//

func keySchedule(_ key: ByteString) -> [ByteString] {
    return [key] // TODO: Implement me!
}

func AES128(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    // Verify we have correctly sized key / plaintext
    precondition(key.count == 16)
    precondition(plainText.count == 16)
    
    let irreduciblePolynomial: Byte = 0x1b
    let field = ByteField(irreduciblePolynomial: irreduciblePolynomial)
    let stateFamily = MatrixFamily(ring: field)
    
    let keys = keySchedule(key) // count == 11
    
    var state = stateFamily.dataMatrix(width: 4, data: plainText).transpose()
    
    
    
    
    
    
    return state.transpose().data
}

