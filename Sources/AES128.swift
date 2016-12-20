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

func ^(x: Word, y: Word) -> Word {
    return (x.0 ^ y.0, x.1 ^ y.1, x.2 ^ y.2, x.3 ^ y.3)
}

let Nb = 4
let Nk = 4
let Nr = 10

func Rcon(_ i: Int) -> Word {
    return (field.integerExponentiate(0x02, i-1), 0x00, 0x00, 0x00)
}



func subByte(_ b: Byte) -> Byte {
    let inv = b == 0x00 ? 0x00 : field.multiplicativeInverse(b)
    
    // Copy it so we don't modify the original
    var res = inv
    
    let c: Byte = 0b0110_0011
    
    for i: Byte in 0..<8 {
        res ^= (0b0000_0001 & ((inv >> ((i+4) % 8)) ^ (inv >> ((i+5) % 8)) ^ (inv >> ((i+6) % 8)) ^ (inv >> ((i+7) % 8)) ^ (c >> i))) << i
    }
    return res
}

func subWord(_ w: Word) -> Word {
    return (subByte(w.0), subByte(w.1), subByte(w.2), subByte(w.3))
}

func rotWord(_ w: Word) -> Word {
    return (w.1, w.2, w.3, w.0)
}

func keySchedule(_ key: ByteString) -> [Word] {
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


func subBytes(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    var res = state
    for i in 0..<state.width {
        for j in 0..<state.height {
            res[j, i] = subByte(res[j, i])
        }
    }
    return res
}

func addRoundKey(_ state: Matrix<ByteField>, _ key: ArraySlice<Word>) -> Matrix<ByteField> {
    var res = state
    
    for c in 0..<Nb {
        let w = key[key.startIndex + c]
        res[0, c] ^= w.0
        res[1, c] ^= w.1
        res[2, c] ^= w.2
        res[3, c] ^= w.3
    }
    return res
}

func shiftRows(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    var res = state
    for r in 1..<4 {
        for c in 0..<Nb {
            res[r, c] = state[r, (c + r) % Nb]
        }
    }
    return res
}


func mixColumns(_ state: Matrix<ByteField>) -> Matrix<ByteField> {
    let mixData: [Byte] = [
        0x02, 0x03, 0x01, 0x01,
        0x01, 0x02, 0x03, 0x01,
        0x01, 0x01, 0x02, 0x03,
        0x03, 0x01, 0x01, 0x02
    ]
    let mixMatrix = Matrix(family: stateFamily, width: 4, data: mixData)
    
    var res = state
    
    for c in 0..<Nb {
        res[0..<res.height, c...c] = mixMatrix * res[0..<state.height, c...c]
    }
    return res
}


func AES128(_ key: ByteString, _ plainText: ByteString) -> ByteString {

    
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

