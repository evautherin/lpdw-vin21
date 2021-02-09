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
    
    
    // Cette fonction n'est pas accessible à l'extérieur de ce fichier source
    // Cette fonction n'a pas besoin de s'appliquer sur une instance de Model on la déclare donc comme une fonction de classe.
    private class func signInFuture(
        withEmail email: String,
        password: String
    ) -> Future<AuthDataResult, Error> {
        
        // Cette fonction retourne un Future de type AuthDataResult ou Error
        Future { promise in
            
            // Le AuthDataResult ou l'Error sont obtenus par l'appel Firebase
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                
                // signIn signale une erreur, on la remonte au travers de la promesse
                if let error = error {
                    promise(.failure(error))
                }
                
                // signIn donne un résultat, on le remonte au travers de la promesse
                if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
    }
    
    
    func signIn(withEmail email: String, password: String) {
        
        // Future = robinet qui emet un seul AuthResult ou Error
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
