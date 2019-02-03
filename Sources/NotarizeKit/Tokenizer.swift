import Foundation
import Rainbow

public struct Options {
    public static let package = "--package"
    public static let username = "--username"
    public static let password = "--password"
    public static let primaryBundleId = "--primary-bundle-id"
    public static let ascProvider = "--asc-provider"
    public static let verbose = "--verbose"
    public static let help = "--help"
}

public struct Token {
    public var package: String = ""
    public var username: String = ""
    public var password: String = ""
    public var primaryBundleId = ""
    public var ascProvider: String?
    public var verbose: String?
}

public func tokenizer(arguments: [String]) -> Token {
    var token = Token()

    for argumentItem in arguments.enumerated() {

        if argumentItem.element == Options.help {
            help()
            terminate(errorMessage: "")
        }

        if argumentItem.offset + 1 == arguments.count {
            break
        }

        let argument = argumentItem.element
        let value = arguments[argumentItem.offset + 1]
        switch argument {
        case Options.package:
            token.package = value
        case Options.username:
            token.username = value
        case Options.password:
            token.password = value
        case Options.primaryBundleId:
            token.primaryBundleId = value
        case Options.verbose:
            token.verbose = "true"
        case Options.ascProvider:
            token.ascProvider = value
        default:
            continue
        }
    }

    if token.package.isEmpty || token.password.isEmpty || token.username.isEmpty || token.primaryBundleId.isEmpty {
        print("--package, --username, --password and --primary-bundle-id is required.".red)
        exit(1)
    }

    return token
}

internal func help() {
    print("""

        Copyright (c) 2019, Morten Nielsen.

        Version: Notarize 1.0.0 NotarizeKit 1.0.0

        Usage: --package <path> --username <username> --password <password> --primary-bundle-id <primary-bundle-id> --asc-provider <provider_shortname>

        Options:

        --package            Path to either DMG or zip file.
        --username           Email associated with Apple Connect.
        --password           Password for Apple Connect. Can be plain text, but it is recommended to use "@keychain:<name>".
        --primary-bundle-id  Bundle id of package. e.g. "com.company.appName.dmg".
        --asc-provider       Specify asc provider.

        --help               Display options.

    """)
}

internal func fileExist(at path: String) -> Bool {
    let filemanager = FileManager()
    return filemanager.fileExists(atPath: path)
}
