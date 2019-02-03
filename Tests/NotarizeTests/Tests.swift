import NotarizeKit
import XCTest

class Tests: XCTestCase {
    struct TestTokens {
        static let package = "~/app.dmg"
        static let username = "mail@gmail.com"
        static let password = "testPassword"
        static let primaryBundleId = "com.company.appname.dmg"
    }

    var basicTestToken: Token {
        return tokenizer(arguments: [
            Options.package,
            TestTokens.package,
            Options.username,
            TestTokens.username,
            Options.password,
            TestTokens.password,
            Options.primaryBundleId,
            TestTokens.primaryBundleId
        ])
    }

    func testTokenizer() {
        let token = basicTestToken

        XCTAssertEqual(token.package, TestTokens.package)
        XCTAssertEqual(token.username, TestTokens.username)
        XCTAssertEqual(token.password, TestTokens.password)
        XCTAssertEqual(token.primaryBundleId, TestTokens.primaryBundleId)
        XCTAssertNil(token.ascProvider)
    }

    func testGetUUID() {}
}
