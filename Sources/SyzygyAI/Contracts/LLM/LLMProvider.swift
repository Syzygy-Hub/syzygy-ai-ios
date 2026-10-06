import Foundation

public protocol LLMProvider: Sendable {
    func complete(_ request: LLMRequest) async throws -> LLMResponse
    func stream(_ request: LLMRequest) -> AsyncThrowingStream<LLMChunk, Error>
}
