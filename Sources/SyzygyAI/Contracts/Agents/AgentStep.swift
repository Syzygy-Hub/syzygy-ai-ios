import Foundation

public struct AgentStep: Sendable {
    public let action: String
    public let input: [String: String] // [String: Any] narrowed to [String: String] — Any is not Sendable in Swift 6
    public let output: String
    public let metadata: [String: String]
    public init(
        action: String,
        input: [String: String] = [:],
        output: String,
        metadata: [String: String] = [:]
    ) {
        self.action = action
        self.input = input
        self.output = output
        self.metadata = metadata
    }
}
