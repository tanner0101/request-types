import XCTest
@testable import request_types

class request_typesTests: XCTestCase {
    func testReference() {
        var middlewares: [ReferenceMiddleware] = []

        for _ in 0..<Int(2^^4) {
            let appendMiddleware = AppendPathReferenceMiddleware()
            middlewares.append(appendMiddleware)
        }

        let base: ReferenceResponder = { req in
            return ReferenceResponse(.ok)
        }

        let chain = middlewares.reduce(base, { nextResponder, nextMiddleware in
            let closure: ReferenceResponder = { req in
                return nextMiddleware.respond(to: req, next: nextResponder)
            }
            return closure
        })

        var body: Bytes = []
        for _ in 0..<Int(2^^12) {
            body.append(64)
        }


        measure {
            for _ in 0..<Int(2^^16) {
                let request = ReferenceRequest(
                    .get,
                    path: "/foo",
                    headers: ["Content-Type": "application/json"],
                    body: body
                )

                _ = chain(request)
            }
        }
    }

    func testValue() {
        var middlewares: [ValueMiddleware] = []

        for _ in 0..<Int(2^^4) {
            let appendMiddleware = AppendPathValueMiddleware()
            middlewares.append(appendMiddleware)
        }

        let base: ValueResponder = { req in
            return ValueResponse(.ok)
        }

        let chain = middlewares.reduce(base, { nextResponder, nextMiddleware in
            let closure: ValueResponder = { req in
                return nextMiddleware.respond(to: &req, next: nextResponder)
            }
            return closure
        })

        var body: Bytes = []
        for _ in 0..<Int(2^^12) {
            body.append(64)
        }

        measure {
            for _ in 0..<Int(2^^16) {
                var request = ValueRequest(
                    .get,
                    path: "/foo",
                    headers: ["Content-Type": "application/json"],
                    body: body
                )

                _ = chain(&request)
            }
        }
    }


    func testHybrid() {
        var middlewares: [HybridMiddleware] = []

        for _ in 0..<Int(2^^4) {
            let appendMiddleware = AppendPathHybridMiddleware()
            middlewares.append(appendMiddleware)
        }

        let base: HybridResponder = { req in
            return HybridResponse(.ok)
        }

        let chain = middlewares.reduce(base, { nextResponder, nextMiddleware in
            let closure: HybridResponder = { req in
                return nextMiddleware.respond(to: &req, next: nextResponder)
            }
            return closure
        })

        var body: Bytes = []
        for _ in 0..<Int(2^^12) {
            body.append(64)
        }

        measure {
            for _ in 0..<Int(2^^16) {
                var request = HybridRequest(
                    .get,
                    path: "/foo",
                    headers: ["Content-Type": "application/json"],
                    body: body
                )

                _ = chain(&request)
            }
        }
    }
    static var allTests = [
        ("testReference", testReference),
        ("testValue", testValue),
        ("testHybrid", testHybrid),
    ]
}

infix operator ^^
func ^^(num: Int, power: Int) -> Int {
    var res = num
    for _ in 1 ..< power {
        res *= num
    }
    return res
}
