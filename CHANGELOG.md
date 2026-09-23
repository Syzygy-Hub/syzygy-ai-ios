# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.1.0] - 2026-09-24

### Breaking Changes
- **`RAGProvider.retrieve(topK:)` is removed.** The `topK` parameter no longer exists on the retrieve call. Callers must pass `RAGOptions(maxResults:)` instead: `provider.retrieve(query, options: RAGOptions(maxResults: n))`.
- **`AIError.rateLimited` parameter renamed** from `retryAfter: TimeInterval?` (seconds) to `retryAfterMs: Int?` (milliseconds) for cross-platform consistency.
- **`AgentStep.input` reverted** to `[String: String]` (backward compat); use new `structuredInput: JSONObject?` for typed values.
- **`MemoryManager` namespace methods moved** to separate `NamespacedMemoryManager` protocol.
- **`LLMMessage.Role.toolCall` removed**; tool calls use `toolCalls: [ToolCallRequest]?` on `.assistant` messages; tool results use `toolCallResult: ToolCallResult?` on `.tool` messages.

### Added
- `RAGChunk.id: String?` — optional chunk identifier (required in v2.0.0)
- `NamespacedMemoryManager` — separate protocol extending `MemoryManager` with namespace methods: `add(_:namespace:)`, `retrieve(query:namespace:limit:)`, `delete(id:namespace:)`, `clear(namespace:)`
- `AgentStep.structuredInput: JSONObject?` — additive v1.1.0 field for typed JSON values alongside backward-compat `input: [String: String]`; both unify to `JSONObject` in v2.0.0
- `JSONValue` — `Sendable, Codable, Equatable` enum with `JSONObject` / `JSONArray` typealiases; replaces `[String: Any]` in tool contracts
- `ToolCallRequest` — structured tool invocation type (id, name, arguments as `JSONObject`)
- `ToolCallResult` — tool result type returned to the LLM (toolCallId, content, isError)
- `AIError` — typed `Error & Sendable` enum covering auth failures, rate limiting, network errors, invalid requests, provider failures, and cancellation
- `StreamContract` (StreamSemantics.swift) — documentation-as-code namespace defining stream lifecycle: completion, cancellation, partial results, retry, thread safety
- `SyzygyAIVersion.current` — version constant ("1.1.0") for the AI layer

### Changed
- `LLMMessage` — added `toolCalls: [ToolCallRequest]?` and `toolCallResult: ToolCallResult?` fields (backward compatible); toolCall role removed — tool calls use toolCalls field on assistant messages; tool results use toolCallResult field on tool messages
- `LLMRequest` — added `requestId: String?` and `correlationId: String?` fields
- `LLMResponse` — added `providerName: String?` and `modelName: String?` fields
- `LLMChunk` — added `providerName: String?` and `modelName: String?` fields
- `RAGChunk` — added `id: String` (stable chunk ID), `source: String?` (citation), `documentId: String?` (parent doc)
- `RAGOptions` — `scoreThreshold` is `Double?` (cross-platform consistent); added `maxResults: Int?`
- `RAGProvider.retrieve` — signature changed to `(_ query: String, options: RAGOptions?) async throws -> [RAGChunk]`
- `AgentStep` — `input` retained as `[String: String]` for backward compat; new `structuredInput: JSONObject?` additive field for typed values

## [1.0.0] - 2026-09-22

### Added
- `LLMProvider` — abstract interface for LLM backend integration
- `AgentProtocol` — ReAct loop contract (Reason → Act → Observe)
- `RAGProvider` — retrieval-augmented generation interface
- `MemoryManager` — conversation context management contract
- `StreamHandler` — token streaming abstraction
