[![Platform](https://img.shields.io/badge/iOS-16%2B-7F77DD?style=flat)](https://developer.apple.com/ios/) [![Swift](https://img.shields.io/badge/Swift-6.0-1D9E75?logo=swift&logoColor=white&style=flat)](https://swift.org) [![CI](https://img.shields.io/github/actions/workflow/status/Syzygy-Hub/syzygy-ai-ios/ci.yml?label=ci&style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/actions/workflows/ci.yml) [![Version](https://img.shields.io/badge/version-1.0.0-D85A30?style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/releases) [![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-dark-1200.png">
  <img src="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-light-1200.png" alt="Syzygy" width="600">
</picture>

# syzygy-ai-ios

AI layer contracts for the Syzygy iOS ecosystem. Provides abstract interfaces for LLM integration, agent protocols, RAG pipelines, memory management, and text embeddings.

**v1.0.0 — Pure Contracts Only**
This release contains protocol and type definitions only. No concrete implementations are included. Implementations targeting specific LLM backends, vector stores, or memory systems should depend on this package and provide their own conforming types.

## Contracts

| Name | Description |
|---|---|
| `LLMProvider` | Abstract interface for LLM backend integration |
| `AgentProtocol` | ReAct loop contract (Reason → Act → Observe) |
| `EmbeddingProvider` | Abstract interface for generating text embeddings |
| `RAGProvider` | Retrieval-augmented generation interface |
| `MemoryManager` | Conversation context management contract |

## Known Limitations (v1.0.0)

1. `AgentStep.input` is `[String: String]` instead of `[String: Any]` — `Any` is not `Sendable` in Swift 6. This is a v1.0.0 limitation; a future release may introduce a `Sendable`-compatible value type.
2. `AgentTool` is marked `@unchecked Sendable` because the `execute` closure cannot be automatically verified as `Sendable` by the Swift 6 compiler. `AgentRequest` is also `@unchecked Sendable` for the same reason.

## Installation

```swift
// In Package.swift
.package(url: "https://github.com/Syzygy-Hub/syzygy-ai-ios", from: "1.0.0")

// Add to your target dependencies
.product(name: "SyzygyAI", package: "syzygy-ai-ios")
```

## Requirements

- iOS 16.0+
- Swift 6.0+
- Xcode 16+

> Depends on syzygy-foundation-ios ≥ 1.2.0

## License

MIT — see [LICENSE](LICENSE)
