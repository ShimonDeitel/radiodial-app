import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Radio] = []
    @Published var isPro: Bool = false

    static let freeLimit = 20

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("radiodial_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Radio) {
        items.append(item)
        save()
    }

    func update(_ item: Radio) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Radio) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Radio].self, from: data) {
            items = decoded
        } else {
            items = [
        Radio(name: "Zenith Trans-Oceanic", year: "1954", status: "Working", notes: "New tubes"),
        Radio(name: "Philco Cathedral", year: "1931", status: "Restoring", notes: "Needs capacitors"),
        Radio(name: "RCA Victor 66X", year: "1946", status: "Not Working", notes: "Dead speaker"),
        Radio(name: "Grundig Majestic", year: "1958", status: "Working", notes: "Great tone"),
        Radio(name: "Crosley 11-104U", year: "1938", status: "Restoring", notes: "Sourcing dial glass")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
