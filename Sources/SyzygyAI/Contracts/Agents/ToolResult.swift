import Foundation

public struct ToolResult: Sendable {
    public let output: String
    public let isError: Bool
    public let metadata: [String: String]
    public init(output: String, isError: Bool = false, metadata: [String: String] = [:]) {
        self.output = output
        self.isError = isError
        self.metadata = metadata
    }
}
