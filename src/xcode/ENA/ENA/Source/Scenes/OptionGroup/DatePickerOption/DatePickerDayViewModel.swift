import UIKit
import Combine

class DatePickerDayViewModel {

	// MARK: - Init

	init(
		datePickerDay: DatePickerDay,
		onTapOnDate: @escaping (Date) -> Void,
		isSelected: Bool = false,
		calendar: Calendar = .gregorian()
	) {
		self.datePickerDay = datePickerDay
		self.onTapOnDate = onTapOnDate
		self.isSelected = isSelected
		self.calendar = calendar

		switch datePickerDay {
		case .future(let date), .past(let date), .today(let date):
			self.date = date
		}

		update()
	}

	// MARK: - Internal

	var isSelected: Bool {
		didSet {
			update()
		}
	}

	let fontSize: CGFloat = 16

	@Published var backgroundColor: UIColor = .enaColor(for: .background)
	@Published var textColor: UIColor = .enaColor(for: .textPrimary1)
	@Published var fontWeight: String = "regular"
	@Published var accessibilityTraits: UIAccessibilityTraits = []

	var dayString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d"

		return dateFormatter.string(from: date)
	}

	var accessibilityLabel: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long

		return dateFormatter.string(from: date)
	}

	var isSelectable: Bool {
		switch datePickerDay {
		case .past, .today:
			return true
		case .future:
			return false
		}
	}

	func onTap() {
		guard isSelectable else { return }

		onTapOnDate(date)
	}

	func selectIfSameDate(date: Date) {
		isSelected = calendar.isDate(date, inSameDayAs: self.date)
	}

	// MARK: - Private

	private let datePickerDay: DatePickerDay
	private let onTapOnDate: (Date) -> Void
	private let calendar: Calendar

	private let date: Date


	private func update() {
		backgroundColor = isSelected ? UIColor.enaColor(for: .tint) : UIColor.enaColor(for: .background)

		switch (datePickerDay, isSelected) {
		case (.future, _):
			textColor = .enaColor(for: .textPrimary3)
			fontWeight = "regular"
		case (.today, true):
			textColor = .enaColor(for: .textContrast)
			fontWeight = "bold"
		case (.today, false):
			textColor = .enaColor(for: .textTint)
			fontWeight = "bold"
		case (.past, true):
			textColor = .enaColor(for: .textContrast)
			fontWeight = "medium"
		case (.past, false):
			textColor = .enaColor(for: .textPrimary1)
			fontWeight = "regular"
		}

		if isSelectable {
			accessibilityTraits = isSelected ? [.button, .selected] : [.button]
		} else {
			accessibilityTraits = []
		}
	}

}
