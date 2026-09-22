import Foundation

public protocol EmbeddingProvider {
    func embed(_ text: String) async throws -> Embedding
}
