import XCTest
import Combine
@testable import ENA

// swiftlint:disable force_unwrapping
class DatePickerOptionViewModelTests: XCTestCase {

    func testMonthAndYearChange() {
		let referenceDate = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))

		let viewModel = DatePickerOptionViewModel(
			today: referenceDate
		)

		XCTAssertEqual(viewModel.subtitle, "Dezember 2000 – Januar 2001")

		XCTAssertEqual(viewModel.datePickerDays.count, 28)
		XCTAssertEqual(viewModel.datePickerDays[0], .past(Calendar.current.date(byAdding: .day, value: -21, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[1], .past(Calendar.current.date(byAdding: .day, value: -20, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[2], .past(Calendar.current.date(byAdding: .day, value: -19, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[3], .past(Calendar.current.date(byAdding: .day, value: -18, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[4], .past(Calendar.current.date(byAdding: .day, value: -17, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[5], .past(Calendar.current.date(byAdding: .day, value: -16, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[6], .past(Calendar.current.date(byAdding: .day, value: -15, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[7], .past(Calendar.current.date(byAdding: .day, value: -14, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[8], .past(Calendar.current.date(byAdding: .day, value: -13, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[9], .past(Calendar.current.date(byAdding: .day, value: -12, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[10], .past(Calendar.current.date(byAdding: .day, value: -11, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[11], .past(Calendar.current.date(byAdding: .day, value: -10, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[12], .past(Calendar.current.date(byAdding: .day, value: -9, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[13], .past(Calendar.current.date(byAdding: .day, value: -8, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[14], .past(Calendar.current.date(byAdding: .day, value: -7, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[15], .past(Calendar.current.date(byAdding: .day, value: -6, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[16], .past(Calendar.current.date(byAdding: .day, value: -5, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[17], .past(Calendar.current.date(byAdding: .day, value: -4, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[18], .past(Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[19], .past(Calendar.current.date(byAdding: .day, value: -2, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[20], .past(Calendar.current.date(byAdding: .day, value: -1, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[21], .today(Calendar.current.date(byAdding: .day, value: 0, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[22], .future(Calendar.current.date(byAdding: .day, value: 1, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[23], .future(Calendar.current.date(byAdding: .day, value: 2, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[24], .future(Calendar.current.date(byAdding: .day, value: 3, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[25], .future(Calendar.current.date(byAdding: .day, value: 4, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[26], .future(Calendar.current.date(byAdding: .day, value: 5, to: referenceDate)!))
		XCTAssertEqual(viewModel.datePickerDays[27], .future(Calendar.current.date(byAdding: .day, value: 6, to: referenceDate)!))

		XCTAssertEqual(viewModel.weekdays.count, 7)
		XCTAssertEqual(viewModel.weekdays, ["M", "D", "M", "D", "F", "S", "S"])

		XCTAssertEqual(viewModel.weekdayTextColors.count, 7)
		XCTAssertEqual(viewModel.weekdayTextColors, [
			.enaColor(for: .tint),
			.enaColor(for: .textPrimary2),
			.enaColor(for: .textPrimary2),
			.enaColor(for: .textPrimary2),
			.enaColor(for: .textPrimary2),
			.enaColor(for: .textPrimary2),
			.enaColor(for: .textPrimary2)
		])
    }

	func testMonthChange() {
		let viewModel = DatePickerOptionViewModel(
			today: Calendar.current.date(byAdding: .day, value: 31, to: Date(timeIntervalSinceReferenceDate: 0))!
		)

		XCTAssertEqual(viewModel.subtitle, "Januar–Februar 2001")
	}

	func testWithinOneMonth() {
		let viewModel = DatePickerOptionViewModel(
			today: Calendar.current.date(byAdding: .day, value: 28, to: Date(timeIntervalSinceReferenceDate: 0))!
		)

		XCTAssertEqual(viewModel.subtitle, "Januar 2001")
	}

	func test() {
		let viewModel = DatePickerOptionViewModel(
			today: Calendar.current.date(byAdding: .day, value: 28, to: Date(timeIntervalSinceReferenceDate: 0))!,
			calendar: .gregorian(with: .init(identifier: "en-US"))
		)

		XCTAssertEqual(viewModel.weekdays.count, 7)
		XCTAssertEqual(viewModel.weekdays, ["S", "M", "D", "M", "D", "F", "S"])
	}

}
