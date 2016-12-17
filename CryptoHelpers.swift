import Foundation

private func represent(_ x: UInt, inBytes: UInt) -> ByteString {
    let mask1: UInt = 0xFF00000000000000
    let mask2: UInt = 0x00FF000000000000
    let mask3: UInt = 0x0000FF0000000000
    let mask4: UInt = 0x000000FF00000000
    let mask5: UInt = 0x00000000FF000000
    let mask6: UInt = 0x0000000000FF0000
    let mask7: UInt = 0x000000000000FF00
    let mask8: UInt = 0x00000000000000FF
    let masks = [mask8, mask7, mask6, mask5, mask4, mask3, mask2, mask1]
    let bytes: ByteString = masks.enumerated().map { Byte(($0.element & x) >> UInt(8*$0.offset)) }[0..<min(Int(inBytes), 8)].reversed()
    
    if inBytes > 8 {
        return ByteString(repeating: 0, count: Int(inBytes - 8)) + bytes
    }
    return bytes
}

// func represent(_ x: Int, inBytes: UInt) -> ByteString {
//     precondition(x >= 0)
//     return represent(UInt(x), inBytes: inBytes)
// }

func represent(_ x: Int, inBytes: Int) -> ByteString {
    precondition(x >= 0 && inBytes >= 0)
    return represent(UInt(x), inBytes: UInt(inBytes))
}

func represent(_ x: UInt, inBytes: Int) -> ByteString {
    precondition(inBytes >= 0)
    return represent(x, inBytes: UInt(inBytes))
}






func num(_ X: ByteString) -> UInt {
    var sum: UInt = 0
    for x in X {
        sum = 256*sum + UInt(x)
    }
    return sum
}




// Fixed positive mod function
func mod(_ x: Int, _ m: UInt) -> Int {
    let md = x % Int(m)
    if md >= 0 {
        return md
    } else {
        return Int(m) + md
    }
}


// func mod(_ x: UInt, _ m: UInt) -> UInt {
//     return x % m
// }

func log2(_ x: UInt) -> Double {
    return log2(Double(x))
}

func log2(_ x: Int) -> Double {
    precondition(x >= 0)
    return log2(UInt(x))
}
