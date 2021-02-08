//
//  ContentView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                Auth.auth().signIn(withEmail: "email", password: "password") { authResult, error in
                  // ...
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
