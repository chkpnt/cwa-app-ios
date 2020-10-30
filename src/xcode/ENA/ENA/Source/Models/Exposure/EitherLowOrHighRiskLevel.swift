//
// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import Foundation

enum EitherLowOrHighRiskLevel: Int, Codable {

	case low = 0
	case high = 1_000 /// so that high > low + we have enough reserved values

	var description: String {
		switch self {
		case .low: return "low"
		case .high: return "high"
		}
	}

}

extension EitherLowOrHighRiskLevel {

	init?(with risk: RiskLevel) {
		switch risk {
		case .low:
			self = .low
		case .high:
			self = .high
		default:
			return nil
		}
	}

}
