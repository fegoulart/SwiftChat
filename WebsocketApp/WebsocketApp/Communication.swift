import Foundation

// https://www.donnywals.com/real-time-data-exchange-using-web-sockets-in-ios-13/
class Communication: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    var socketConnection: URLSessionWebSocketTask?
    let session = URLSession.shared
    let url = URL(string: "ws://127.0.0.1:8080/chat")!

    override init() {
        super.init()
        connectToSocket()
    }

    func connectToSocket() {
        socketConnection = URLSession.shared.webSocketTask(with: url)
        socketConnection?.resume()
        register(User.defaultUser)
        setReceiveHandler()
    }

    func sendMessage(_ message: Message) {
      do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        let message = URLSessionWebSocketTask.Message.data(data)

        socketConnection?.send(message) { error in
          if let error = error {
            // handle the error
            print(error)
          }
        }
      } catch {
        // handle the error
        print(error)
      }
    }

    func setReceiveHandler() {
      socketConnection?.receive { result in
        defer { self.setReceiveHandler() }

        do {
          let message = try result.get()
          switch message {
          case let .string(string):
            print(string)
          case let .data(data):
              if let receiveMessage: Message = try? JSONDecoder().decode(Message.self, from: data) {
                  print(receiveMessage)
              }
          @unknown default:
            print("unkown message received")
          }
        } catch {
          // handle the error
          print(error)
        }
      }
    }

    func register(_ user: User) {
        do {
            let encoder = JSONEncoder()
            let registerMessage = Message(user: user, date: nil, message: "")
            let data = try encoder.encode(registerMessage)
            let message = URLSessionWebSocketTask.Message.data(data)

            socketConnection?.send(message) { error in
                if let error = error {
                    // handle the error
                    print(error)
                }
            }
        } catch {
            // handle the error
            print(error)
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {

    }


    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {

    }
}

