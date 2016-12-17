import XCTest
@testable import CuteCrytpo

class AlgebraTests: XCTestCase {
    func testFiniteField() {
        let m = [1, 1, 0, 1, 1, 0, 0, 0] // 0x1b
        
        let GF256 = FiniteField(p: 2, irreduciblePolynomial: m)
        
        let x1 = [1, 1, 1, 0, 1, 0, 1, 0] // 0x57
        let y1 = [1, 1, 0, 0, 0, 0, 0, 1] // 0x83
        let p1 = [1, 0, 0, 0, 0, 0, 1, 1] // 0xc1
        
        let x2 = x1 // 0x57
        let y2 = [1, 1, 0, 0, 1, 0, 0, 0] // 0x13
        let p2 = [0, 1, 1, 1, 1, 1, 1, 1] // 0xfe
        
        XCTAssertEqual(GF256.multiply(x1, y1), p1)
        XCTAssertEqual(GF256.multiply(x2, y2), p2)

    }
    
    func testByteField() {
        let m: Byte = 0x1b
        
        let GF256 = ByteField(irreduciblePolynomial: m)
        
        let x1: Byte = 0x57
        let y1: Byte = 0x83
        let p1: Byte = 0xc1
        
        let x2 = x1 // 0x57
        let y2: Byte = 0x13
        let p2: Byte = 0xfe
        
        XCTAssertEqual(GF256.multiply(x1, y1), p1)
        XCTAssertEqual(GF256.multiply(x2, y2), p2)

    }


    static var allTests : [(String, (AlgebraTests) -> () throws -> Void)] {
        return [
            ("testFiniteField", testFiniteField),
            ("testByteField", testByteField),
        ]
    }
}
