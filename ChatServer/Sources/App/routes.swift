import Vapor

struct Message: Codable {
    let user: User
    let date: Date?
    let message: String
}

struct User: Codable, Hashable {
    let id: UUID
    let name: String
}

let firstUser: User = User(id: UUID(), name: "José da Silva")
let room = Room()

func routes(_ app: Application) throws {

    // ws://127.0.0.1:8080/chat
    app.webSocket("chat") { req, ws in

        ws.onBinary { ws, binary in
            if let message: Message = try? JSONDecoder().decode(Message.self, from: binary) {
                if message.message == "" {
                    room.connections[message.user] = ws
                } else {
                    room.send(timestampMessage(message))
                }
            }
        }

        ws.onPing { ws in

        }

        ws.onPong { ws in

        }

    }

    app.webSocket("chat/register") { req, ws in
        ws.onBinary { ws, binary in
            if let message: Message = try? JSONDecoder().decode(Message.self, from: binary) {
                room.connections[message.user] = ws
            }
        }
    }
}

func timestampMessage(_ message: Message) -> Message {
    return Message(user: message.user, date: Date(), message: message.message)
}
