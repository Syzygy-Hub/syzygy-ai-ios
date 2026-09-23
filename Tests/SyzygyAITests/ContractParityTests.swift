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
    func retrieve(_ query: String, topK: Int, options: RAGOptions?) async throws -> [RAGChunk] { [] }
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

    @Test func toolCallRequestExists() {
        let req = ToolCallRequest(id: "call-1", name: "search", arguments: ["q": .string("swift")])
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
        let chunk = RAGChunk(id: "chunk-42", content: "text", score: 0.8, source: "https://example.com", documentId: "doc-1")
        #expect(chunk.id == "chunk-42")
        #expect(chunk.source == "https://example.com")
        #expect(chunk.documentId == "doc-1")
        // id is optional — nil is valid
        let chunkNoId = RAGChunk(content: "text", score: 0.9)
        #expect(chunkNoId.id == nil)
    }

    @Test func ragProviderAcceptsOptionalOptions() {
        // Compile-time check: retrieve accepts optional RAGOptions (nil = provider defaults)
        let _: any RAGProvider = MockRAGProvider()
    }

    @Test func ragProviderRetrieveSignatureAcceptsTopK() async throws {
        struct MockRAGProvider: RAGProvider {
            func retrieve(_ query: String, topK: Int, options: RAGOptions?) async throws -> [RAGChunk] {
                return []
            }
        }
        let provider = MockRAGProvider()
        let result = try await provider.retrieve("test", topK: 5, options: nil)
        #expect(result.isEmpty)
    }
}
