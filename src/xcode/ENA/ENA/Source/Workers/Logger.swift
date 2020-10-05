import Foundation

func log(
	message: String,
	level: LogLevel = .info,
	file: String = #file,
	line: UInt = #line,
	function: String = #function
) {
	#if !RELEASE
	print("\(level.rawValue.uppercased()): [\((file as NSString).lastPathComponent):\(line) - \(function)]\n \(message)")
	#endif
}

func logError(
	message: String,
	level: LogLevel = .error,
	file: String = #file,
	line: UInt = #line,
	function: String = #function
) {
	#if !RELEASE
	log(
		message: message,
		level: .error,
		file: file,
		line: line,
		function: function
	)
	let errorMessages = UserDefaults.standard.dmErrorMessages
	UserDefaults.standard.dmErrorMessages = ["\(Date().description(with: .init(identifier: "en_US_POSIX"))) \(message)"] + errorMessages
	#endif
}

enum LogLevel: String {
	case info
	case warning
	case error
}
