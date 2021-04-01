// Created by Ina Statkic in 2021.

import Foundation
import Combine
import SwiftUI

final class Resource<A>: ObservableObject {
//    var cancellable = Set<AnyCancellable>()
    var objectWillChange = PassthroughSubject<A?, Never>()
    var endpoint: Endpoint<A>
    var value: A? {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send(self.value)
            }
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func set(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
    
    // Combine URLSession
//    func load() {
//        URLSession.shared.load(endpoint)
//            .sink(receiveCompletion: { _ in
//        }, receiveValue: {
//            self.value = $0
//        }).store(in: &cancellable)
//    }
}
