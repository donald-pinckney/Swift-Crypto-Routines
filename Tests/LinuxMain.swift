import XCTest
@testable import AESTests
@testable import AlgebraTests
@testable import FF1Tests


XCTMain([
	testCase(AESTests.allTests),
	testCase(AlgebraTests.allTests),
	testCase(FF1Tests.allTests),
])
