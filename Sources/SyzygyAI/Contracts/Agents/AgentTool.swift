import Foundation

public typealias ToolSchema = JSONObject
public typealias ToolInput = JSONObject

public struct AgentTool: Sendable {
    public let name: String
    public let description: String
    public let inputSchema: ToolSchema
    public let execute: @Sendable (ToolInput) async throws -> ToolResult
    public init(
        name: String,
        description: String,
        inputSchema: ToolSchema,
        execute: @escaping @Sendable (ToolInput) async throws -> ToolResult
    ) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
        self.execute = execute
    }
}
