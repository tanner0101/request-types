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



struct HybridRequest {
  private final class Impl {
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
    
    convenience init(copying original: Impl) {
      self.init(original.method, path: original.path, headers: original.headers, body: original.body)
    }
  }
  
  private var impl: Impl
  private var implForMutation: Impl {
    mutating get {
      if !isKnownUniquelyReferenced(&impl) {
        impl = Impl(copying: impl)
      }
      return impl
    }
  }
  
  var method: Method {
    get { return impl.method }
    set { implForMutation.method = newValue }
  }
  
  var path: String {
    get { return impl.path }
    set { implForMutation.path = newValue }
  }
  
  var headers: [String: String] {
    get { return impl.headers }
    set { implForMutation.headers = newValue }
  }
  
  var body: Bytes {
    get { return impl.body }
    set { implForMutation.body = newValue }
  }
  
  init(_ method: Method, path: String, headers: [String: String], body: Bytes) {
    impl = Impl(method, path: path, headers: headers, body: body)
  }
}

struct HybridResponse {
    let status: Status
    init(_ status: Status) {
        self.status = status
    }
}

typealias HybridResponder = (inout HybridRequest) -> HybridResponse

protocol HybridMiddleware {
    func respond(to request: inout HybridRequest, next: HybridResponder) -> HybridResponse
}

final class AppendPathHybridMiddleware: HybridMiddleware {
    func respond(to request: inout HybridRequest, next: HybridResponder) -> HybridResponse {
        request.path = request.path + "a"
        return next(&request)
    }
}


