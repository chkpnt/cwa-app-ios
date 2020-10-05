import ExposureNotification

protocol CountryKeypackageDownloading {
	typealias Completion = (Result<Void, ExposureDetection.DidEndPrematurelyReason>) -> Void

	func downloadKeypackages(for country: Country.ID, completion: @escaping Completion)
}

class CountryKeypackageDownloader: CountryKeypackageDownloading {

	private weak var delegate: ExposureDetectionDelegate?

	init(delegate: ExposureDetectionDelegate?) {
		self.delegate = delegate
	}

	func downloadKeypackages(for country: Country.ID, completion: @escaping Completion) {
		delegate?.exposureDetection(country: country, determineAvailableData: { [weak self] daysAndHours, country in
			guard let self = self else { return }

			self.downloadDeltaUsingAvailableRemoteData(daysAndHours, country: country, completion: completion)
		})
	}

	private func downloadDeltaUsingAvailableRemoteData(_ daysAndHours: DaysAndHours?, country: Country.ID, completion: @escaping Completion) {

		guard let daysAndHours = daysAndHours else {
			completion(.failure(.noDaysAndHours))
			return
		}

		guard let deltaDaysAndHours = delegate?.exposureDetection(country: country, downloadDeltaFor: daysAndHours) else {
			completion(.failure(.noDaysAndHours))
			return
		}

		delegate?.exposureDetection(country: country, downloadAndStore: deltaDaysAndHours) { error in
			guard error == nil else {
				completion(.failure(.noDaysAndHours))
				return
			}
			completion(.success(()))
		}
	}

}
