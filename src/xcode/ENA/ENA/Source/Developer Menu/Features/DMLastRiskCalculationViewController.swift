#if !RELEASE

import UIKit

/// A view controller that displays the last performed risk calculation details.
final class DMLastRiskCalculationViewController: UIViewController {
	// MARK: Creating a last risk calculcation view controller
	init(lastRisk: String?) {
		self.lastRisk = lastRisk
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: UIViewController
	override func loadView() {
		view = textView
		view.backgroundColor = .white
	}

	override func viewWillAppear(_ animated: Bool) {
		textView.attributedText = NSAttributedString(string: lastRisk ?? "")
		navigationController?.setToolbarHidden(false, animated: animated)
		let exportItem = UIBarButtonItem(
			title: "Export",
			style: .plain,
			target: self,
			action: #selector(exportRiskCalculation)
		)
		exportItem.isEnabled = lastRisk != nil
		setToolbarItems(
			[

				UIBarButtonItem(
					barButtonSystemItem: .flexibleSpace,
					target: nil,
					action: nil
				),
				exportItem,
				UIBarButtonItem(
					barButtonSystemItem: .flexibleSpace,
					target: nil,
					action: nil
				)
			],
			animated: animated
		)
		super.viewWillAppear(animated)
	}

	// MARK: Properties
	private let lastRisk: String?
	/// A text view displaying the last risk calculation.
	private let textView = UITextView()

	@objc
	func exportRiskCalculation() {
		let activityViewController = UIActivityViewController(activityItems: [lastRisk ?? ""], applicationActivities: nil)
		activityViewController.modalTransitionStyle = .coverVertical
		present(activityViewController, animated: true, completion: nil)
	}
}

#endif
