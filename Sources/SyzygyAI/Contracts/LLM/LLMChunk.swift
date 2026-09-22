import Foundation

public struct LLMChunk: Sendable {
    public let content: String?
    public let toolCallDelta: String?
    public let finishReason: FinishReason?
    public let metadata: [String: String]
    public init(
        content: String? = nil,
        toolCallDelta: String? = nil,
        finishReason: FinishReason? = nil,
        metadata: [String: String] = [:]
    ) {
        self.content = content
        self.toolCallDelta = toolCallDelta
        self.finishReason = finishReason
        self.metadata = metadata
    }
}
