import XCTest
@testable import ENA

final class SAP_RiskScoreClass_LowAndHighTests: XCTestCase {
    func testWithOnlyHighAndLow() {
		let sut: [SAP_RiskScoreClass] = [
			SAP_RiskScoreClass.with {
				$0.label = "LOW"
			},
			SAP_RiskScoreClass.with {
				$0.label = "HIGH"
			}
		]

		XCTAssertEqual(sut.low?.label, "LOW")
		XCTAssertEqual(sut.high?.label, "HIGH")
	}

	func testEmpty() {
		let sut: [SAP_RiskScoreClass] = []
		XCTAssertNil(sut.low)
		XCTAssertNil(sut.high)
	}

	func testIgnoresEmojis() {
		let high = SAP_RiskScoreClass.with { $0.label = "🚬" }
		let sut: [SAP_RiskScoreClass] = [high]
		XCTAssertNil(sut.high)
	}
}
