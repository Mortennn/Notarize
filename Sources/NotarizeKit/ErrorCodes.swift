import Foundation

enum Errors: Error {
    case failure
    case errorInStaple
}

struct ErrorMessage {
    static let badArgument = "Invalid argument."
    static let success = "Success."
    static let keyDoesNotExist = "Key does not exist in keychain."
    static let missingRequiredArguments = "Missing required arguments. Required arguments are: --password, --username, --package."
    static let uploadFailed = "Upload to notarization services failed."
}

public func terminate(errorMessage: String) -> Never {
    print(errorMessage.red)
    exit(1)
}
