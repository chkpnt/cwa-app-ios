import Foundation

protocol RiskProviding: AnyObject {
	typealias Completion = (Risk?) -> Void

	func observeRisk(_ consumer: RiskConsumer)
	func requestRisk(userInitiated: Bool, completion: Completion?)
	func nextExposureDetectionDate() -> Date

	var configuration: RiskProvidingConfiguration { get set }
}
