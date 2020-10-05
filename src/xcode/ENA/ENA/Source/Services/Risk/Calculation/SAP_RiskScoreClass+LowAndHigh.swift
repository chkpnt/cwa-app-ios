import Foundation

extension Array where Element == SAP_RiskScoreClass {
	private func firstWhereLabel(is label: String) -> SAP_RiskScoreClass? {
		first(where: { $0.label == label })
	}
	var low: SAP_RiskScoreClass? { firstWhereLabel(is: "LOW") }
	var high: SAP_RiskScoreClass? { firstWhereLabel(is: "HIGH") }
}
