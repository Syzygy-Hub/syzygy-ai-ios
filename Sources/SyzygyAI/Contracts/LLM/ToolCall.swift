import Foundation

/// A tool invocation requested by the model, carried in an `LLMResponse` or an assistant `LLMMessage`.
public struct ToolCall: Sendable, Codable, Equatable {
    /// Provider-assigned identifier for this tool call.
    public let id: String
    /// The name of the tool to invoke.
    public let name: String
    /// Parsed arguments for the tool call.
    public let arguments: JSONObject

    public init(id: String, name: String, arguments: JSONObject = [:]) {
        self.id = id
        self.name = name
        self.arguments = arguments
    }
}
