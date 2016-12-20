//
//  AES.swift
//  Swift Crypto Routines
//
//  Created by Donald Pinckney on 12/17/16.
//
//

import Types
import Utils

private func AES(_ key: ByteString, _ plainText: ByteString, Nb: Int, Nk: Int, Nr: Int) -> ByteString {

    // Verify we have correctly sized plain text and key
    precondition(plainText.count == Nb * 4)
    precondition(key.count == Nk * 4)

    
    let keys = AES_keySchedule(key, Nb: Nb, Nk: Nk, Nr: Nr) // count == Nb*(Nr+1)
    
    var state = AES_stateFamily.dataMatrix(width: Nb, data: plainText).transpose()

    state = addRoundKey(state, keys[0...(Nb-1)])
    
    for round in 1...(Nr-1) { // NR-1 rounds here
        state = subBytes(state)
        state = shiftRows(state)
        state = mixColumns(state)
        state = addRoundKey(state, keys[(round*Nb)...((round+1)*Nb-1)])
    }
    
    // Last round here
    state = subBytes(state)
    state = shiftRows(state)
    state = addRoundKey(state, keys[(Nr*Nb)...((Nr+1)*Nb-1)])
    
    
    return state.transpose().data
}

public func AES128(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    return AES(key, plainText, Nb: 4, Nk: 4, Nr: 10)
}

public func AES192(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    return AES(key, plainText, Nb: 4, Nk: 6, Nr: 12)
}

public func AES256(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    return AES(key, plainText, Nb: 4, Nk: 8, Nr: 14)
}
