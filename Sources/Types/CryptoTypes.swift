public typealias Byte = UInt8
public typealias ByteString = [Byte]

// E: K x M -> C
public typealias BlockCipher = (ByteString, ByteString) -> ByteString
