#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Spectre
import Nest
@testable import Curassow


describe("HTTPParser") {
  var parser: HTTPParser!
  var inSocket: Socket!
  var outSocket: Socket!

  $0.before {
    var descriptors: [Int32] = [0, 0]
    if pipe(&descriptors) == -1 {
      fatalError("HTTPParser pipe: \(errno)")
    }

    inSocket = Socket(descriptor: descriptors[0])
    outSocket = Socket(descriptor: descriptors[1])

    parser = HTTPParser(socket: inSocket)
  }

  $0.after {
    inSocket.close()
    outSocket.close()
  }

  $0.it("can parse a HTTP request body") {
    outSocket.write("GET / HTTP/1.1\r\nHost: localhost\r\n\r\n")

    let request = try parser.parse()
    try expect(request.method) == "GET"
    try expect(request.path) == "/"
    try expect(request.headers.count) == 1

    let header = request.headers[0]
    try expect(header.0) == "Host"
    try expect(header.1) == "localhost"
  }
}
