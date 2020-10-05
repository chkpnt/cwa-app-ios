import Foundation
import FMDB

protocol DownloadedPackagesStoreV1: AnyObject {
	func open()
	func close()
	func set(country: Country.ID, day: String, package: SAPDownloadedPackage)
	func set(country: Country.ID, hour: Int, day: String, package: SAPDownloadedPackage)
	func package(for day: String, country: Country.ID) -> SAPDownloadedPackage?
	func hourlyPackages(for day: String, country: Country.ID) -> [SAPDownloadedPackage]
	func allDays(country: Country.ID) -> [String] // 2020-05-30
	func hours(for day: String, country: Country.ID) -> [Int]
	func reset()
	func deleteOutdatedDays(now: String) throws
}
