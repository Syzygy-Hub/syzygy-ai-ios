import SyzygyFoundation

public struct MemoryEntry: Sendable {
    public let id: String
    public let content: String
    public let metadata: [String: String]
    public let timestamp: SyzygyTimestamp
    public let type: String
    public init(
        id: String,
        content: String,
        metadata: [String: String] = [:],
        timestamp: SyzygyTimestamp,
        type: String
    ) {
        self.id = id
        self.content = content
        self.metadata = metadata
        self.timestamp = timestamp
        self.type = type
    }
}
