import Foundation

public struct RAGOptions: Sendable {
    /// Minimum relevance score a chunk must have to be included in results.
    /// Uses `Double?` for cross-platform consistency with Android, React Native, and Flutter.
    public let scoreThreshold: Double?
    public let metadata: [String: String]

    public init(scoreThreshold: Double? = nil, metadata: [String: String] = [:]) {
        self.scoreThreshold = scoreThreshold
        self.metadata = metadata
    }
}

/// Abstract interface for retrieval-augmented generation backends.
///
/// Implementations should throw `AIError` values to surface provider-specific failures.
public protocol RAGProvider {
    /// Retrieve the most relevant chunks for `query`.
    ///
    /// - Parameters:
    ///   - query: The natural-language query to retrieve against.
    ///   - topK: Maximum number of chunks to return.
    ///   - options: Optional retrieval options. When `nil`, provider defaults apply.
    func retrieve(_ query: String, topK: Int, options: RAGOptions?) async throws -> [RAGChunk]
}
