import Foundation

public struct LLMMessage: Sendable {
    public enum Role: String, Sendable {
        case user, assistant, system, tool
    }
    public let role: Role
    public let content: String
    public init(role: Role, content: String) {
        self.role = role
        self.content = content
    }
}

public struct LLMRequest: Sendable {
    public let messages: [LLMMessage]
    public let model: String
    public let temperature: Double?
    public let maxTokens: Int?
    public let topP: Double?
    public let stopSequences: [String]
    public init(
        messages: [LLMMessage],
        model: String,
        temperature: Double? = nil,
        maxTokens: Int? = nil,
        topP: Double? = nil,
        stopSequences: [String] = []
    ) {
        self.messages = messages
        self.model = model
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topP = topP
        self.stopSequences = stopSequences
    }
}
