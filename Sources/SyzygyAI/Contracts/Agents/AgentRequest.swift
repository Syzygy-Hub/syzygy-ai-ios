import Foundation

public struct AgentRequest: Sendable {
    public let input: String
    public let tools: [AgentTool]
    /// Maximum number of agent steps before the run is terminated. Default: 10.
    /// Exceeding the limit yields a truncated result. Values below 1 are
    /// clamped to 1.
    public let maxSteps: Int
    public let metadata: [String: String]
    public init(
        input: String,
        tools: [AgentTool] = [],
        maxSteps: Int = 10,
        metadata: [String: String] = [:]
    ) {
        self.input = input
        self.tools = tools
        self.maxSteps = max(1, maxSteps)
        self.metadata = metadata
    }
}
