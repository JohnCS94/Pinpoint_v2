//
//  ContentView.swift
//  Pinpoint
//
//  Created by John Scipion on 2/18/24.
//

import SwiftUI
import SocketIO
import Combine

class SocketIOManager: ObservableObject {
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    lazy var socket: SocketIOClient = manager.defaultSocket
    
    @Published var isTested = false
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            setupSocket()
        }
        
        private func setupSocket() {
            socket.on("stamp_response") { [weak self] data, ack in
                // Handle response from the server
                if let message = data.first as? String {
                    print("Response message:", message)
                }
                DispatchQueue.main.async {
                    self?.isTested = true
                }
            }
            socket.connect()
        }
        
        func emitTest() {
            socket.emit("test")
        }
}

struct ContentView: View {
    @StateObject var socketManager = SocketIOManager()
    @State private var isTested = false

    
    var body: some View {
        VStack {
            Text("Welcom, world!")
            Button(action: {
                socketManager.socket.emit("stamp")
                isTested = true
            }) {
                Text("Test")
            }
            if isTested {
                Text("Tested")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
