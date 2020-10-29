// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: internal/semantic_version.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Cwa_Internal_V2_SemanticVersion {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var major: UInt32 = 0

  var minor: UInt32 = 0

  var patch: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "cwa.internal.v2"

extension Cwa_Internal_V2_SemanticVersion: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SemanticVersion"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "major"),
    2: .same(proto: "minor"),
    3: .same(proto: "patch"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.major) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.minor) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.patch) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.major != 0 {
      try visitor.visitSingularUInt32Field(value: self.major, fieldNumber: 1)
    }
    if self.minor != 0 {
      try visitor.visitSingularUInt32Field(value: self.minor, fieldNumber: 2)
    }
    if self.patch != 0 {
      try visitor.visitSingularUInt32Field(value: self.patch, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cwa_Internal_V2_SemanticVersion, rhs: Cwa_Internal_V2_SemanticVersion) -> Bool {
    if lhs.major != rhs.major {return false}
    if lhs.minor != rhs.minor {return false}
    if lhs.patch != rhs.patch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
