import NotarizeKit
import Rainbow
import SWXMLHash
import XCTest

class UploadTests: XCTestCase {
    let testUUID = "1111aa11-1111-1a1a-11aa-111aaaa11a11"

    func testGetUUID() {
        let testXMLResponse = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
           <dict>
              <key>notarization-upload</key>
              <dict>
                 <key>RequestUUID</key>
                 <string>\(testUUID)</string>
              </dict>
              <key>os-version</key>
              <string>10.14.3</string>
              <key>success-message</key>
              <string>No errors uploading '/path/to/app.dmg'.</string>
              <key>tool-path</key>
              <string>/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework</string>
              <key>tool-version</key>
              <string>1.1.1138</string>
           </dict>
        </plist>
        """
        let resultUUID = getUUID(xmlString: testXMLResponse)
        XCTAssertEqual(resultUUID, testUUID)
    }

    func testGetStatus() {
        guard let successStatus = getStatus(xmlResponse: NotarizeResponses.success) else {
            XCTFail("Fail in get success status")
            return
        }

        guard let invalidStatus = getStatus(xmlResponse: NotarizeResponses.invalid) else {
            XCTFail("Fail in get success status")
            return
        }

        guard let inProgressStatus = getStatus(xmlResponse: NotarizeResponses.inProgress) else {
            XCTFail("Fail in get success status")
            return
        }

        XCTAssertEqual(successStatus, "success")
        XCTAssertEqual(invalidStatus, "invalid")
        XCTAssertEqual(inProgressStatus, "in progress")

    }
}

struct NotarizeResponses {
    static let success = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>notarization-info</key>
    <dict>
    <key>Date</key>
    <date>2011-01-28T15:55:12Z</date>
    <key>LogFileURL</key>
    <string>https://osxapps-ssl.itunes.apple.com/logFile</string>
    <key>RequestUUID</key>
    <string>1111aa11-1111-1a1a-11aa-111aaaa11a11</string>
    <key>Status</key>
    <string>success</string>
    <key>Status Code</key>
    <integer>2</integer>
    <key>Status Message</key>
    <string>Package Approved</string>
    </dict>
    <key>os-version</key>
    <string>10.14.3</string>
    <key>success-message</key>
    <string>No errors getting notarization info.</string>
    <key>tool-path</key>
    <string>/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework</string>
    <key>tool-version</key>
    <string>1.1.1138</string>
    </dict>
    </plist>
    """
    static let invalid = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>notarization-info</key>
    <dict>
    <key>Date</key>
    <date>2011-01-28T15:55:12Z</date>
    <key>LogFileURL</key>
    <string>https://osxapps-ssl.itunes.apple.com/logFile</string>
    <key>RequestUUID</key>
    <string>1111aa11-1111-1a1a-11aa-111aaaa11a11</string>
    <key>Status</key>
    <string>invalid</string>
    <key>Status Code</key>
    <integer>2</integer>
    <key>Status Message</key>
    <string>Package Invalid</string>
    </dict>
    <key>os-version</key>
    <string>10.14.3</string>
    <key>success-message</key>
    <string>No errors getting notarization info.</string>
    <key>tool-path</key>
    <string>/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework</string>
    <key>tool-version</key>
    <string>1.1.1138</string>
    </dict>
    </plist>
    """
    static let inProgress = """
    <plist version="1.0">
    <dict>
    <key>notarization-info</key>
    <dict>
    <key>Date</key>
    <date>2019-01-31T16:20:47Z</date>
    <key>RequestUUID</key>
    <string>1111aa11-1111-1a1a-11aa-111aaaa11a11</string>
    <key>Status</key>
    <string>in progress</string>
    <key>Status Code</key>
    <integer>0</integer>
    <key>Status Message</key>
    <string>Package Approved</string>
    </dict>
    <key>os-version</key>
    <string>10.14.3</string>
    <key>success-message</key>
    <string>No errors getting notarization info.</string>
    <key>tool-path</key>
    <string>/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework</string>
    <key>tool-version</key>
    <string>1.1.1138</string>
    </dict>
    </plist>
    """
}
