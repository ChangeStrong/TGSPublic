//
//  TGNetworkManager.swift
//  Alamofire
//
//  Created by luo luo on 2024/11/13.
//

import UIKit
import Network
public class TGNetworkManager: ObservableObject {
    public static let shared = TGNetworkManager()
    public let monitor = NWPathMonitor()
    public let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = false
    public  enum UpdateType {
        case unknow
        case connected
        case disconnect
    }
    public typealias UpdateBlock = (_ type: UpdateType) -> Void
    public var updateBlockDict:[String:UpdateBlock] = [:]
    public var currentType:UpdateType = .unknow
    public init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            if self.isConnected {
                print("网络连接已建立")
                self.currentType = .connected
            } else {
                print("没有可用的网络连接")
                self.currentType = .disconnect
            }
            DispatchQueue.main.async {
                //回调
                for item in self.updateBlockDict.values {
                    item(self.currentType)
                }
            }
            
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    func removeBlockForKey(_ key:String) -> Void {
        if self.updateBlockDict.keys.contains(key) {
            self.updateBlockDict.removeValue(forKey: key)
        }
    }
    
}
