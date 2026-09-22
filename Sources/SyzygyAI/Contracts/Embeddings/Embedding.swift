import Foundation

public struct Embedding: Sendable {
    public let values: [Float]
    public let dimensions: Int
    public let metadata: [String: String]
    public init(values: [Float], dimensions: Int, metadata: [String: String] = [:]) {
        self.values = values
        self.dimensions = dimensions
        self.metadata = metadata
    }
}
