//
//  Verknüpfung.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 09.02.24.
//

import SwiftUI
import Foundation
import Network
import UIKit

let server = try? Server()

class Server {

    let listener: NWListener

    var connections: [Connection] = []

    init() throws {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        listener = try NWListener(using: parameters)
        
        listener.service = NWListener.Service(name: "server", type: "_superapp._tcp")
    }

    func start() {
        listener.stateUpdateHandler = { newState in
            log("listener.stateUpdateHandler \(newState)")
        }
        listener.newConnectionHandler = { [weak self] newConnection in
            log("listener.newConnectionHandler \(newConnection)")
            let connection = Connection(connection: newConnection)
            self?.connections += [connection]
        }
        listener.start(queue: .main)
    }

    func send(message: String) {
        connections.forEach {
            $0.send(message)
        }
    }
    
    func receive() {
        connections.forEach { connection in
            connection.receiveMessage()
        }
    }
}

let browser = Browser()

class Browser {

    let browser: NWBrowser

    init() {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true

        browser = NWBrowser(for: .bonjour(type: "_superapp._tcp", domain: nil), using: parameters)
    }

    func start(handler: @escaping (NWBrowser.Result) -> Void) {
        browser.stateUpdateHandler = { newState in
            log("browser.stateUpdateHandler \(newState)")
        }
        browser.browseResultsChangedHandler = { results, changes in
            for result in results {
                if case NWEndpoint.service = result.endpoint {
                    handler(result)
                }
            }
        }
        browser.start(queue: .main)
    }
}

var sharedConnection: Connection?

class Connection {
    @AppStorage("receivetext") var receivetext = ""
    
    let connection: NWConnection

    // outgoing connection
    init(endpoint: NWEndpoint) {
        log("PeerConnection outgoing endpoint: \(endpoint)")
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        connection = NWConnection(to: endpoint, using: parameters)
        start()
    }

    // incoming connection
    init(connection: NWConnection) {
        log("PeerConnection incoming connection: \(connection)")
        self.connection = connection
        start()
    }

    func start() {
        connection.stateUpdateHandler = { newState in
            log("connection.stateUpdateHandler \(newState)")
            if case .ready = newState {
                DispatchQueue.main.async {
                    self.receiveMessage()
                }
            }
        }
        connection.start(queue: .main)
    }

    func send(_ message: String) {
        connection.send(content: message.data(using: .utf8), contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
            log("Connection send error: \(String(describing: error))")
        }))
    }

    func receiveMessage() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 100) { data, _, _, _ in
            if let data = data,
               let message = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    log("Connection receiveMessage message: \(message)")
                    self.receivetext = message
                    print(message)
                }
            }
            self.receiveMessage()
        }
    }
}

let clienT = Client()

class Client {

    let browser = Browser()

    var connection: Connection?

    func start() {
        browser.start { [weak self] result in
            guard let self = self,
                  self.connection == nil else { return }
            log("client.handler result: \(result)")
            self.connection = Connection(endpoint: result.endpoint)
        }
    }

}

struct Verknupfung: View {
    @AppStorage("verknüpfungstart") var verknüpfungstart = 0
    @State var showSpacer = true
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State var sendtext = ""
    @AppStorage("receivetext") var receivetext = ""
    
    var body: some View {
        VStack {
            if verknüpfungstart == 0 {
                Text("Instalation")
                    .font(.title)
                Spacer()
                Text("Mit dem neuen Update können Daten zwischen Schülern und Lehrern ausgetauscht werden: \nDafür müssen Sie folgende Schrittte durchführen")
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Der Datenaustausch")
                    .font(.title2)
                HStack {
                    Image(systemName: "ipad.homebutton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 150, maxHeight: 150)
                    if showSpacer {
                        Spacer()
                    } else {
                        Image(systemName: "arrow.left.and.right")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, maxHeight: 100)
                    }
                    Image(systemName: "iphone.homebutton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 150, maxHeight: 150)
                }
            } else {
                Text("Schritt \(verknüpfungstart)")
                    .font(.title)
                Spacer()
                if verknüpfungstart == 1 {
                    Text("Erlauben Sie den Zugriff auf das Lokale Netzwerk, damit Sie die anderen Geräte sehen können")
                        .multilineTextAlignment(.center)
                    Image(systemName: "network.badge.shield.half.filled")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500, maxHeight: 500)
                } else {
                    TextField("Text", text: $sendtext)
                    Text("Received Text: \(receivetext)")
                }
            }
            Spacer()
            Button(action: {
                if verknüpfungstart >= 1 {
                    server?.start()
                    if verknüpfungstart == 2 {
                        clienT.start()
                        server?.send(message: sendtext)
                        server?.receive()
                    }
                }
                if verknüpfungstart == 0 || verknüpfungstart == 1{
                    verknüpfungstart += 1
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 50)
                    if verknüpfungstart == 1 {
                        Text("Erlauben")
                            .foregroundStyle(.white)
                    } else {
                        Text("Weiter")
                            .foregroundStyle(.white)
                    }
                }
            })
            .padding(20)
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                showSpacer.toggle()
            }
        }
    }
}


