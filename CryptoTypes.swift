typealias Byte = UInt8
typealias ByteString = [Byte]

// E: K x M -> C
typealias BlockCipher = (ByteString, ByteString) -> ByteString
