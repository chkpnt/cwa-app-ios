import ExposureNotification
import Foundation
import UIKit

extension ExposureDetectionViewController {
	struct State {
		var exposureManagerState: ExposureManagerState = .init()

		var detectionMode: DetectionMode = DetectionMode.default

		var isTracingEnabled: Bool { exposureManagerState.enabled }

		var activityState: RiskProvider.ActivityState = .idle

		var risk: Risk?
		var riskLevel: RiskLevel {
			risk?.level ?? .unknownInitial
		}

		let previousRiskLevel: EitherLowOrIncreasedRiskLevel?

		var actualRiskText: String {
			switch previousRiskLevel {
			case .low:
				return AppStrings.ExposureDetection.low
			case .increased:
				return AppStrings.ExposureDetection.high
			default:
				return AppStrings.ExposureDetection.unknown
			}
		}

		var riskText: String {
			 isTracingEnabled ? riskLevel.text : AppStrings.ExposureDetection.off
		}

		var riskBackgroundColor: UIColor {
			isTracingEnabled ? riskLevel.backgroundColor : .enaColor(for: .background)
		}

		var riskTintColor: UIColor {
			isTracingEnabled ? riskLevel.tintColor : .enaColor(for: .riskNeutral)
		}

		var riskContrastTintColor: UIColor {
			isTracingEnabled ? riskLevel.contrastTintColor : .enaColor(for: .riskNeutral)
		}

		var riskContrastTextColor: UIColor {
			isTracingEnabled ? riskLevel.contrastTextColor : .enaColor(for: .textPrimary1)
		}
	}
}

private extension RiskLevel {
	var text: String {
		switch self {
		case .unknownInitial: return AppStrings.ExposureDetection.unknown
		case .unknownOutdated: return AppStrings.ExposureDetection.unknown
		case .inactive: return AppStrings.ExposureDetection.off
		case .low: return AppStrings.ExposureDetection.low
		case .increased: return AppStrings.ExposureDetection.high
		}
	}

	var backgroundColor: UIColor {
		switch self {
		case .unknownInitial: return .enaColor(for: .riskNeutral)
		case .unknownOutdated: return .enaColor(for: .riskNeutral)
		case .inactive: return .enaColor(for: .background)
		case .low: return .enaColor(for: .riskLow)
		case .increased: return .enaColor(for: .riskHigh)
		}
	}

	var tintColor: UIColor {
		switch self {
		case .unknownInitial: return .enaColor(for: .riskNeutral)
		case .unknownOutdated: return .enaColor(for: .riskNeutral)
		case .inactive: return .enaColor(for: .riskNeutral)
		case .low: return .enaColor(for: .riskLow)
		case .increased: return .enaColor(for: .riskHigh)
		}
	}

	var contrastTintColor: UIColor {
		switch self {
		case .unknownInitial: return .enaColor(for: .textContrast)
		case .unknownOutdated: return .enaColor(for: .textContrast)
		case .inactive: return .enaColor(for: .riskNeutral)
		case .low: return .enaColor(for: .textContrast)
		case .increased: return .enaColor(for: .textContrast)
		}
	}

	var contrastTextColor: UIColor {
		switch self {
		case .unknownInitial: return .enaColor(for: .textContrast)
		case .unknownOutdated: return .enaColor(for: .textContrast)
		case .inactive: return .enaColor(for: .textPrimary1)
		case .low: return .enaColor(for: .textContrast)
		case .increased: return .enaColor(for: .textContrast)
		}
	}
}
