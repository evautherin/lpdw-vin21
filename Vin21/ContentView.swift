//
//  ContentView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var model: Model
    
    // Etat définissant l'affichage de la vue de login
    @State var isShowingLogin: Bool
    
    var body: some View {
        VStack {
            
            if (model.user?.email == .none) {
                Text("Hello, world!")
                    .padding()
            } else {
                Text("Hello, \(model.user!.email!)")
                    .padding()
            }
            
            Button("Add Wine") {
                model.add(wine: Wine.test())
            }.padding()
            
            List(model.wines) { wine in
                WineView(wine: wine)
            }

            Button("Sign Out") {
                model.signOut()
                
                // Sign Out sans Future
//                do {
//                    try Auth.auth().signOut()
//                    model.user = .none
//                } catch {
//                    print("Sign Out Error: \(error.localizedDescription)")
//                }
            }.padding()
            
        }
        
        // Observation de la valeur de model.user
        // Si user est défini, isShowingLogin prend la valeur false
        // Si user n'est pas défini, isShowingLogin prend la valeur true
        .onChange(of: model.user) { (user) in
            isShowingLogin = model.noSignedUser
        }
        
        // La vue LoginView est affichée par dessus VStack lorsque isShowingLogin est vrai
        .sheet(isPresented: $isShowingLogin) {
            LoginView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Model()
        return ContentView(isShowingLogin: model.noSignedUser)
    }
}
