//
//  ContentView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            
            if (model.user?.email == .none) {
                Text("Hello, world!")
                    .padding()
            } else {
                Text("Hello, \(model.user!.email!)")
                    .padding()
            }
            
            
            Button("Authentification") {
                Auth.auth().signIn(
                    withEmail: "etienne@vautherin.com",
                    password: "Vin21-2021"
                ) { (authResult, error) in
                    if let error = error {
                        print("Authentification error: \(error.localizedDescription)")
                    } else {
                        print("No authentification error")
                    }
                    
                    model.user = authResult?.user
                    
//                    if let authResult = authResult {
//                        model.user = authResult.user
//                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: Model())
    }
}
