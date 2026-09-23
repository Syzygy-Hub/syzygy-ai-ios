import Foundation

public struct RAGChunk: Sendable {
    /// Stable, unique identifier for this chunk. Optional in v1.x; required in v2.0.0.
    public let id: String?
    /// The retrieved text content.
    public let content: String
    /// Relevance score returned by the retrieval system.
    public let score: Double
    /// Citation or source URL/identifier for this chunk.
    public let source: String?
    /// Identifier of the parent document this chunk was split from.
    public let documentId: String?
    /// Arbitrary metadata supplied by the retrieval backend.
    public let metadata: [String: String]

    public init(
        id: String? = nil,
        content: String,
        score: Double,
        source: String? = nil,
        documentId: String? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.content = content
        self.score = score
        self.source = source
        self.documentId = documentId
        self.metadata = metadata
    }
}
