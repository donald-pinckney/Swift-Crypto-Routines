import Types
import Utils

public func CBC_MAC(E: BlockCipher, key: ByteString, X: ByteString) -> ByteString {
    
    let m = UInt(X.count) / 16 // 16 bytes per block
    
    var Y = ByteString(repeating: 0, count: 16) // 128 bits of 0s
    for i in 0..<m {
        let startBlock = Int(16*i)
        let endBlock = Int(16*(i+1))
        let block = Array(X[startBlock..<endBlock])
        Y = E(key, Y ^ block)
    }
    return Y
}
