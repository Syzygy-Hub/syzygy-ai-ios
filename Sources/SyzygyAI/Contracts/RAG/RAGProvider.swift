import Foundation

public struct RAGOptions: Sendable {
    public let scoreThreshold: Double?
    public let metadata: [String: String]
    public init(scoreThreshold: Double? = nil, metadata: [String: String] = [:]) {
        self.scoreThreshold = scoreThreshold
        self.metadata = metadata
    }
}

public protocol RAGProvider {
    func retrieve(
        query: String,
        topK: Int,
        options: RAGOptions?
    ) async throws -> [RAGChunk]
}
