import Foundation

func FF1_modified(blockCipher CIPH: BlockCipher, key: ByteString, radix: Int, plainText X: [UInt], tweak T: ByteString) -> [UInt] {

    // Given values
    let PRF = curryLeft(CBC_MAC, value: CIPH)
    let t = T.count
    let n = X.count

    // Step 1.
    let u = n / 2
    let v = n - u

    // Step 2.
    var A = X[0..<u].copy()
    var B = X[u..<n].copy()

    // Step 3.
    let l = Int(floor(32 / log2(radix)))

    // Step 4.
    let b = Int(ceil(ceil(Double(l) * log2(radix)) / 8))

    // Step 5.
    let d = 4 * Int(ceil(Double(b) / 4)) + 4

    // Step 6.
    let P = represent(1, inBytes: 1) 
            || represent(2, inBytes: 1) 
            || represent(1, inBytes: 1) 
            || represent(radix, inBytes: 3) 
            || represent(10, inBytes: 1) 
            || represent(mod(u, 256), inBytes: 1) 
            || represent(n, inBytes: 4) 
            || represent(t, inBytes: 4)

    // Step 7.
    for i in 0...9 {
        // Step 7i.
        let (m_A, m_B) = i % 2 == 0 ? (u, v) : (v, u)

        // Step 7ii.
        let L = Int(ceil(Double(m_A) / Double(l)))

        // Step 7iii.
        let L_B = Int(ceil(Double(m_B) / Double(l)))

        // Step 7iv.
        var B_bytes: ByteString = []
        for j in 0...(L_B-1) {
        	let chunk = B[(j*l)..<min((j+1)*l, m_B)].copy()
        	B_bytes += represent(num(chunk, forRadix: radix), inBytes: b)
        }

        // Step 7v.
        let Q = T 
                || represent(0, inBytes: mod(-t-L*b-1, 16)) 
                || represent(i, inBytes: 1) 
                || B_bytes
        
        // Step 7vi.
        let R = PRF(key, P || Q)

        // Step 7vii.
        let maxSblock = Int(ceil(Double(L*d) / 16)) - 1
        let S_whole: ByteString
        if maxSblock >= 1 {
            let S_blocks = (1...maxSblock).map { j in CIPH(key, R ^ represent(j, inBytes: 16)) }
            S_whole = R || S_blocks.reduce([], ||)
        } else {
            S_whole = R
        }
        let S = S_whole[0..<(L*d)].copy()

        // Step 7viii.
        var C = [UInt](repeating: 0, count: A.count)

        // Step 7ix.
        for j in 1...L {
        	// Step 7ixa.
        	let U = S[((j-1)*d)..<(j*d)].copy()

        	// Step 7ixb.
        	let y = num(U)

        	// Step 7ixc.
        	let A_chunk = A[((j-1)*l)..<min(j*l, m_A)].copy()

        	// Step 7ixd.
        	let m = A_chunk.count

        	// Step 7ixe.
        	let c = (num(A_chunk, forRadix: radix) + y) % (radix ** m)

        	// Step 7ixf.
        	C.replaceSubrange(((j-1)*l)..<min(j*l, m_A), with: str(num: c, forRadix: radix, length: m))
        }

        // Step 7x.
        A = B

        // Step 7xi.
        B = C
    }

    // Step 8.
    return A || B
}


