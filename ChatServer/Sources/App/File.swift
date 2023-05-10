import Vapor

class Room {
    var connections: [User: WebSocket]
    let botUser = User(id: UUID(), name: "Bot")

    func bot(_ text: String) {
        let message = Message(user: botUser, date: Date(), message: text)
        send(message)
    }

    func send(_ message: Message) {
        let allocator = ByteBufferAllocator()
        guard let messageData = try? JSONEncoder().encodeAsByteBuffer(message, allocator: allocator) else { return }

        for (user, socket) in connections {
            guard user != message.user else {
                continue
            }

            //let promise = eventLoop.makePromise(of: Void.self)
            socket.send(messageData)
//            promise.futureResult.whenComplete { result in
//                // Succeeded or failed to send.
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let success):
//                    print(success)
//                }
//            }

        }
    }

    init() {
        connections = [:]
    }
}

