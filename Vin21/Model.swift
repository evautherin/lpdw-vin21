//
//  Model.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import Foundation
import SwiftUI
import Combine
import Firebase


class Model: ObservableObject {
    @Published var user: User?
    
    var connected: AnyPublisher<Bool, Never> {
        user.publisher
            .map { (user: User?) -> Bool in
                user != .none
            }
            .print("connected")
            .eraseToAnyPublisher()
    }
}
