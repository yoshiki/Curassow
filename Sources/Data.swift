#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

class Data {
  let bytes: UnsafeMutablePointer<Int8>
  let capacity: Int

  init(capacity: Int) {
    bytes = UnsafeMutablePointer<Int8>(malloc(capacity + 1))
    self.capacity = capacity
  }

  deinit {
    free(bytes)
  }

  var characters: [CChar] {
    var data = [CChar](repeating: 0, count: capacity)
    memcpy(&data, bytes, data.count)
    return data
  }

  var string: String? {
    return String(validatingUTF8: bytes)
  }
}
