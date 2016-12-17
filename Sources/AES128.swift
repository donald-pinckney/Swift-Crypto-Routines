//
//  AES128.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/17/16.
//
//

private let irreduciblePolynomial: Byte = 0x1b
private let field = ByteField(irreduciblePolynomial: irreduciblePolynomial)
private let stateFamily = MatrixFamily(ring: field)

typealias Word = (Byte, Byte, Byte, Byte)

func keySchedule(_ key: ByteString) -> [Word] {
    return [(key[0], key[0], key[0], key[0])] // TODO: Implement me!
}



func AES128(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    let Nb = 4
    let Nr = 10
    
    // Verify we have correctly sized key / plaintext
    precondition(key.count == 16)
    precondition(plainText.count == 16)
    

    
    let keys = keySchedule(key) // count == Nb*(Nr+1)
    
    var state = stateFamily.dataMatrix(width: 4, data: plainText).transpose()
    
    state = addRoundKey(state, keys[0...(Nb-1)])
    
    for round in 1...(Nr-1) {
        state = subBytes(state)
        state = shiftRows(state)
        state = mixColumns(state)
        state = addRoundKey(state, keys[(round*Nb)...((round+1)*Nb-1)])
    }
    
    state = subBytes(state)
    state = shiftRows(state)
    state = addRoundKey(state, keys[(Nr*Nb)...((Nr+1)*Nb-1)])
    
    
    return state.transpose().data
}

