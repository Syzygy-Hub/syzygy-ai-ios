import Foundation

/// Abstract interface for conversation context and long-term memory management.
///
/// Implementations should throw `AIError` values to surface storage-specific failures.
public protocol MemoryManager {
    func add(_ entry: MemoryEntry) async throws
    func retrieve(query: String, limit: Int) async throws -> [MemoryEntry]
    func clear() async throws
}
