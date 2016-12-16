import Foundation

func FF1(blockCipher E: BlockCipher, key: ByteString, radix: Int, plainText X: [UInt], tweak T: ByteString) -> [UInt] {

    // Given values
    let AES_CBC_MAC = curryLeft(CBC_MAC, value: E)
    let t = T.count
    let n = X.count

    // Step 1.
    let u = n / 2
    let v = n - u

    // Step 2.
    var A = X[0..<u].copy()
    var B = X[u..<n].copy()

    // Step 3.
    let b = Int(ceil(ceil(Double(v) * log2(radix)) / 8))

    // Step 4.
    let d = 4 * Int(ceil(Double(b) / 4)) + 4

    // Step 5.
    let P = represent(1, inBytes: 1) 
            || represent(2, inBytes: 1) 
            || represent(1, inBytes: 1) 
            || represent(radix, inBytes: 3) 
            || represent(10, inBytes: 1) 
            || represent(mod(u, 256), inBytes: 1) 
            || represent(n, inBytes: 4) 
            || represent(t, inBytes: 4)

    // Step 6.
    for i in 0...9 {
        // Step 6i.
        let Q = T 
                || represent(0, inBytes: mod(-t-b-1, 16)) 
                || represent(i, inBytes: 1) 
                || represent(num(B, forRadix: radix), inBytes: b) // UInt
        
        // Step 6ii.
        let R = AES_CBC_MAC(key, P || Q)

        // Step 6iii.
        let maxSblock = Int(ceil(Double(d) / 16)) - 1
        let S_whole: ByteString
        if maxSblock >= 1 {
            let S_blocks = (1...maxSblock).map { j in AES128(key, R ^ represent(j, inBytes: 16)) }
            S_whole = R || S_blocks.reduce([], ||)
        } else {
            S_whole = R
        }
        let S = S_whole[0..<d].copy()

        // Step 6iv.
        let y = num(S) // UInt

        // Step 6v.
        let m = (i % 2 == 0) ? u : v
        
        // Step 6vi.
        let c = (num(A, forRadix: radix) + y) % (radix ** m)// UInt

        // Step 6vii.
        let C = str(num: c, forRadix: radix, length: m)

        // Step 6viii.
        A = B

        // Step 6ix.
        B = C
    }

    return A || B
}


