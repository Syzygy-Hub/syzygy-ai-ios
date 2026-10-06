# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [3.0.0] - 2026-10-06

### Breaking Changes
- **BREAKING:** `RAGProvider.retrieve` is now `retrieve(_ query: String, options: RAGOptions) async throws -> [RAGChunk]`. The `topK` parameter is removed; use the new `RAGOptions.maxResults` (default 10, clamped to >= 1). A `retrieve(_:)` convenience extension uses default options.
- **BREAKING:** `ToolCallRequest` is removed; `ToolCall` (id, name, arguments with default `[:]`) is the single tool-invocation type. `LLMMessage.toolCalls` is now `[ToolCall]?`.
- **BREAKING:** `NamespacedMemoryManager` methods renamed for cross-platform alignment: `add(_:namespace:)` -> `addToNamespace(entry:namespace:)`, `retrieve(query:namespace:limit:)` -> `retrieveFromNamespace(query:namespace:limit:)`, `delete(id:namespace:)` -> `deleteEntry(id:namespace:)`, `clear(namespace:)` -> `clearNamespace(namespace:)`.

### Added
- `ToolCall` (id, name, arguments; `Sendable, Codable, Equatable`) and `LLMResponse.toolCalls: [ToolCall]?`.
- `LLMRequest.tools: [AgentTool]?` (default `nil`).
- `RAGOptions.maxResults`.

### Changed
- `AgentTool.inputSchema` and `execute` input now use `JSONObject` (`[String: JSONValue]`); `ToolSchema` and `ToolInput` remain as typealiases to `JSONObject`.
- `AgentTool` and `AgentRequest` are now plain `Sendable` (no longer `@unchecked Sendable`); `AgentTool.execute` is a `@Sendable` async closure.
- `LLMProvider`, `EmbeddingProvider`, `RAGProvider`, `MemoryManager`, `NamespacedMemoryManager` and `AgentProtocol` are now explicitly `Sendable`.
- `AgentRequest.maxSteps` (default 10) is clamped to a minimum of 1.
- `SyzygyAI.version` added ("3.0.0"); `SyzygyAIVersion.current` now references it so the two cannot drift.
- Minimum `syzygy-foundation-ios` is now 3.0.0.

## [1.1.0] - 2026-09-24

### Breaking Changes
- **`AIError.rateLimited` parameter renamed** from `retryAfter: TimeInterval?` (seconds) to `retryAfterMs: Int?` (milliseconds) for cross-platform consistency.
- **`AgentStep.input` reverted** to `[String: String]` (backward compat); use new `structuredInput: JSONObject?` for typed values.
- **`MemoryManager` namespace methods moved** to separate `NamespacedMemoryManager` protocol.
- **`LLMMessage.Role.toolCall` removed**; tool calls use `toolCalls: [ToolCallRequest]?` on `.assistant` messages; tool results use `toolCallResult: ToolCallResult?` on `.tool` messages.

### Added
- `RAGChunk.id: String?` — optional chunk identifier
- `NamespacedMemoryManager` — separate protocol extending `MemoryManager` with namespace methods: `add(_:namespace:)`, `retrieve(query:namespace:limit:)`, `delete(id:namespace:)`, `clear(namespace:)`
- `AgentStep.structuredInput: JSONObject?` — additive v1.1.0 field for typed JSON values alongside backward-compat `input: [String: String]`; both unify to `JSONObject` in v2.0.0
- `JSONValue` — `Sendable, Codable, Equatable` enum with `JSONObject` / `JSONArray` typealiases
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
- `RAGChunk` — added `id: String?` (optional chunk ID), `source: String?` (citation), `documentId: String?` (parent doc)
- `RAGOptions` — `scoreThreshold` is `Double?` (cross-platform consistent)
- `AgentStep` — `input` retained as `[String: String]` for backward compat; new `structuredInput: JSONObject?` additive field for typed values

## [1.0.0] - 2026-09-22

### Added
- `LLMProvider` — abstract interface for LLM backend integration
- `AgentProtocol` — ReAct loop contract (Reason → Act → Observe)
- `RAGProvider` — retrieval-augmented generation interface
- `MemoryManager` — conversation context management contract

[Unreleased]: https://github.com/Syzygy-Hub/syzygy-ai-ios/compare/3.0.0...HEAD
[3.0.0]: https://github.com/Syzygy-Hub/syzygy-ai-ios/compare/1.1.0...3.0.0
[1.1.0]: https://github.com/Syzygy-Hub/syzygy-ai-ios/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/Syzygy-Hub/syzygy-ai-ios/releases/tag/1.0.0
