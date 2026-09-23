[![Platform](https://img.shields.io/badge/iOS-16%2B-7F77DD?style=flat)](https://developer.apple.com/ios/) [![Swift](https://img.shields.io/badge/Swift-6.0-1D9E75?logo=swift&logoColor=white&style=flat)](https://swift.org) [![CI](https://img.shields.io/github/actions/workflow/status/Syzygy-Hub/syzygy-ai-ios/ci.yml?label=ci&style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/actions/workflows/ci.yml) [![Version](https://img.shields.io/badge/version-1.1.0-D85A30?style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/releases) [![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-dark-1200.png">
  <img src="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-light-1200.png" alt="Syzygy" width="600">
</picture>

# syzygy-ai-ios

AI layer contracts for the Syzygy iOS ecosystem. Provides abstract interfaces for LLM integration, agent protocols, RAG pipelines, memory management, and text embeddings.

**v1.1.0 — Extended Contracts**
Adds structured tool calling, a typed error model, operational metadata, stream semantics documentation, RAG/memory contract improvements, and the shared `JSONValue` type.

> **Breaking Changes in v1.1.0**
>
> | Symbol | Change |
> |---|---|
> | `RAGProvider.retrieve(topK:)` | Removed. Replace with `RAGOptions(maxResults:)`: `provider.retrieve(query, options: RAGOptions(maxResults: n))`. |
> | `AIError.rateLimited` | Parameter renamed from `retryAfter: TimeInterval?` (seconds) to `retryAfterMs: Int?` (milliseconds). |
> | `LLMMessage.Role.toolCall` | Removed. Tool calls use `toolCalls` field on `.assistant` messages; tool results use `toolCallResult` on `.tool` messages. |
> | `MemoryManager` namespace methods | Moved to separate `NamespacedMemoryManager` protocol. |

## Version History

| Version | Notes |
|---|---|
| `1.1.0` | Tool calling, `AIError`, `JSONValue`, metadata fields, stream semantics, namespaced memory |
| `1.0.0` | Pure contracts — initial release |

## Contracts

| Name | Description |
|---|---|
| `LLMProvider` | Abstract interface for LLM backend integration |
| `AgentProtocol` | ReAct loop contract (Reason → Act → Observe) |
| `EmbeddingProvider` | Abstract interface for generating text embeddings |
| `RAGProvider` | Retrieval-augmented generation interface |
| `MemoryManager` | Conversation context management contract |

## v1.1.0 — New Contracts

### JSONValue
`JSONValue` is a `Sendable, Codable, Equatable` enum replacing `[String: Any]` in tool contracts. Typealiases `JSONObject` and `JSONArray` are provided.

### Structured Tool Calling
- `ToolCallRequest` — LLM-requested tool invocation (id, name, arguments as `JSONObject`)
- `ToolCallResult` — result returned to the model (toolCallId, content, isError)
- `LLMMessage` gains `toolCalls: [ToolCallRequest]?` (on `.assistant` role) and `toolCallResult: ToolCallResult?` (on `.tool` role)

### AIError
`AIError` is a typed `Error & Sendable` enum covering authentication failures, rate limiting, network errors, invalid requests, provider failures, and cancellation. All provider protocols document that they throw `AIError`.

### Operational Metadata
- `LLMRequest` gains `requestId: String?` and `correlationId: String?`
- `LLMResponse` gains `providerName: String?` and `modelName: String?`
- `LLMChunk` gains `providerName: String?` and `modelName: String?`

### Stream Semantics
`StreamContract` (in `StreamSemantics.swift`) documents the stream lifecycle: completion, cancellation, partial results, retry semantics, and thread safety.

### RAG Improvements
- `RAGChunk` gains `id: String?` (optional; required in v2.0.0), `source: String?`, `documentId: String?`
- `RAGOptions` gains `maxResults: Int?`; `scoreThreshold` is `Double?` (cross-platform consistent)
- `RAGProvider.retrieve` signature is `(_ query: String, options: RAGOptions?) async throws -> [RAGChunk]`

### Memory Improvements
`NamespacedMemoryManager` (separate protocol extending `MemoryManager`) provides: `add(_:namespace:)`, `retrieve(query:namespace:limit:)`, `delete(id:namespace:)`, `clear(namespace:)`. Base `MemoryManager` un-namespaced methods are unchanged.

> **API note — cross-platform naming:** On iOS and Android, `NamespacedMemoryManager` uses the same method names as `MemoryManager` overloaded with a `namespace: String` parameter (`add(_:namespace:)`, `retrieve(query:namespace:limit:)`, `delete(id:namespace:)`, `clear(namespace:)`). React Native follows the same overloaded naming convention. Flutter uses distinct method names — `addToNamespace`, `retrieveFromNamespace`, `deleteEntry`, `clearNamespace` — because Dart does not support method overloading. This divergence is intentional and will not be unified.

### AgentStep.input
`input` is retained as `[String: String]` for backward compatibility. New optional `structuredInput: JSONObject?` field supports typed JSON values. Both will unify to `JSONObject` in v2.0.0.

## Known Limitations / Deviations (v1.1.0)

1. `AgentTool` is marked `@unchecked Sendable` because the `execute` closure cannot be automatically verified as `Sendable` by the Swift 6 compiler. `AgentRequest` is also `@unchecked Sendable` for the same reason.
2. **`AgentStep.input` platform deviation**: iOS retains `input: [String: String]` for backward compatibility while the new `structuredInput: JSONObject?` carries typed values. Android, React Native, and Flutter use a single `JSONObject` field. Both will unify in v2.0.0.

## Installation

```swift
// In Package.swift
.package(url: "https://github.com/Syzygy-Hub/syzygy-ai-ios", from: "1.1.0")

// Add to your target dependencies
.product(name: "SyzygyAI", package: "syzygy-ai-ios")
```

## Requirements

- iOS 16.0+
- Swift 6.0+
- Xcode 16+

> Depends on syzygy-foundation-ios ≥ 1.2.0

## Development Setup

After cloning, install the pre-push hook:

```bash
bash scripts/install-hooks.sh
```

## License

MIT — see [LICENSE](LICENSE)
