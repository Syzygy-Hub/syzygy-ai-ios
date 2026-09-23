import Foundation

public struct LLMChunk: Sendable {
    public let content: String?
    public let toolCallDelta: String?
    public let finishReason: FinishReason?
    public let metadata: [String: String]

    /// The name of the provider that emitted this chunk (e.g. "openai", "anthropic").
    public let providerName: String?

    /// The model identifier that produced this chunk (e.g. "gpt-4o", "claude-3-5-sonnet").
    public let modelName: String?

    public init(
        content: String? = nil,
        toolCallDelta: String? = nil,
        finishReason: FinishReason? = nil,
        metadata: [String: String] = [:],
        providerName: String? = nil,
        modelName: String? = nil
    ) {
        self.content = content
        self.toolCallDelta = toolCallDelta
        self.finishReason = finishReason
        self.metadata = metadata
        self.providerName = providerName
        self.modelName = modelName
    }
}
