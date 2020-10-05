#if !RELEASE

import Foundation

extension SAP_TemporaryExposureKey: Comparable {
	static func < (lhs: SAP_TemporaryExposureKey, rhs: SAP_TemporaryExposureKey) -> Bool {
		lhs.rollingStartIntervalNumber > rhs.rollingStartIntervalNumber
	}
}

#endif
