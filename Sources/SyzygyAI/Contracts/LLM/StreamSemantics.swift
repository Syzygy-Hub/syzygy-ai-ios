import Foundation

/// Defines the stream lifecycle contract for LLM streaming responses.
///
/// ## Completion
/// A stream ends naturally when a chunk carrying a non-nil `finishReason` is emitted.
/// Consumers must drain the stream until the `AsyncThrowingStream` iterator returns `nil`.
///
/// ## Cancellation
/// Callers cancel by dropping or cancelling the `Task` that consumes the stream.
/// Partial results up to the cancellation point are valid; the stream does not emit additional
/// chunks after cancellation is detected.
///
/// ## Partial results
/// Each `LLMChunk` is a valid partial result. Consumers must handle `nil` content gracefully —
/// a chunk may carry only metadata (`finishReason`, `providerName`, `modelName`) without text.
///
/// ## Retry semantics
/// Providers should throw `AIError.networkError` on transient failures. Callers may retry with
/// the same `requestId` to enable correlation of retried requests in tracing and logging.
/// Idempotency guarantees (if any) are provider-specific.
///
/// ## Thread safety
/// `AsyncThrowingStream` is safe to consume from a single `async` context. Sharing the same
/// stream across multiple concurrent consumers is not supported.
public enum StreamContract {
    // Namespace type — no instances. See doc-comment above for the full contract.
}
