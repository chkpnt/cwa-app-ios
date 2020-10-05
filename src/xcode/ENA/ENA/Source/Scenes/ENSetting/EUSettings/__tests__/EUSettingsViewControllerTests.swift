import XCTest
@testable import ENA

class EUSettingsViewControllerTests: XCTestCase {

	func testDataReloadForSuccessfulDownload() {
		var config = SAP_ApplicationConfiguration()
		config.supportedCountries = ["DE", "ES", "FR", "IT", "IE", "DK"]
		let fakeResult: (Result<SAP_ApplicationConfiguration, Error>) = .success(config)
		let appConfigurationProviderStub = AppConfigurationProviderStub(result: fakeResult)

		let vc = EUSettingsViewController(appConfigurationProvider: appConfigurationProviderStub)
		vc.viewDidLoad()

		XCTAssert(vc.tableView.numberOfRows(inSection: 1) == 6)
	}

	func testDataReloadForUnsuccessfulDownload() {
		let fakeResult: (Result<SAP_ApplicationConfiguration, Error>) = .failure(URLSession.Response.Failure.noResponse)
		let appConfigurationProviderStub = AppConfigurationProviderStub(result: fakeResult)
		let vc = EUSettingsViewController(appConfigurationProvider: appConfigurationProviderStub)
		vc.viewDidLoad()

		XCTAssert(vc.tableView.numberOfRows(inSection: 1) == 1)
	}

}

private class AppConfigurationProviderStub: AppConfigurationProviding {

	let result: (Result<SAP_ApplicationConfiguration, Error>)

	init(result: (Result<SAP_ApplicationConfiguration, Error>)) {
		self.result = result
	}

	func appConfiguration(forceFetch: Bool, completion: @escaping Completion) {
		completion(result)
	}

	func appConfiguration(completion: @escaping Completion) {
		completion(result)
	}
}
