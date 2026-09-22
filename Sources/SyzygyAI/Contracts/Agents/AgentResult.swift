import Foundation

public struct AgentResult: Sendable {
    public let finalAnswer: String
    public let steps: [AgentStep]
    public let tokenUsage: TokenUsage?
    public init(finalAnswer: String, steps: [AgentStep] = [], tokenUsage: TokenUsage? = nil) {
        self.finalAnswer = finalAnswer
        self.steps = steps
        self.tokenUsage = tokenUsage
    }
}
