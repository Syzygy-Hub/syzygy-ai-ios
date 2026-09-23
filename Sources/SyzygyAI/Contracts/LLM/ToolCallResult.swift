import Foundation

/// The result returned to the LLM after invoking a tool.
public struct ToolCallResult: Sendable, Codable, Equatable {
    /// Matches the `id` from the corresponding `ToolCallRequest`.
    public let toolCallId: String
    /// Serialised result content to send back to the model.
    public let content: String
    /// `true` if the tool execution failed; the model may decide to retry or surface the error.
    public let isError: Bool

    public init(toolCallId: String, content: String, isError: Bool = false) {
        self.toolCallId = toolCallId
        self.content = content
        self.isError = isError
    }
}
