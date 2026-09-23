import Foundation

public struct AgentStep: Sendable {
    public let action: String
    /// String-keyed input for the step. Kept as `[String: String]` for backward
    /// compatibility with v1.0.0 callers.
    /// Use `structuredInput` for typed JSON values added in v1.1.0.
    /// Both fields will unify to `JSONObject` in v2.0.0.
    public let input: [String: String]
    /// Optional typed JSON input introduced in v1.1.0. Prefer this over `input`
    /// for new code when heterogeneous value types are needed.
    public let structuredInput: JSONObject?
    public let output: String
    public let metadata: [String: String]
    public init(
        action: String,
        input: [String: String] = [:],
        structuredInput: JSONObject? = nil,
        output: String,
        metadata: [String: String] = [:]
    ) {
        self.action = action
        self.input = input
        self.structuredInput = structuredInput
        self.output = output
        self.metadata = metadata
    }
}
