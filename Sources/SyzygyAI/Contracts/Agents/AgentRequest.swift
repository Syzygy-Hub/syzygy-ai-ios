import Foundation

// AgentRequest contains [AgentTool] which uses @unchecked Sendable; propagate here.
public struct AgentRequest: @unchecked Sendable {
    public let input: String
    public let tools: [AgentTool]
    public let maxSteps: Int // v1.0.0 policy default: 10
    public let metadata: [String: String]
    public init(
        input: String,
        tools: [AgentTool] = [],
        maxSteps: Int = 10, // v1.0.0 policy default: 10
        metadata: [String: String] = [:]
    ) {
        self.input = input
        self.tools = tools
        self.maxSteps = maxSteps
        self.metadata = metadata
    }
}
