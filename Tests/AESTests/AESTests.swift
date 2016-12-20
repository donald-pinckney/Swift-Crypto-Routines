import XCTest
@testable import AES
import Types
import Algebra

private let irreduciblePolynomial: Byte = 0x1b
private let field = ByteField(irreduciblePolynomial: irreduciblePolynomial)
private let stateFamily = MatrixFamily(ring: field)

class AESTests: XCTestCase {
    

    
    func testSubByte() {
        XCTAssertEqual(subByte(0x00), 0x63)
        XCTAssertEqual(subByte(0x53), 0xed)
        XCTAssertEqual(subByte(0xe9), 0x1e)
        XCTAssertEqual(subByte(0x01), 0x7c)
        XCTAssertEqual(subByte(0xff), 0x16)
        
    }
    
    func testKeyScheduling() {
        let key: ByteString = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        
        let keys = AES_keySchedule(key, Nb: 4, Nk: 4, Nr: 10)
        
        var formattedKeys: [String] = []
        for i in stride(from: 0, to: keys.count, by: 4) {
            let w0 = keys[i]
            let w1 = keys[i+1]
            let w2 = keys[i+2]
            let w3 = keys[i+3]
            formattedKeys.append(String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        w0.0, w0.1, w0.2, w0.3,
                        w1.0, w1.1, w1.2, w1.3,
                        w2.0, w2.1, w2.2, w2.3,
                        w3.0, w3.1, w3.2, w3.3))
        }
        
        let expectedSchedule = [
            "000102030405060708090a0b0c0d0e0f",
            "d6aa74fdd2af72fadaa678f1d6ab76fe",
            "b692cf0b643dbdf1be9bc5006830b3fe",
            "b6ff744ed2c2c9bf6c590cbf0469bf41",
            "47f7f7bc95353e03f96c32bcfd058dfd",
            "3caaa3e8a99f9deb50f3af57adf622aa",
            "5e390f7df7a69296a7553dc10aa31f6b",
            "14f9701ae35fe28c440adf4d4ea9c026",
            "47438735a41c65b9e016baf4aebf7ad2",
            "549932d1f08557681093ed9cbe2c974e",
            "13111d7fe3944a17f307a78b4d2b30c5"
        ]
        XCTAssertEqual(formattedKeys, expectedSchedule)
    }
    
    func testAddRoundKey() {
        let state = stateFamily.dataMatrix(width: 4, data: [
            0x32, 0x43, 0xf6, 0xa8, 0x88, 0x5a, 0x30, 0x8d, 0x31, 0x31, 0x98, 0xa2, 0xe0, 0x37, 0x07, 0x34
        ]).transpose()
        
        let roundKey: [Word] = [(0x2b, 0x7e, 0x15, 0x16), (0x28, 0xae, 0xd2, 0xa6), (0xab, 0xf7, 0x15, 0x88), (0x09, 0xcf, 0x4f, 0x3c)]
        
        let newState = addRoundKey(state, roundKey[0..<roundKey.count])
        
        let expectedNewState = stateFamily.dataMatrix(width: 4, data: [
            0x19, 0xa0, 0x9a, 0xe9, 0x3d, 0xf4, 0xc6, 0xf8, 0xe3, 0xe2, 0x8d, 0x48, 0xbe, 0x2b, 0x2a, 0x08
        ])
        
        XCTAssertEqual(newState, expectedNewState)
    }
    
    func testSubBytes() {
        let state = stateFamily.dataMatrix(width: 4, data: [
            0x19, 0xa0, 0x9a, 0xe9, 0x3d, 0xf4, 0xc6, 0xf8, 0xe3, 0xe2, 0x8d, 0x48, 0xbe, 0x2b, 0x2a, 0x08
        ])
        let newState = subBytes(state)
        
        let expectedNewState = stateFamily.dataMatrix(width: 4, data: [
            0xd4, 0xe0, 0xb8, 0x1e, 0x27, 0xbf, 0xb4, 0x41, 0x11, 0x98, 0x5d, 0x52, 0xae, 0xf1, 0xe5, 0x30
        ])
        XCTAssertEqual(newState, expectedNewState)
    }
    
    func testShiftRows() {
        let state = stateFamily.dataMatrix(width: 4, data: [
            0xd4, 0xe0, 0xb8, 0x1e, 0x27, 0xbf, 0xb4, 0x41, 0x11, 0x98, 0x5d, 0x52, 0xae, 0xf1, 0xe5, 0x30
        ])
        let newState = shiftRows(state)
        

        let expectedNewState = stateFamily.dataMatrix(width: 4, data: [
            0xd4, 0xe0, 0xb8, 0x1e, 0xbf, 0xb4, 0x41, 0x27, 0x5d, 0x52, 0x11, 0x98, 0x30, 0xae, 0xf1, 0xe5
        ])
        XCTAssertEqual(newState, expectedNewState)
    }
    
    func testMixColumns() {
        let state = stateFamily.dataMatrix(width: 4, data: [
            0xd4, 0xe0, 0xb8, 0x1e, 0xbf, 0xb4, 0x41, 0x27, 0x5d, 0x52, 0x11, 0x98, 0x30, 0xae, 0xf1, 0xe5
        ])
        let newState = mixColumns(state)
        
        
        let expectedNewState = stateFamily.dataMatrix(width: 4, data: [
            0x04, 0xe0, 0x48, 0x28, 0x66, 0xcb, 0xf8, 0x06, 0x81, 0x19, 0xd3, 0x26, 0xe5, 0x9a, 0x7a, 0x4c
        ])
        XCTAssertEqual(newState, expectedNewState)
    }
    
    func testAES128() {
        let key: ByteString = Array(0x00...0x0f)
        let plainText: ByteString = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff]
        
        let cipherText = AES128(key, plainText)
        
        let expectedCipherText: ByteString = [0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30, 0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a]
        
        XCTAssertEqual(cipherText, expectedCipherText)
    }
    
    func testAES192() {
        let key: ByteString = Array(0x00...0x17)
        let plainText: ByteString = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff]
        
        let cipherText = AES192(key, plainText)
        
        let expectedCipherText: ByteString = [0xdd, 0xa9, 0x7c, 0xa4, 0x86, 0x4c, 0xdf, 0xe0, 0x6e, 0xaf, 0x70, 0xa0, 0xec, 0x0d, 0x71, 0x91]
        
        XCTAssertEqual(cipherText, expectedCipherText)
    }
    
    func testAES256() {
        let key: ByteString = Array(0x00...0x1f)
        let plainText: ByteString = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff]
        
        let cipherText = AES256(key, plainText)
        
        let expectedCipherText: ByteString = [0x8e, 0xa2, 0xb7, 0xca, 0x51, 0x67, 0x45, 0xbf, 0xea, 0xfc, 0x49, 0x90, 0x4b, 0x49, 0x60, 0x89]
        
        XCTAssertEqual(cipherText, expectedCipherText)
    }
    
    static var allTests : [(String, (AESTests) -> () throws -> Void)] {
        return [
            ("testKeyScheduling", testKeyScheduling),
            ("testSubByte", testSubByte),
            ("testAddRoundKey", testAddRoundKey),
            ("testSubBytes", testSubBytes),
            ("testShiftRows", testShiftRows),
            ("testMixColumns", testMixColumns),
            ("testAES128", testAES128),
            ("testAES192", testAES192),
            ("testAES256", testAES256),
        ]
    }
}
