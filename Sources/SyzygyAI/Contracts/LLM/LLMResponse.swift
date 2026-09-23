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

    /// The name of the provider that generated this response (e.g. "openai", "anthropic").
    public let providerName: String?

    /// The model identifier used for this response (e.g. "gpt-4o", "claude-3-5-sonnet").
    public let modelName: String?

    public init(
        content: String,
        tokenUsage: TokenUsage? = nil,
        finishReason: FinishReason? = nil,
        providerName: String? = nil,
        modelName: String? = nil
    ) {
        self.content = content
        self.tokenUsage = tokenUsage
        self.finishReason = finishReason
        self.providerName = providerName
        self.modelName = modelName
    }
}
