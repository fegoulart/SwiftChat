import Foundation

struct Message: Codable {
    let user: User
    let date: Date?
    let message: String
}
