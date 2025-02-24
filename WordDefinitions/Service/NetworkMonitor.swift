//
//  NetworkMonitor.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Combine
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let subject = CurrentValueSubject<Bool, Never>(true)

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.subject.send(path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
