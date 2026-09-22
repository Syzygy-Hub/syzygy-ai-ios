import Foundation

public protocol MemoryManager {
    func add(_ entry: MemoryEntry) async throws
    func retrieve(query: String, limit: Int) async throws -> [MemoryEntry]
    func clear() async throws
}
