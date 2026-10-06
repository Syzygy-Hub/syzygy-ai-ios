import Foundation

/// Extension of `MemoryManager` that supports logical partitioning of memory
/// by namespace (e.g. per user, per session).
///
/// Implementations of `NamespacedMemoryManager` also satisfy the base `MemoryManager`
/// protocol; un-namespaced methods should default to the `"default"` namespace for
/// backward compatibility.
public protocol NamespacedMemoryManager: MemoryManager, Sendable {
    /// Store `entry` in the given `namespace`.
    func addToNamespace(entry: MemoryEntry, namespace: String) async throws

    /// Retrieve up to `limit` entries matching `query` from `namespace`.
    /// Pass `nil` for `limit` to use the implementation's default.
    func retrieveFromNamespace(query: String, namespace: String, limit: Int?) async throws -> [MemoryEntry]

    /// Delete the entry with the given `id` from `namespace`.
    func deleteEntry(id: String, namespace: String) async throws

    /// Remove all entries from `namespace`.
    func clearNamespace(namespace: String) async throws
}
