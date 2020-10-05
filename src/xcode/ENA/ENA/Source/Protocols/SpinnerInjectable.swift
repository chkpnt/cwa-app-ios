import Foundation
import UIKit

/// Allows to add and remove a default iOS activity indicator spinner.
protocol SpinnerInjectable: AnyObject {
	var spinner: UIActivityIndicatorView? { get set }
	var view: UIView! { get }
	func startSpinner()
	func stopSpinner()
}

extension SpinnerInjectable {
	func startSpinner() {
		if spinner != nil {
			// Do not add anything if spinner already exists.
			return
		}

		let spinner = UIActivityIndicatorView(style: .large)
		spinner.startAnimating()
		spinner.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(spinner)
		spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		spinner.center = view.center
		self.spinner = spinner
	}

	func stopSpinner() {
		if spinner == nil { return }
		spinner?.removeFromSuperview()
		spinner = nil
	}
}
