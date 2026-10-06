import Foundation
import Testing
import SyzygyFoundation
@testable import SyzygyAI

// MARK: - Mock conformances for compile-time protocol checks

private struct MockLLMProvider: LLMProvider {
    func complete(_ request: LLMRequest) async throws -> LLMResponse {
        LLMResponse(content: "ok")
    }
    func stream(_ request: LLMRequest) -> AsyncThrowingStream<LLMChunk, Error> {
        AsyncThrowingStream { _ in }
    }
}

private struct MockAgentProtocol: AgentProtocol {
    func run(_ request: AgentRequest) async throws -> AgentResult {
        AgentResult(finalAnswer: "done")
    }
}

private struct MockEmbeddingProvider: EmbeddingProvider {
    func embed(_ text: String) async throws -> Embedding {
        Embedding(values: [], dimensions: 0)
    }
}

private struct MockRAGProvider: RAGProvider {
    func retrieve(_ query: String, options: RAGOptions) async throws -> [RAGChunk] { [] }
}

private struct MockMemoryManager: MemoryManager {
    func add(_ entry: MemoryEntry) async throws {}
    func retrieve(query: String, limit: Int) async throws -> [MemoryEntry] { [] }
    func clear() async throws {}
}

// MARK: - Contract Parity Tests

@Suite("Contract Parity Tests")
struct ContractParityTests {

    @Test func llmProviderProtocolCompiles() {
        // Compile-time check: MockLLMProvider satisfies LLMProvider.
        let _: any LLMProvider = MockLLMProvider()
    }

    @Test func agentProtocolExists() {
        let _: any AgentProtocol = MockAgentProtocol()
    }

    @Test func embeddingProviderExists() {
        let _: any EmbeddingProvider = MockEmbeddingProvider()
    }

    @Test func ragProviderExists() {
        let _: any RAGProvider = MockRAGProvider()
    }

    @Test func memoryManagerExists() {
        let _: any MemoryManager = MockMemoryManager()
    }

    @Test func jsonValueAllCasesCompile() {
        let _: JSONValue = .null
        let _: JSONValue = .bool(true)
        let _: JSONValue = .number(3.14)
        let _: JSONValue = .string("hello")
        let _: JSONValue = .array([.string("a")])
        let _: JSONValue = .object(["key": .number(1)])
    }

    @Test func aiErrorAllCasesCompile() {
        let _: AIError = .authenticationFailure("bad key")
        let _: AIError = .rateLimited(retryAfterMs: 5000)
        let _: AIError = .rateLimited(retryAfterMs: nil)
        let _: AIError = .networkError(underlying: URLError(.timedOut))
        let _: AIError = .invalidRequest("bad param")
        let _: AIError = .providerFailure("server error")
        let _: AIError = .cancelled
    }

    @Test func toolCallWithDefaultArguments() {
        let req = ToolCall(id: "call-1", name: "search", arguments: ["q": .string("swift")])
        #expect(req.id == "call-1")
        #expect(req.name == "search")
    }

    @Test func toolCallResultExists() {
        let result = ToolCallResult(toolCallId: "call-1", content: "found it", isError: false)
        #expect(result.toolCallId == "call-1")
        #expect(!result.isError)
    }

    @Test func llmRequestHasRequestId() {
        let req = LLMRequest(
            messages: [LLMMessage(role: .user, content: "hi")],
            model: "test-model",
            requestId: "req-abc",
            correlationId: "trace-xyz"
        )
        #expect(req.requestId == "req-abc")
        #expect(req.correlationId == "trace-xyz")
    }

    @Test func llmResponseHasProviderName() {
        let resp = LLMResponse(content: "hi", providerName: "openai", modelName: "gpt-4o")
        #expect(resp.providerName == "openai")
        #expect(resp.modelName == "gpt-4o")
    }

    @Test func ragChunkHasId() {
        let chunk = RAGChunk(
            id: "chunk-42",
            content: "text",
            score: 0.8,
            source: "https://example.com",
            documentId: "doc-1"
        )
        #expect(chunk.id == "chunk-42")
        #expect(chunk.source == "https://example.com")
        #expect(chunk.documentId == "doc-1")
        // id is optional — nil is valid
        let chunkNoId = RAGChunk(content: "text", score: 0.9)
        #expect(chunkNoId.id == nil)
    }

    @Test func ragOptionsMaxResultsDefaultsAndClamps() {
        #expect(RAGOptions().maxResults == 10)
        #expect(RAGOptions(maxResults: 0).maxResults == 1)
        #expect(RAGOptions(maxResults: -3).maxResults == 1)
        #expect(RAGOptions(maxResults: 25).maxResults == 25)
    }

