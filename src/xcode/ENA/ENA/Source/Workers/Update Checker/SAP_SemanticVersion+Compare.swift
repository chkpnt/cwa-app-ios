import Foundation

extension SAP_SemanticVersion: Comparable {
	static func < (lhs: SAP_SemanticVersion, rhs: SAP_SemanticVersion) -> Bool {
		if lhs.major != rhs.major {
			return lhs.major < rhs.major
		}
		if lhs.minor != rhs.minor {
			return lhs.minor < rhs.minor
		}
		if lhs.patch != rhs.patch {
			return lhs.patch < rhs.patch
		}
		return false
	}
}
