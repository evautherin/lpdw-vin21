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
    @Published var collection: CollectionReference?
    @Published var wines = [Wine]()
    
    // Model doit maintenir un ensemble de "plomberies" (robinet -> lavabo)
    var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        Auth.auth().userPublisher
            .assign(to: &$user)
//            .assign(to: \.user, on: self)
//            .store(in: &subscriptions)

        $user
            .compactMap { $0 }
            .map { Firestore.firestore().collection($0.uid) }
            .assign(to: &$collection)
//            .assign(to: \.collection, on: self)
//            .store(in: &subscriptions)

        $collection
            .compactMap { $0 }
            .map { $0.items(ofType: Wine.self) }
            .switchToLatest()
            .handleEvents(receiveCompletion: handleCompletionError)
            .replaceError(with: [])
            .assign(to: &$wines)
//            .assign(to: \.wines, on: self)
//            .store(in: &subscriptions)
    }
    
    
    
    // Si user n'est pas défini, noSignedUser prend la valeur true
    // Si user est défini, noSignedUser prend la valeur false
    var noSignedUser: Bool {
        user == .none
    }
    
    
    func handleCompletionError(completion: Subscribers.Completion<Error>) {
        switch (completion) {
        case .finished: break
        case .failure(let error): print("Error: \(error.localizedDescription)")
        }
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
//                self.user = authResult.user
//                self.getWines()
            }
            
            // Maintenir cette "plomberie" dans subscriptions
            .store(in: &subscriptions)

    }
    
    
    // Cette fonction n'est pas accessible à l'extérieur de ce fichier source
    // Cette fonction n'a pas besoin de s'appliquer sur une instance de Model on la déclare donc comme une fonction de classe.
    private class func signOutFuture() -> Future<(), Error> {
        
        // Cette fonction retourne un Future de type () ou Error
        Future { promise in
            
            // Le () ou l'Error sont obtenus par l'appel Firebase
            do {
                try Auth.auth().signOut()
                // SignOut réussi
                promise(.success(()))
            } catch {
                // Récupération d'une exception lors du sign out
                promise(.failure(error))
            }
        }
    }
    
    
    func signOut() {
        
        // Future = robinet qui emet un seul () ou Error
        Model.signOutFuture()
            
            // Lavabo a 2 bacs pour récupérer ce qui sort du robinet
            .sink { (completion) in // Bac des erreurs
                switch (completion) {
                case .finished: break
                case .failure(let error): print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in // Bac des ()
                self.user = .none
            }
            
            // Maintenir cette "plomberie" dans subscriptions
            .store(in: &subscriptions)

    }
    
    
    func add(wine: Wine) {
        guard let wineCollection = collection else { return }
        
        do {
            _ = try wineCollection.addDocument(from: wine)
        } catch {
            print("Add wine error: \(error.localizedDescription)")
        }
    }
    
    
    func deleteWine(id: String) {
        guard let wineCollection = collection else { return }

        wineCollection.document(id).delete()
    }
    
    
//    func getWines() {
//        guard let wineCollection = wineCollection else { return }
//
//        wineCollection.addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//              print("No documents")
//              return
//            }
//
//            self.wines = documents
//                .compactMap { queryDocumentSnapshot -> Wine? in
//                    return try? queryDocumentSnapshot.data(as: Wine.self)
//                }
//                .sorted { (wine0, wine1) -> Bool in
//                    wine0.title < wine1.title
//                }
//          }
//    }
    
    // Robinet qui émet un nouveau [Wine] pour chaque changement dans les documents de collection
    func winesFromCollection(
        _ collection: CollectionReference
    ) -> AnyPublisher<[Wine], Error> {
        
        let winesSubject = PassthroughSubject<[Wine], Error>()

        let registration = collection.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                winesSubject.send(completion: .failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
              
            let wines = documents.compactMap { queryDocumentSnapshot -> Wine? in
                try? queryDocumentSnapshot.data(as: Wine.self)
            }
            winesSubject.send(wines)
          }
        
        return winesSubject
            .handleEvents(receiveCancel: { registration.remove() })
            .eraseToAnyPublisher()
    }
    
}
