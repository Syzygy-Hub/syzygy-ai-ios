import SyzygyFoundation

public struct ConversationTurn: Sendable {
    public enum Role: String, Sendable {
        case user, assistant, system, tool
    }
    public let role: Role
    public let content: String
    public let timestamp: SyzygyTimestamp
    public let metadata: [String: String]
    public init(
        role: Role,
        content: String,
        timestamp: SyzygyTimestamp,
        metadata: [String: String] = [:]
    ) {
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.metadata = metadata
    }
}
