//
//  NetworkMonitor.swift
//  PirateRadio
//
//  Created by A-Team Intern on 16.07.21.
//

import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor!
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self]
            path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
