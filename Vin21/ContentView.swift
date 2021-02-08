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
        Text("Hello, world!")
            .padding()
            .onAppear {
                Auth.auth().signIn(withEmail: "etienne@vautherin.com", password: "Vin21-2021") { authResult, error in
                    if let error = error {
                        print("Authentification error: \(error.localizedDescription)")
                    } else {
                        print("No authentification error")
                    }
                  // ...
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: Model())
    }
}
