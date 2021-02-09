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
    
    // Model doit maintenir un ensemble de "plomberies" (robinet -> lavabo)
    var subscriptions = Set<AnyCancellable>()
    
    var connected: AnyPublisher<Bool, Never> {
        user.publisher
            .map { (user: User?) -> Bool in
                user != .none
            }
            .print("connected")
            .eraseToAnyPublisher()
    }
    
    
    // Cette fonction n'est pas accessible à l'éxtérieur de ce fichier source
    // Cette fonction n'a pas besoin de s'appliquer sur une instance de Model on la déclare donc comme une fonction de classe.
    private class func signInFuture(
        withEmail email: String,
        password: String
    ) -> Future<AuthDataResult, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                }
                
                if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
    }
    
    
    func signIn(withEmail email: String, password: String) {
        
        // Robinet qui emet un AuthResult ou Error
        Model.signInFuture(withEmail: email, password: password)
            
            // Lavabo a 2 bacs pour récupérer ce qui sort du robinet
            .sink { (completion) in // Bac des erreurs
                switch (completion) {
                case .finished: break
                case .failure(let error): print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { (authResult) in // Bac des authResult
                self.user = authResult.user
            }
            
            // Maintenir cette "plomberie" dans subscriptions
            .store(in: &subscriptions)

    }
}
