import CommonCrypto

// This is of type BlockCipher
func AES128(_ key: ByteString, _ plainText: ByteString) -> ByteString {
    let blockSizeBytes = size_t(16)
    var cipherText = ByteString(repeating: 0, count: plainText.count)
    
    var dataOutMoved = 0
    let err = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), 0,
                      key, blockSizeBytes, nil,
                      plainText, blockSizeBytes,
                      &cipherText, blockSizeBytes, &dataOutMoved)
    
    if err != 0 || dataOutMoved != blockSizeBytes {
        fatalError("Error with AES: \(err)")
    }
    return cipherText
}
