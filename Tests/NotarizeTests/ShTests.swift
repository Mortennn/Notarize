import NotarizeKit
import XCTest

class ShTests: XCTestCase {
    func testShSuccess() {
        let validCommand = ["pwd"]
        var output = ""
        do {
            output = try sh(validCommand)
        } catch {
            XCTFail("Should not fail")
        }
        XCTAssertTrue(!output.isEmpty)
    }

    func testShFailure() {
        let invalidCommand = ["invalidCommand"]
        do {
            _ = try sh(invalidCommand)
        } catch {
            XCTAssertTrue(true)
            return
        }
        XCTFail("Should not fail")
    }
}
