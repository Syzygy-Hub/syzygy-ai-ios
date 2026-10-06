import Foundation

public struct RAGOptions: Sendable {
    /// Minimum relevance score a chunk must have to be included in results.
    /// Uses `Double?` for cross-platform consistency with Android, React Native, and Flutter.
    public let scoreThreshold: Double?
    public let metadata: [String: String]
    /// Maximum number of chunks to return. Defaults to 10; values below 1 are clamped to 1.
    public let maxResults: Int

    public init(scoreThreshold: Double? = nil, metadata: [String: String] = [:], maxResults: Int = 10) {
        self.scoreThreshold = scoreThreshold
        self.metadata = metadata
        self.maxResults = max(1, maxResults)
    }
}

/// Abstract interface for retrieval-augmented generation backends.
///
/// Implementations should throw `AIError` values to surface provider-specific failures.
public protocol RAGProvider: Sendable {
    /// Retrieve the most relevant chunks for `query`.
    ///
    /// - Parameters:
    ///   - query: The natural-language query to retrieve against.
    ///   - options: Retrieval options, including `maxResults` and `scoreThreshold`.
    func retrieve(_ query: String, options: RAGOptions) async throws -> [RAGChunk]
}

public extension RAGProvider {
    /// Retrieve using default `RAGOptions()`.
    func retrieve(_ query: String) async throws -> [RAGChunk] {
        try await retrieve(query, options: RAGOptions())
    }
}
