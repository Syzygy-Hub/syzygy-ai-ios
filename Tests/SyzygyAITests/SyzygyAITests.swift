import Testing
import SyzygyFoundation
@testable import SyzygyAI

@Suite("SyzygyAI Contract Smoke Tests")
struct SyzygyAITests {
    @Test func llmRequestIsConstructible() {
        let req = LLMRequest(
            messages: [LLMMessage(role: .user, content: "hi")],
            model: "test"
        )
        #expect(req.model == "test")
    }
    @Test func embeddingHasDimensions() {
        let emb = Embedding(values: [0.1, 0.2], dimensions: 2)
        #expect(emb.dimensions == 2)
    }
    @Test func ragChunkHasScore() {
        let chunk = RAGChunk(id: "chunk-1", content: "test", score: 0.9)
        #expect(chunk.score == 0.9)
    }
    @Test func agentResultHasAnswer() {
        let result = AgentResult(finalAnswer: "42")
        #expect(result.finalAnswer == "42")
    }
    @Test func memoryEntryHasType() {
        let entry = MemoryEntry(
            id: "1",
            content: "fact",
            timestamp: .now(),
            type: "fact"
        )
        #expect(entry.type == "fact")
    }
}
