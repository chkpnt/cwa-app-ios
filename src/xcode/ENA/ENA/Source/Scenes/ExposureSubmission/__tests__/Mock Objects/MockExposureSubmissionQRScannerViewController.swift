import Foundation
import UIKit
@testable import ENA

class MockExposureSubmissionQRScannerViewController: QRScannerViewController {

	// MARK: - Mock callbacks.

	var dismissCallback: ((Bool, (() -> Void)?) -> Void)?
	var presentCallback: ((UIViewController, Bool, (() -> Void)?) -> Void)?

	// MARK: - QRScannerViewController methods.

	weak var delegate: ExposureSubmissionQRScannerDelegate?

	func dismiss(animated: Bool, completion: (() -> Void)?) {
		dismissCallback?(animated, completion)
	}

	func present(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
		presentCallback?(vc, animated, completion)
	}
}

class MockExposureSubmissionQRScannerDelegate: ExposureSubmissionQRScannerDelegate {

	// MARK: - Mock callbacks.

	var onQRScannerDidScan: ((QRScannerViewController, String) -> Void)?
	var onQRScannerError: ((QRScannerViewController, QRScannerError) -> Void)?

	// MARK: - ExposureSubmissionQRScannerDelegate methods.

	func qrScanner(_ viewController: QRScannerViewController, didScan code: String) {
		onQRScannerDidScan?(viewController, code)
	}

	func qrScanner(_ viewController: QRScannerViewController, error: QRScannerError) {
		onQRScannerError?(viewController, error)
	}
}
