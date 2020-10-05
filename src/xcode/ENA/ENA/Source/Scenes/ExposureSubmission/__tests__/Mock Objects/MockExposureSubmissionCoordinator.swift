@testable import ENA

class MockExposureSubmissionCoordinator: ExposureSubmissionCoordinating {

	// MARK: - Attributes.

	weak var delegate: ExposureSubmissionCoordinatorDelegate?

	// MARK: - ExposureSubmissionCoordinator methods.

	func start(with: TestResult? = nil) { }

	func dismiss() { }

	func showOverviewScreen() { }

	func showTestResultScreen(with result: TestResult) { }

	func showHotlineScreen() { }

	func showTanScreen() { }

	func showQRScreen(qrScannerDelegate: ExposureSubmissionQRScannerDelegate) { }

	func showSymptomsScreen() { }

	func showWarnOthersScreen() { }

	func showThankYouScreen() { }

	func showWarnEuropeScreen() { }

	func showWarnEuropeTravelConfirmationScreen() { }

	func showWarnEuropeCountrySelectionScreen() { }
}
