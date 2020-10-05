import Foundation
import XCTest
@testable import ENA

class ExposureDetectionViewControllerTests: XCTestCase {

	// MARK: - Setup.

	func createVC(with state: ExposureDetectionViewController.State) -> ExposureDetectionViewController? {
		let vc = AppStoryboard.exposureDetection.initiateInitial { coder -> UIViewController? in
			ExposureDetectionViewController(coder: coder, state: state, delegate: MockExposureDetectionViewControllerDelegate())
		}

		guard let exposureDetectionVC = vc as? ExposureDetectionViewController else {
			XCTFail("Could not load ExposureDetectionViewController.")
			return nil
		}

		return exposureDetectionVC
	}

	// MARK: - Exposure detection model.

	func testHighRiskState() {
		let state = ExposureDetectionViewController.State(
			exposureManagerState: .init(authorized: true, enabled: true, status: .active),
			detectionMode: .automatic,
			activityState: .idle,
			risk: .init(level: .increased,
						details: .init(
							daysSinceLastExposure: 1,
							numberOfExposures: 2,
							activeTracing: .init(interval: 14 * 86400),
							exposureDetectionDate: nil
						),
						riskLevelHasChanged: false),
						previousRiskLevel: nil
		)

		guard let vc = createVC(with: state) else { return }
		_ = vc.view
		XCTAssertNotNil(vc.tableView)
	}
}
