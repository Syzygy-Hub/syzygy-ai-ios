import Foundation

public protocol AgentProtocol {
    func run(_ request: AgentRequest) async throws -> AgentResult
}
