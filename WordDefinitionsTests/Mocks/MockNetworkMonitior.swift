//
//  MockNetworkMonitior.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Combine
@testable import WordDefinitions

class MockNetworkMonitor: NetworkMonitorProtocol {
    private let subject = CurrentValueSubject<Bool, Never>(true)

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    func setConnectionStatus(_ isConnected: Bool) {
        subject.send(isConnected)
    }
}
