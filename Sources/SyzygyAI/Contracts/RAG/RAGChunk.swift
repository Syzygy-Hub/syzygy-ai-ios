import Foundation

public struct RAGChunk: Sendable {
    public let content: String
    public let score: Double
    public let metadata: [String: String]
    public init(content: String, score: Double, metadata: [String: String] = [:]) {
        self.content = content
        self.score = score
        self.metadata = metadata
    }
}
