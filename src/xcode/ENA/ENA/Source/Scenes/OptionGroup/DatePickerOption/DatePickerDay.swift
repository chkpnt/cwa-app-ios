import UIKit
import Combine

enum DatePickerDay: Equatable {
	case past(Date)
	case today(Date)
	case future(Date)
}
