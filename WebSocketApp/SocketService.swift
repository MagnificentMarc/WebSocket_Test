//
//  SocketService.swift
//  WebSocketApp
//
//  Created by Marc Orel on 03.02.22.
//

import Foundation
import SocketIO
import UIKit

final class SocketService: ObservableObject {
    private var socketManager = SocketManager(socketURL: URL(string: "ws://192.168.178.56:3010")!, config: [.log(true), .compress])
    
    public var socket : SocketIOClient?
    
    @Published var responses = [String]()
    @Published var connected = false
    
    init() {
        self.socket = socketManager.defaultSocket
        
        socket?.on(clientEvent: .connect) { [weak self] (data, ack) in
            print("Connected to Node-Express SocketIO-Backend!")

            self?.connected = true
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                self?.socket!.emit("ConnectedToBackend", "\(uuid) connected., SID: \(self?.socket?.sid)")
                self?.responses.append("\(Date()): connected to server.")
            } else {
                self?.socket!.emit("ConnectedToBackend", "Unkown device connected.")
            }
            self?.connected = true
        }
        
        socket?.on(clientEvent: .reconnect) { [weak self]_,_ in
            print("disco")
            self?.connected = false
            
        }
        socket!.on("iOS Client Port") { [weak self] (data, ack) in
            if let data = data[0] as? [String: String],
               let rawMessage = data["msg"] {
                DispatchQueue.main.async {
                    self?.responses.append(rawMessage)
                }
            }
        }
        socket!.on("returnString") { [weak self] (data, ack) in
            if let data = data[0] as? String {
                DispatchQueue.main.async {
                    self?.responses.append(data)
                }
            }
        }
        
        socket?.connect()
    }
    
    public func sendMessageToSocket(msg: String) -> Void {
        if socket != nil {
            socket!.emit("receiveString", msg)
            print(socket!.status)
        }
    }
}
