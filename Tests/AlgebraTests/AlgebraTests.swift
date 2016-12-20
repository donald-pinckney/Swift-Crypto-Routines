import XCTest
@testable import Algebra
import Types

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
        
        XCTAssertEqual(GF256.multiply(x1, GF256.multiplicativeInverse(x1)),
                       GF256.multiplicativeIdentity)
        XCTAssertEqual(GF256.multiply(y1, GF256.multiplicativeInverse(y1)),
                       GF256.multiplicativeIdentity)
        XCTAssertEqual(GF256.multiply(y2, GF256.multiplicativeInverse(y2)),
                       GF256.multiplicativeIdentity)

    }
    
    func testMatrixFamily() {
        let matrixFamily = MatrixFamily(ring: IntRing())
        
        XCTAssertEqual(matrixFamily.zeroMatrix(width: 3, height: 3).data, [0, 0, 0, 0, 0, 0, 0, 0, 0])
        
        let a = matrixFamily.dataMatrix(width: 3, data: [4, 3, -1, 5, 0, 6, -7, -23, 0])
        let b = matrixFamily.dataMatrix(width: 3, data: [2, 3, 1, 0, 0, -8, -3, 2, 7])
        
        XCTAssertEqual((a + b).data, [6, 6, 0, 5, 0, -2, -10, -21, 7])
        XCTAssertEqual((-a).data, [-4, -3, 1, -5, 0, -6, 7, 23, 0])
        
        XCTAssertEqual((a*b).data, [11, 10, -27, -8, 27, 47, -14, -21, 177])
    }


    static var allTests : [(String, (AlgebraTests) -> () throws -> Void)] {
        return [
            ("testFiniteField", testFiniteField),
            ("testByteField", testByteField),
            ("testMatrixFamily", testMatrixFamily),
        ]
    }
}
