import Foundation

struct Radio: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var year: String
    var status: String
    var notes: String
    var dateAdded: Date = Date()
}
