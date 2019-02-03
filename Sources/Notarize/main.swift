import NotarizeKit
import Foundation
import Rainbow

public final class Notarize {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }

    public func run() throws {
        let tokens = tokenizer(arguments: arguments)
        print("Uploading to notarization services".blue)

        let response = uploadToNotarizationServices(token: tokens)
        print("Successfully uploaded app to notarization service".green)
        let UUID = getUUID(xmlString: response)
        print("UUID: \(UUID)".green)

        print("Waits for app to be notarized. This might take a while.".blue)
        let notarizationStatus = waitForNotarizationToFinsish(UUID: UUID, token: tokens)
        switch notarizationStatus {
        case "success":
            print("App was successfully notarized!".green)
            print("Stapling package".blue)
            stapleApp(token: tokens)
        case "invalid":
            print("App was not notarized".red)
            print("Check out the error log to see what went wrong".blue)
            print("UUID: \(UUID)".blue)
            exit(1)
        default:
            print("Unknown status code. Please report the bug.".yellow)
            exit(1)
        }

        print("✅ All steps finished successfully!".green)
    }
}

let cli = Notarize()
try! cli.run()
