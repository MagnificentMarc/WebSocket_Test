//
//  ContentView.swift
//  WebSocketApp
//
//  Created by Marc Orel on 03.02.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var service = SocketService()
    private var imageNames = ["wifi", "network", "antenna.radiowaves.left.and.right"]
    @State private var message = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Erhaltene Nachrichten von Node-Express-Server").font(.title)
            HStack() {
                
                ForEach(imageNames, id: \.self) { imgName in
                    
                    Image(systemName: imgName).foregroundColor(service.connected ? .green : .gray)

                }
            }.frame(maxWidth: .infinity)
            
            Form {
                ForEach(service.responses, id: \.self) { res in
                    Text(">> \(res)").font(.footnote)
                }

                TextField(text: $message, prompt: Text("Enter Message")) {
                }
                Button("Send message") {
                    service.sendMessageToSocket(msg: message)
                    message = ""
                }
            }

            
            
            

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
