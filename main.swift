let key: ByteString = [0x2B, 0x7E, 0x15, 0x16, 0x28, 0xAE, 0xD2, 0xA6, 0xAB, 0xF7, 0x15, 0x88, 0x09, 0xCF, 0x4F, 0x3C]
let radix = 10

let X: [UInt] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7]
let T: ByteString = []

// let C1 = FF1(blockCipher: AES128, key: key, radix: radix, plainText: X, tweak: T)
let C2 = FF1_modified(blockCipher: AES128, key: key, radix: radix, plainText: X, tweak: T)
// print(C1)
print(C2)