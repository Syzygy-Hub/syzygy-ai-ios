[![Platform](https://img.shields.io/badge/iOS-16%2B-7F77DD?style=flat)](https://developer.apple.com/ios/) [![Swift](https://img.shields.io/badge/Swift-6.0-1D9E75?logo=swift&logoColor=white&style=flat)](https://swift.org) [![CI](https://img.shields.io/github/actions/workflow/status/Syzygy-Hub/syzygy-ai-ios/ci.yml?label=ci&style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/actions/workflows/ci.yml) [![Version](https://img.shields.io/badge/version-1.0.0-D85A30?style=flat)](https://github.com/Syzygy-Hub/syzygy-ai-ios/releases) [![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-dark-1200.png">
  <img src="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-light-1200.png" alt="Syzygy" width="600">
</picture>

# syzygy-ai-ios

AI layer contracts for the Syzygy iOS ecosystem. Provides abstract interfaces for LLM integration, agent protocols, RAG pipelines, memory management, and token streaming.

## Contracts

| Name | Description |
|---|---|
| `LLMProvider` | Abstract interface for LLM backend integration |
| `AgentProtocol` | ReAct loop contract (Reason → Act → Observe) |
| `RAGProvider` | Retrieval-augmented generation interface |
| `MemoryManager` | Conversation context management contract |
| `StreamHandler` | Token streaming abstraction |

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
