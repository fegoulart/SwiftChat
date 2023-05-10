//
//  ContentView.swift
//  WebsocketApp
//
//  Copyright © 2023 Alelo. All rights reserved.
//


import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var communication: Communication
    let user = User(id: UUID(), name: "Fernando")

    var body: some View {
        NavigationView {
            VStack {
                Button("Send message") {
                    communication.sendMessage(Message(user: user, date: nil, message: "It works"))
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

