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

	typealias Completion = (Result<[ExposureWindow], DidEndPrematurelyReason>) -> Void

	// MARK: - Init

	init(
		delegate: ExposureDetectionDelegate,
		countryKeypackageDownloader: CountryKeypackageDownloading? = nil
	) {
		self.delegate = delegate

		if let countryKeypackageDownloader = countryKeypackageDownloader {
			self.countryKeypackageDownloader = countryKeypackageDownloader
		} else {
			self.countryKeypackageDownloader = CountryKeypackageDownloader(delegate: delegate)
		}
	}

	// MARK: - Internal

	@Published var activityState: RiskProvider.ActivityState = .idle

	func start(
		exposureConfiguration: ENExposureConfiguration,
		completion: @escaping Completion
	) {
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

				Log.info("ExposureDetection: Start detecting summary.", log: .riskDetection)
				self.activityState = .detecting
				self.detectSummary(writtenPackages: writtenPackages, exposureConfiguration: exposureConfiguration)
			}
		}
	}

	func cancel() {
		activityState = .idle
		progress?.cancel()
	}

	// MARK: - Private

	private weak var delegate: ExposureDetectionDelegate?

	private var completion: Completion?
	private var progress: Progress?
	private var countryKeypackageDownloader: CountryKeypackageDownloading

	// There was a decision not to use the 2 letter code "EU", but instead "EUR".
	// Please see this story for more informations: https://jira.itc.sap.com/browse/EXPOSUREBACK-151
	private let country = "EUR"

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

	private func detectSummary(writtenPackages: WrittenPackages, exposureConfiguration: ENExposureConfiguration) {
		self.progress = self.delegate?.exposureDetection(
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
