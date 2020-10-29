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

import ExposureNotification
import Foundation

/// Every time the user wants to know the own risk the app creates an `ExposureDetection`.
final class ExposureDetection {

	// MARK: Properties
	@Published var activityState: RiskProvider.ActivityState = .idle
	private weak var delegate: ExposureDetectionDelegate?
	private var completion: Completion?
	private var progress: Progress?
	private var countryKeypackageDownloader: CountryKeypackageDownloading
	private let appConfiguration: Cwa_Internal_V2_ApplicationConfigurationIOS

	// There was a decision not to use the 2 letter code "EU", but instead "EUR".
	// Please see this story for more informations: https://jira.itc.sap.com/browse/EXPOSUREBACK-151
	private let country = "EUR"

	// MARK: Creating a Transaction
	init(
		delegate: ExposureDetectionDelegate,
		countryKeypackageDownloader: CountryKeypackageDownloading? = nil,
		appConfiguration: Cwa_Internal_V2_ApplicationConfigurationIOS
	) {
		self.delegate = delegate
		self.appConfiguration = appConfiguration

		if let countryKeypackageDownloader = countryKeypackageDownloader {
			self.countryKeypackageDownloader = countryKeypackageDownloader
		} else {
			self.countryKeypackageDownloader = CountryKeypackageDownloader(delegate: delegate)
		}
	}

	func cancel() {
		activityState = .idle
		progress?.cancel()
	}

	private func downloadKeyPackages(completion: @escaping () -> Void) {
		countryKeypackageDownloader.downloadKeypackages(for: country) { [weak self] result in
			switch result {
			case .failure(let didEndPrematurelyReason):
				self?.endPrematurely(reason: didEndPrematurelyReason)
			case .success:
				completion()
			}
		}
	}

	private func writeKeyPackagesToFileSystem(completion: (WrittenPackages) -> Void) {
		if let writtenPackages = self.delegate?.exposureDetectionWriteDownloadedPackages(country: country) {
			completion(WrittenPackages(urls: writtenPackages.urls))
		} else {
			endPrematurely(reason: .unableToWriteDiagnosisKeys)
		}
	}

	private var exposureConfiguration: ENExposureConfiguration? {
		guard let configuration = try? ENExposureConfiguration(from: appConfiguration.exposureConfiguration) else {
			return nil
		}

		return configuration
	}

	private func detectSummary(writtenPackages: WrittenPackages, exposureConfiguration: ENExposureConfiguration) {
		self.progress = self.delegate?.exposureDetection(
			self,
			detectSummaryWithConfiguration: exposureConfiguration,
			writtenPackages: writtenPackages
		) { [weak self] result in
			writtenPackages.cleanUp()
			self?.useSummaryResult(result)
		}
	}

	private func useSummaryResult(_ result: Result<ENExposureDetectionSummary, Error>) {
		switch result {
		case .success(let summary):
			didDetectSummary(summary)
		case .failure(let error):
			endPrematurely(reason: .noSummary(error))
		}
	}

	typealias Completion = (Result<ENExposureDetectionSummary, DidEndPrematurelyReason>) -> Void

	func start(completion: @escaping Completion) {
		Log.info("ExposureDetection: Start downloading packages.", log: .riskDetection)

		self.completion = completion
		activityState = .downloading

		downloadKeyPackages { [weak self] in
			guard let self = self else { return }

			Log.info("ExposureDetection: Completed downloading packages.", log: .riskDetection)
			Log.info("ExposureDetection: Start writing packages to file system.", log: .riskDetection)

			self.writeKeyPackagesToFileSystem { [weak self] writtenPackages in
				guard let self = self else { return }

				Log.info("ExposureDetection: Completed writing packages to file system.", log: .riskDetection)

				self.activityState = .detecting

				if let exposureConfiguration = self.exposureConfiguration {
					Log.info("ExposureDetection: Start detecting summary.", log: .riskDetection)

					self.detectSummary(writtenPackages: writtenPackages, exposureConfiguration: exposureConfiguration)
				} else {
					Log.error("ExposureDetection: End prematurely.", log: .riskDetection, error: DidEndPrematurelyReason.noExposureConfiguration)

					self.endPrematurely(reason: .noExposureConfiguration)
				}
			}
		}
	}

	// MARK: Working with the Completion Handler

	// Ends the transaction prematurely with a given reason.
	private func endPrematurely(reason: DidEndPrematurelyReason) {
		Log.error("ExposureDetection: End prematurely.", log: .riskDetection, error: reason)

		precondition(
			completion != nil,
			"Tried to end a detection prematurely is only possible if a detection is currently running."
		)

		activityState = .idle

		DispatchQueue.main.async {
			self.completion?(.failure(reason))
			self.completion = nil
		}
	}

	// Informs the delegate about a summary.
	private func didDetectSummary(_ summary: ENExposureDetectionSummary) {
		Log.info("ExposureDetection: Completed detecting summary.", log: .riskDetection)

		precondition(
			completion != nil,
			"Tried report a summary but no completion handler is set."
		)

		activityState = .idle

		DispatchQueue.main.async {
			self.completion?(.success(summary))
			self.completion = nil
		}
	}
}

private extension ENExposureConfiguration {
	convenience init(from exposureConfiguration: Cwa_Internal_V2_ExposureConfiguration) throws {
		self.init()

		var dict = [NSNumber: NSNumber]()
		for (key, value) in exposureConfiguration.infectiousnessForDaysSinceOnsetOfSymptoms {
			dict[NSNumber(value: key)] = NSNumber(value: value)
		}
		infectiousnessForDaysSinceOnsetOfSymptoms = dict

		reportTypeNoneMap = ENDiagnosisReportType(rawValue: ENDiagnosisReportType.RawValue(exposureConfiguration.reportTypeNoneMap)) ?? .unknown
		attenuationDurationThresholds = exposureConfiguration.attenuationDurationThresholds.map { NSNumber(value: $0) }
		immediateDurationWeight = exposureConfiguration.immediateDurationWeight
		mediumDurationWeight = exposureConfiguration.mediumDurationWeight
		nearDurationWeight = exposureConfiguration.nearDurationWeight
		otherDurationWeight = exposureConfiguration.otherDurationWeight
		daysSinceLastExposureThreshold = Int(exposureConfiguration.daysSinceLastExposureThreshold)
		infectiousnessStandardWeight = exposureConfiguration.infectiousnessStandardWeight
		infectiousnessHighWeight = exposureConfiguration.infectiousnessHighWeight
		reportTypeConfirmedTestWeight = exposureConfiguration.reportTypeConfirmedTestWeight
		reportTypeConfirmedClinicalDiagnosisWeight = exposureConfiguration.reportTypeConfirmedClinicalDiagnosisWeight
		reportTypeSelfReportedWeight = exposureConfiguration.reportTypeSelfReportedWeight
		reportTypeRecursiveWeight = exposureConfiguration.reportTypeRecursiveWeight
	}
}
