import Foundation

public struct TokenUsage: Sendable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

public enum FinishReason: String, Sendable {
    case stop, length, toolCall, contentFilter, error
}

public struct LLMResponse: Sendable {
    public let content: String
    public let tokenUsage: TokenUsage?
    public let finishReason: FinishReason?
    public init(content: String, tokenUsage: TokenUsage? = nil, finishReason: FinishReason? = nil) {
        self.content = content
        self.tokenUsage = tokenUsage
        self.finishReason = finishReason
    }
}
