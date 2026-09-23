import Foundation

/// Typed error model for all AI provider operations.
///
/// All types conforming to `LLMProvider`, `EmbeddingProvider`, `RAGProvider`, and `MemoryManager`
/// should throw `AIError` values so callers can handle failures uniformly.
public enum AIError: Error, Sendable {
    /// The provider rejected the request due to invalid or missing credentials.
    case authenticationFailure(String)

    /// The provider is rate-limiting the caller. `retryAfterMs` is the suggested wait in milliseconds, if provided.
    case rateLimited(retryAfterMs: Int?) // retry-after in milliseconds

    /// A transient network or transport failure. Callers may retry with the same `requestId`.
    case networkError(underlying: Error)

    /// The request itself is malformed or contains invalid parameters.
    case invalidRequest(String)

    /// The provider returned an unexpected or unrecoverable error.
    case providerFailure(String)

    /// The operation was cancelled by the caller.
    case cancelled
}
