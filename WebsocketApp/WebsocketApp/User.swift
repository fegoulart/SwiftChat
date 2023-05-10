import Foundation

struct User: Codable {
    let id: UUID
    let name: String

    static let defaultUser = User(id: UUID(), name: "John Doe")
}
