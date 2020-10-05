import UIKit
import ExposureNotification

extension ExposureDetection.DidEndPrematurelyReason {
	func errorAlertController(rootController: UIViewController) -> UIAlertController? {
		guard case let ExposureDetection.DidEndPrematurelyReason.noSummary(error) = self else {
			return nil
		}
		guard let unwrappedError = error else {
			return nil
		}

		switch unwrappedError {
		case let unwrappedError as ENError:
			let openFAQ: (() -> Void)? = {
				guard let url = unwrappedError.faqURL else { return nil }
				return {
					UIApplication.shared.open(url, options: [:])
				}
			}()
			return rootController.setupErrorAlert(
				message: localizedDescription,
				secondaryActionTitle: AppStrings.Common.errorAlertActionMoreInfo,
				secondaryActionCompletion: openFAQ
			)
		default:
			return rootController.setupErrorAlert(
				message: localizedDescription
			)
		}
	}
}
