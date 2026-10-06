import Foundation

/// A Sendable, Codable JSON value type that represents arbitrary JSON values.
public enum JSONValue: Sendable, Codable, Equatable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSONValue])
    case object([String: JSONValue])

    // MARK: - Convenience initialisers

    public init(_ value: Bool) { self = .bool(value) }
    public init(_ value: Double) { self = .number(value) }
    public init(_ value: Int) { self = .number(Double(value)) }
    public init(_ value: String) { self = .string(value) }
    public init(_ value: [JSONValue]) { self = .array(value) }
    public init(_ value: [String: JSONValue]) { self = .object(value) }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let numberValue = try? container.decode(Double.self) {
            self = .number(numberValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([JSONValue].self) {
            self = .array(arrayValue)
        } else if let objectValue = try? container.decode([String: JSONValue].self) {
            self = .object(objectValue)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "JSONValue: unsupported JSON value"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null: try container.encodeNil()
        case .bool(let boolValue): try container.encode(boolValue)
        case .number(let numberValue): try container.encode(numberValue)
        case .string(let stringValue): try container.encode(stringValue)
        case .array(let arrayValue): try container.encode(arrayValue)
        case .object(let objectValue): try container.encode(objectValue)
        }
    }
}

/// Convenience typealiases for JSON object and array types.
public typealias JSONObject = [String: JSONValue]
public typealias JSONArray = [JSONValue]
