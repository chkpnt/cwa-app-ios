import Foundation
import XCTest
@testable import ENA

class ExposureSubmissionViewControllerTests: XCTestCase {

	private func createVC() -> ExposureSubmissionTestResultViewController {
		AppStoryboard.exposureSubmission.initiate(viewControllerType: ExposureSubmissionTestResultViewController.self) { coder -> UIViewController? in
			ExposureSubmissionTestResultViewController(
				coder: coder,
				coordinator: MockExposureSubmissionCoordinator(),
				exposureSubmissionService: MockExposureSubmissionService(),
				testResult: nil
			)
		}
	}

	func testPositiveState() {
		let vc = createVC()
		vc.testResult = .positive
		_ = vc.view
		XCTAssertEqual(vc.dynamicTableViewModel.numberOfSection, 1)

		let header = vc.tableView(vc.tableView, viewForHeaderInSection: 0) as? ExposureSubmissionTestResultHeaderView
		XCTAssertNotNil(header)

		let cell = vc.tableView(vc.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DynamicTypeTableViewCell
		XCTAssertNotNil(cell)
		XCTAssertEqual(cell?.textLabel?.text, AppStrings.ExposureSubmissionResult.procedure)
	}
}
