public enum Method {
    case get
    case post
    case other(String)
}

public enum Status {
    case ok
    case other(String)
}

typealias Byte = UInt8
typealias Bytes = [Byte]

typealias ValueResponder = (inout ValueRequest) -> ValueResponse

protocol ValueMiddleware {
    func respond(to request: inout ValueRequest, next: ValueResponder) -> ValueResponse
}

struct AppendPathValueMiddleware: ValueMiddleware {
    func respond(to request: inout ValueRequest, next: ValueResponder) -> ValueResponse {
        request.path = request.path + "a"
        return next(&request)
    }
}

struct ValueRequest {
    var method: Method
    var path: String
    var headers: [String: String]
    var body: Bytes

    init(_ method: Method, path: String, headers: [String: String], body: Bytes) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}

struct ValueResponse {
    let status: Status
    init(_ status: Status) {
        self.status = status
    }
}




typealias ReferenceResponder = (ReferenceRequest) -> ReferenceResponse

protocol ReferenceMiddleware {
    func respond(to request: ReferenceRequest, next: ReferenceResponder) -> ReferenceResponse
}

final class AppendPathReferenceMiddleware: ReferenceMiddleware {
    func respond(to request: ReferenceRequest, next: ReferenceResponder) -> ReferenceResponse {
        request.path = request.path + "a"
        return next(request)
    }
}


final class ReferenceRequest {
    var method: Method
    var path: String
    var headers: [String: String]
    var body: Bytes

    init(_ method: Method, path: String, headers: [String: String], body: Bytes) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}

final class ReferenceResponse {
    let status: Status
    init(_ status: Status) {
        self.status = status
    }
}
