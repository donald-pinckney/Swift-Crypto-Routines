//
//  AESKeySchedule.swift
//  CuteCrytpo
//
//  Created by Donald Pinckney on 12/19/16.
//
//

import Types

private func Rcon(_ i: Int) -> Word {
    return (AES_field.integerExponentiate(0x02, i-1), 0x00, 0x00, 0x00)
}

private func subWord(_ w: Word) -> Word {
    return (subByte(w.0), subByte(w.1), subByte(w.2), subByte(w.3))
}

private func rotWord(_ w: Word) -> Word {
    return (w.1, w.2, w.3, w.0)
}

internal func AES_keySchedule(_ key: ByteString, Nb: Int, Nk: Int, Nr: Int) -> [Word] {
    var w: [Word] = Array(repeating: (0, 0, 0, 0), count: Nb * (Nr + 1))
    
    
    for i in 0..<Nk {
        w[i] = (key[4*i], key[4*i + 1], key[4*i + 2], key[4*i + 3])
    }
    
    for i in Nk..<(Nb * (Nr + 1)) {
        var temp = w[i-1]
        if i % Nk == 0 {
            temp = subWord(rotWord(temp)) ^ Rcon(i/Nk)
        } else if Nk > 6 && i % Nk == 4 {
            temp = subWord(temp)
        }
        w[i] = w[i-Nk] ^ temp
    }
    
    return w
}
