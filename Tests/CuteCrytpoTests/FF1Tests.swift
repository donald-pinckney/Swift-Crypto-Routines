import XCTest
@testable import CuteCrytpo

class FF1Tests: XCTestCase {
    func testFF1() {
        let key: ByteString = [0x2B, 0x7E, 0x15, 0x16, 0x28, 0xAE, 0xD2, 0xA6, 0xAB, 0xF7, 0x15, 0x88, 0x09, 0xCF, 0x4F, 0x3C]
        let radix = 10
        
        let X: [UInt] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let T: ByteString = []
        
        let C = FF1(blockCipher: AES128, key: key, radix: radix, plainText: X, tweak: T)
        
        let expectC: [UInt] = [2, 4, 3, 3, 4, 7, 7, 4, 8, 4]
        XCTAssertEqual(C, expectC)
    }
    
    func testFF1_modified() {
        let key: ByteString = [0x2B, 0x7E, 0x15, 0x16, 0x28, 0xAE, 0xD2, 0xA6, 0xAB, 0xF7, 0x15, 0x88, 0x09, 0xCF, 0x4F, 0x3C]
        let radix = 10
        
        let X: [UInt] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let T: ByteString = []
        
        let C = FF1_modified(blockCipher: AES128, key: key, radix: radix, plainText: X, tweak: T)
        
        let expectC: [UInt] = [2, 4, 3, 3, 4, 7, 7, 4, 8, 4]
        XCTAssertEqual(C, expectC)
    }


    static var allTests : [(String, (FF1Tests) -> () throws -> Void)] {
        return [
            ("testFF1", testFF1),
            ("testFF1_modified", testFF1_modified),
        ]
    }
}
