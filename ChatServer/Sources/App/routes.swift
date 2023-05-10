import Vapor

var clients: [ChatId: [String]] = [:]

typealias ChatId = Int

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
        let chatId: ChatId = 0
        clients[chatId] = []

        ws.onText { ws, text in
            print(text)
//            clients[ws]?.append(text)
//            for client in clients {
//                for message in client.value {
//                    client.key.send(message)
//                }
//            }
        }
        ws.onBinary { ws, binary in
            if let message: Message = try? JSONDecoder().decode(Message.self, from: binary) {
                room.connections[message.user] = ws
                room.send(timestampMessage(message))
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

//extension WebSocket: Hashable {
//    public static func == (lhs: WebSocketKit.WebSocket, rhs: WebSocketKit.WebSocket) -> Bool {
//        lhs === rhs
//    }
//
//    public func hash(into hasher: inout Hasher) {
//            hasher.combine(self)
//        }
//
//}
