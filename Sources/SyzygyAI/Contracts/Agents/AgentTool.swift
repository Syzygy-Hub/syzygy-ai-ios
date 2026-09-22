import Foundation

public typealias ToolSchema = [String: Any]
public typealias ToolInput = [String: Any]

// AgentTool holds an async closure which cannot be Sendable-checked automatically.
// @unchecked Sendable is safe here: callers are responsible for closure thread-safety.
public struct AgentTool: @unchecked Sendable {
    public let name: String
    public let description: String
    public let inputSchema: ToolSchema
    public let execute: (ToolInput) async throws -> ToolResult
    public init(
        name: String,
        description: String,
        inputSchema: ToolSchema,
        execute: @escaping (ToolInput) async throws -> ToolResult
    ) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
        self.execute = execute
    }
}
