import Foundation
import Network
import Combine

/// Observes device connectivity only; this does not represent an API request result.
final class FINDRConnectivity: ObservableObject {
    enum Presentation { case none, fullScreen, toast }
    @Published private(set) var presentation: Presentation = .none
    private let monitor = NWPathMonitor()
    private var receivedInitialPath = false
    private var isConnected = true
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            DispatchQueue.main.async { self?.update(connected: connected) }
        }
        monitor.start(queue: DispatchQueue(label: "com.findr.connectivity"))
    }
    deinit { monitor.cancel() }
    private func update(connected: Bool) {
        isConnected = connected
        if connected { presentation = .none }
        else if !receivedInitialPath { presentation = .fullScreen }
        else if presentation == .none { presentation = .toast }
        receivedInitialPath = true
    }
    func retry() { update(connected: monitor.currentPath.status == .satisfied) }
}
