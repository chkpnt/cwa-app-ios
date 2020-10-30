//
// Corona-Warn-App
//
// SAP SE and all other contributors /
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

@testable import ENA
import Foundation
import XCTest

/// Tests comparing of the `RiskLevel` enum
final class RiskLevelTests: XCTestCase {

	/*
	RiskLevels are ordered according to these rules:
	1. .low is least
	2. .inactive is highest
	3. .high overrides .unknownInitial & .low
	4. .unknownOutdated overrides .low AND .high
	5. .unknownInitial overrides .low AND .unknownOutdated
	
	Generally, comparing raw values of the below enum is sufficient to ensure the correct hierarchy, but there is one exception:
	.unknownOutdated should override .high - in order to ensure that the user always updates the exposure detection.
	*/

	func testRiskLevelCompareLow() {
		// swiftlint:disable:next identical_operands
		XCTAssertFalse(RiskLevel.low < RiskLevel.low)
		
		XCTAssert(RiskLevel.low < RiskLevel.unknownOutdated)
		XCTAssert(RiskLevel.low < RiskLevel.unknownInitial)
		XCTAssert(RiskLevel.low < RiskLevel.high)
		XCTAssert(RiskLevel.low < RiskLevel.inactive)
		
		// Probably redundant tests...
		XCTAssertFalse(RiskLevel.low > RiskLevel.unknownOutdated)
		XCTAssertFalse(RiskLevel.low > RiskLevel.unknownInitial)
		XCTAssertFalse(RiskLevel.low > RiskLevel.high)
		XCTAssertFalse(RiskLevel.low > RiskLevel.inactive)
	}

	func testRiskLevelCompareUnknownOutdated() {
		// swiftlint:disable:next identical_operands
		XCTAssertFalse(RiskLevel.unknownOutdated < RiskLevel.unknownOutdated)
		XCTAssert(RiskLevel.unknownOutdated > RiskLevel.low)
		XCTAssert(RiskLevel.unknownOutdated < RiskLevel.unknownInitial)
		XCTAssert(RiskLevel.unknownOutdated < RiskLevel.inactive)
		XCTAssert(RiskLevel.unknownOutdated < RiskLevel.high)
	}

	func testRiskLevelCompareUnknownInitial() {
		XCTAssertFalse(RiskLevel.unknownInitial < RiskLevel.low)
		XCTAssertFalse(RiskLevel.unknownInitial < RiskLevel.unknownOutdated)
		// swiftlint:disable:next identical_operands
		XCTAssertFalse(RiskLevel.unknownInitial < RiskLevel.unknownInitial)
		XCTAssert(RiskLevel.unknownInitial < RiskLevel.high)
		XCTAssert(RiskLevel.unknownInitial < RiskLevel.inactive)
	}

	func testRiskLevelCompareHigh() {
		// swiftlint:disable:next identical_operands
		XCTAssertFalse(RiskLevel.high < RiskLevel.high)
		XCTAssert(RiskLevel.high > RiskLevel.low)
		XCTAssert(RiskLevel.high > RiskLevel.unknownInitial)
		XCTAssert(RiskLevel.high > RiskLevel.unknownOutdated)
		XCTAssert(RiskLevel.high < RiskLevel.inactive)

	}

	func testRiskLevelCompareInactive() {
		XCTAssertFalse(RiskLevel.inactive < RiskLevel.low)
		XCTAssertFalse(RiskLevel.inactive < RiskLevel.unknownOutdated)
		XCTAssertFalse(RiskLevel.inactive < RiskLevel.unknownInitial)
		XCTAssertFalse(RiskLevel.inactive < RiskLevel.high)
		// swiftlint:disable:next identical_operands
		XCTAssertFalse(RiskLevel.inactive < RiskLevel.inactive)
	}

	func testRiskLevelCompareLowLeast() {
		RiskLevel.allCases.dropFirst().forEach {
			XCTAssert(RiskLevel.low < $0)
		}
	}

	func testRiskLevelCompareInactiveHighest() {
		RiskLevel.allCases.dropLast().forEach {
			XCTAssert(RiskLevel.inactive > $0)
		}
	}
}