    @Test func ragProviderReceivesMaxResults() async throws {
        struct EchoRAGProvider: RAGProvider {
            func retrieve(_ query: String, options: RAGOptions) async throws -> [RAGChunk] {
                (0..<options.maxResults).map { RAGChunk(content: "\(query)-\($0)", score: 1.0) }
            }
        }
        let provider = EchoRAGProvider()
        #expect(try await provider.retrieve("q", options: RAGOptions(maxResults: 3)).count == 3)
        #expect(try await provider.retrieve("q").count == 10)
    }

    @Test func llmRequestToolsPopulatedAndNil() {
        let tool = AgentTool(name: "search", description: "d", inputSchema: [:]) { _ in
            ToolResult(output: "x")
        }
        let withTools = LLMRequest(messages: [], model: "m", tools: [tool])
        #expect(withTools.tools?.count == 1)
        #expect(withTools.tools?.first?.name == "search")
        #expect(LLMRequest(messages: [], model: "m").tools == nil)
    }

    @Test func llmResponseToolCallsPopulatedAndNil() {
        let call = ToolCall(id: "1", name: "search", arguments: ["q": .string("x")])
        let response = LLMResponse(content: "", toolCalls: [call])
        #expect(response.toolCalls == [call])
        #expect(LLMResponse(content: "hi").toolCalls == nil)
    }

    @Test func toolCallConstructionAndEquality() {
        let first = ToolCall(id: "1", name: "n", arguments: ["a": .number(1)])
        #expect(first == ToolCall(id: "1", name: "n", arguments: ["a": .number(1)]))
        #expect(first != ToolCall(id: "2", name: "n", arguments: ["a": .number(1)]))
        #expect(first.arguments["a"] == .number(1))
    }

    @Test func namespacedMemoryManagerMethodNames() async throws {
        actor Store: NamespacedMemoryManager {
            var log: [String] = []
            func add(_ entry: MemoryEntry) async throws {}
            func retrieve(query: String, limit: Int) async throws -> [MemoryEntry] { [] }
            func clear() async throws {}
            func addToNamespace(entry: MemoryEntry, namespace: String) async throws { log.append("add:\(namespace)") }
            func retrieveFromNamespace(query: String, namespace: String, limit: Int?) async throws -> [MemoryEntry] {
                log.append("retrieve:\(namespace)")
                return []
            }
            func deleteEntry(id: String, namespace: String) async throws { log.append("delete:\(id)@\(namespace)") }
            func clearNamespace(namespace: String) async throws { log.append("clear:\(namespace)") }
        }
        let store = Store()
        let manager: any NamespacedMemoryManager = store
        let entry = MemoryEntry(
            id: "e1",
            content: "c",
            timestamp: SyzygyTimestamp(millisecondsSinceEpoch: 0),
            type: "t"
        )
        try await manager.addToNamespace(entry: entry, namespace: "ns")
        _ = try await manager.retrieveFromNamespace(query: "q", namespace: "ns", limit: nil)
        try await manager.deleteEntry(id: "e1", namespace: "ns")
        try await manager.clearNamespace(namespace: "ns")
        #expect(await store.log == ["add:ns", "retrieve:ns", "delete:e1@ns", "clear:ns"])
    }

    @Test func agentRequestMaxStepsDefaultsToTen() {
        #expect(AgentRequest(input: "hi").maxSteps == 10)
    }

    @Test func agentRequestMaxStepsClampsToOne() {
        #expect(AgentRequest(input: "hi", maxSteps: 0).maxSteps == 1)
        #expect(AgentRequest(input: "hi", maxSteps: -5).maxSteps == 1)
    }

    @Test func agentRequestMaxStepsPreservesExplicitValue() {
        #expect(AgentRequest(input: "hi", maxSteps: 25).maxSteps == 25)
    }

    @Test func agentToolExecutesWithJSONValueInput() async throws {
        let tool = AgentTool(
            name: "echo",
            description: "Echoes q",
            inputSchema: ["type": .string("object")]
        ) { input in
            guard case .string(let text)? = input["q"] else {
                return ToolResult(output: "", isError: true)
            }
            return ToolResult(output: text)
        }
        let result = try await tool.execute(["q": .string("swift")])
        #expect(result.output == "swift")
        let _: any Sendable = AgentRequest(input: "x", tools: [tool])
    }
}
