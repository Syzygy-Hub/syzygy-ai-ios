import Foundation

public struct LLMMessage: Sendable {
    public enum Role: String, Sendable {
        case user, assistant, system, tool
    }

    public let role: Role
    public let content: String

    /// Tool calls requested by the assistant in this message (populated when role == .assistant).
    public let toolCalls: [ToolCallRequest]?

    /// The result of a tool invocation (populated when role == .tool).
    public let toolCallResult: ToolCallResult?

    public init(role: Role, content: String, toolCalls: [ToolCallRequest]? = nil, toolCallResult: ToolCallResult? = nil) {
        self.role = role
        self.content = content
        self.toolCalls = toolCalls
        self.toolCallResult = toolCallResult
    }
}

public struct LLMRequest: Sendable {
    public let messages: [LLMMessage]
    public let model: String
    public let temperature: Double?
    public let maxTokens: Int?
    public let topP: Double?
    public let stopSequences: [String]

    /// Caller-supplied correlation ID for request tracking.
    public let requestId: String?

    /// Trace chain ID for distributed tracing across provider calls.
    public let correlationId: String?

    public init(
        messages: [LLMMessage],
        model: String,
        temperature: Double? = nil,
        maxTokens: Int? = nil,
        topP: Double? = nil,
        stopSequences: [String] = [],
        requestId: String? = nil,
        correlationId: String? = nil
    ) {
        self.messages = messages
        self.model = model
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topP = topP
        self.stopSequences = stopSequences
        self.requestId = requestId
        self.correlationId = correlationId
    }
}
