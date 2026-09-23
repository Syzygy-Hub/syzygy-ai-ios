import Foundation

/// Represents a tool call requested by the LLM.
public struct ToolCallRequest: Sendable, Codable, Equatable {
    /// Provider-assigned identifier for this tool call (used to correlate with ToolCallResult).
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
