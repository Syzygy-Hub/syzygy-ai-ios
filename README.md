[![Platform](https://img.shields.io/badge/iOS-16%2B-7F77DD?style=flat)](https://developer.apple.com/ios/) [![Swift](https://img.shields.io/badge/Swift-6.0-1D9E75?logo=swift&logoColor=white&style=flat)](https://swift.org) [![CI](https://img.shields.io/github/actions/workflow/status/Syzygy-Hub/syzygy-ai-ios/ci.yml?label=ci&style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/actions/workflows/ci.yml) [![Version](https://img.shields.io/badge/version-1.1.0-D85A30?style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/releases) [![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-dark-1200.png">
  <img src="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-light-1200.png" alt="Syzygy" width="600">
</picture>

# syzygy-ai-ios

The AI layer of the Syzygy ecosystem — providing LLMProvider, AgentProtocol, EmbeddingProvider, RAGProvider, and MemoryManager contracts for iOS.

> **v1.1.0 — Extended Contracts**
> Adds structured tool calling, a typed error model, operational metadata, stream semantics documentation, RAG/memory contract improvements, and the shared `JSONValue` type.
>
> `RAGChunk.id: String?` is now an optional field (null by default). It will become required in v2.0.0.

> **v1.0.0 — Pure Contracts Only**
> This release contains protocol and struct definitions only. No concrete implementations are included. Implementations targeting specific LLM backends, vector stores, or memory systems should depend on this package and provide their own conforming types.

> **Breaking Changes in v1.1.0**
>
> | Symbol | Change |
> |---|---|
> | `RAGProvider.retrieve(topK:)` | Removed. Replace with `RAGOptions(maxResults:)`: `provider.retrieve(query, options: RAGOptions(maxResults: n))`. |
> | `AIError.rateLimited` | Parameter renamed from `retryAfter: TimeInterval?` (seconds) to `retryAfterMs: Int?` (milliseconds). |
> | `LLMMessage.Role.toolCall` | Removed. Tool calls use `toolCalls` field on `.assistant` messages; tool results use `toolCallResult` on `.tool` messages. |
> | `MemoryManager` namespace methods | Moved to separate `NamespacedMemoryManager` protocol. |

## About

syzygy-ai-ios defines the AI contracts that downstream modules implement. It depends only on `syzygy-foundation-ios` and provides the abstraction layer for LLM backends, agent loops, retrieval-augmented generation, memory management, and token streaming. No concrete implementations ship here — conforming implementations live in dedicated service modules.

## Role in the Syzygy Ecosystem

`syzygy-ai-ios` is a peer layer that depends on Foundation and nothing else. It exposes AI contracts that application modules and AI service implementations depend on.

Full ecosystem architecture: [ecosystem-fragment.md](https://github.com/Syzygy-Hub/.github/blob/main/docs/ecosystem-fragment.md)

### Contracts

| Contract | Description |
|---|---|
| `LLMProvider` | Abstract interface for LLM backend integration |
| `AgentProtocol` | ReAct loop contract (Reason → Act → Observe) |
| `RAGProvider` | Retrieval-augmented generation interface |
| `MemoryManager` | Conversation context management contract |
| `EmbeddingProvider` | Abstract interface for generating text embeddings |

### NamespacedMemoryManager

`NamespacedMemoryManager` extends `MemoryManager` with namespace-scoped operations. On iOS, Android, and React Native, namespace variants use **overloaded method names** — the same verb as the base `MemoryManager` method with an additional `namespace` parameter (e.g. `add(_:namespace:)`, `retrieve(query:namespace:limit:)`). Flutter uses **distinct method names** (`addToNamespace`, `retrieveFromNamespace`, `deleteEntry`, `clearNamespace`) because Dart does not support method overloading.

## What's New in v1.1.0

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

### AgentStep.input

`input` is retained as `[String: String]` for backward compatibility. New optional `structuredInput: JSONObject?` field supports typed JSON values. Both will unify to `JSONObject` in v2.0.0.

## Known Limitations / Deviations (v1.1.0)

1. `AgentTool` is marked `@unchecked Sendable` because the `execute` closure cannot be automatically verified as `Sendable` by the Swift 6 compiler. `AgentRequest` is also `@unchecked Sendable` for the same reason.
2. **`AgentStep.input` platform deviation**: iOS retains `input: [String: String]` for backward compatibility while the new `structuredInput: JSONObject?` carries typed values. Android, React Native, and Flutter use a single `JSONObject` field. Both will unify in v2.0.0.

## Release Process

Releases follow the Syzygy tag-push release flow:

1. Create a `release/X.X.X` branch
2. Bump the version in `syzygy.yml`, `SyzygyAIVersion.swift`, the README badge, and `CHANGELOG.md`
3. Open a PR to `main` and wait for CI to pass
4. Merge the PR
5. Push the tag: `git tag X.X.X` and `git push origin X.X.X`
6. The tag push triggers the org-level release workflow which validates `syzygy.yml` matches the tag, extracts the CHANGELOG entry, and creates the GitHub Release.

For the full release standard see the [Syzygy-Hub/.github release standard](https://github.com/Syzygy-Hub/.github/blob/main/engineering/standards/release-standard.md).

## Platforms

| Platform | Min Version | Package Manager | Status |
|---|---|---|---|
| iOS | 16.0+ | Swift Package Manager | ✅ Supported |

## Requirements

- iOS 16.0+
- Swift 6.0+
- Xcode 16+

## Installation

```swift
// In Package.swift
.package(url: "https://github.com/Syzygy-Hub/syzygy-ai-ios", from: "1.1.0")

// Add to your target dependencies
.product(name: "SyzygyAI", package: "syzygy-ai-ios")
```

## Foundation Dependency

`syzygy-ai-ios` depends on `syzygy-foundation-ios` via Swift Package Manager (transitive), so you do not need to declare Foundation separately when you already depend on AI.

**Depends on:** `syzygy-foundation-ios` >= 1.2.0

**Used by:** application modules and AI service implementations.

## Development Setup

After cloning, install the pre-push hook to run a Swift build check before every push:

```bash
bash scripts/install-hooks.sh
```

The hook runs `swift build` and blocks the push if the build fails. To bypass in an emergency: `git push --no-verify`.

## Contributing

Contributions are welcome. Please follow the [Syzygy engineering standards](https://github.com/Syzygy-Hub/.github/tree/main/engineering/standards) when submitting pull requests.

## License

MIT — see [LICENSE](LICENSE)
