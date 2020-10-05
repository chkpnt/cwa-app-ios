import Foundation

enum UITestingParameters {
	enum ExposureSubmission: String {
		case useMock = "UI:ExposureSubmission:useMock"
		case getRegistrationTokenSuccess = "UI:ExposureSubmission:getRegistrationTokenSuccess"
		case submitExposureSuccess = "UI:ExposureSubmission:submitExposureSuccess"
	}

	enum SecureStoreHandling: String {
		case simulateMismatchingKey = "UI:SecureStoreHandling:simulateMismatchingKey"
	}
}
