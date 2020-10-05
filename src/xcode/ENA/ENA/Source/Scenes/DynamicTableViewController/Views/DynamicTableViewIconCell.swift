import Foundation
import UIKit

class DynamicTableViewIconCell: UITableViewCell {

	// MARK: - Overrides

	override func awakeFromNib() {
		super.awakeFromNib()
		imageView?.tintColor = tintColor
	}

	// MARK: - Internal

	func configure(image: UIImage?, text: String, tintColor: UIColor?, style: ENAFont = .body, iconWidth: CGFloat) {
		if let tintColor = tintColor {
			imageView?.tintColor = tintColor
			imageView?.image = image?.withRenderingMode(.alwaysTemplate)
		} else {
			imageView?.image = image?.withRenderingMode(.alwaysOriginal)
		}

		(textLabel as? ENALabel)?.style = style.labelStyle
		textLabel?.text = text

		imageViewWidthConstraint.constant = iconWidth
	}

	// MARK: - Private

	@IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!

}
