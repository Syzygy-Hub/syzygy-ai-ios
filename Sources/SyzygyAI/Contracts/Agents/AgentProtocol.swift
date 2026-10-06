import Foundation

public protocol AgentProtocol: Sendable {
    func run(_ request: AgentRequest) async throws -> AgentResult
}
