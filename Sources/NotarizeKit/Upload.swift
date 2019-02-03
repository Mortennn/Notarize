import Foundation
import Rainbow
import SWXMLHash

public func uploadToNotarizationServices(token: Token) -> String {
    var arguments = [
        "xcrun",
        "altool",
        "--notarize-app",
        "-t",
        "osx",
        "--output-format",
        "xml",
        "--username",
        "\(token.username)",
        "--password",
        "\(token.password)",
        "--file",
        "\(token.package)",
        "--primary-bundle-id",
        "\(token.primaryBundleId)"
    ]

    if let ascProvider = token.ascProvider {
        arguments.append("--asc-provider")
        arguments.append(ascProvider)
    }

    var response = ""

    do {
        response = try sh(arguments)
    } catch {
        terminate(errorMessage: ErrorMessage.uploadFailed)
    }

    return response
}

public func getUUID(xmlString: String) -> String {
    let xml = SWXMLHash.config { _ in
        // set any config options here
    }.parse(xmlString)
    guard let uuid = xml["plist"]["dict"]["dict"]["string"].element?.text else {
        print("Failed retrieving UUID from notarization response.".red)
        exit(0)
    }
    return uuid
}

/// Waits for notarization service to finish.
///
/// - Returns: Returns 'success' or 'invalid'
public func waitForNotarizationToFinsish(UUID: String, token: Token) -> String {
    var notarizationStatus = ""
    while notarizationStatus.isEmpty || notarizationStatus == "in progress" {
        if notarizationStatus.isEmpty {
            print("Waiting for status".blue)
        } else {
            print("Waiting for notarization service to finish...".blue)
        }

        sleep(30)

        var response = ""
        do {
            response = try sh([
                "xcrun",
                "altool",
                "--notarization-info",
                UUID,
                "--username",
                token.username,
                "--password",
                token.password,
                "--output-format",
                "xml"
            ])
        } catch {
            print("Checking status failed".red)
        }

        guard let status = getStatus(xmlResponse: response) else { continue }
        notarizationStatus = status

    }

    return notarizationStatus
}

public func getStatus(xmlResponse:String) -> String? {
    let xml = SWXMLHash.config { _ in }.parse(xmlResponse)
    let notarizationInfo = xml["plist"]["dict"]["dict"].children

    for item in notarizationInfo.enumerated() {
        guard let text = item.element.element?.text else { continue }
        if text == "Status" {
            guard let status = notarizationInfo[item.offset+1].element?.text else {
                return nil
            }
            return status
        }

    }

    return nil
}

public func stapleApp(token: Token) {
    do {
        _ = try sh([
            "xcrun",
            "stapler",
            "staple",
            token.package
        ])
    } catch {
        print("Stapling package failed".red)
        print("Command: xcrun stapler staple \(token.package)".blue)
        exit(1)
    }
}
