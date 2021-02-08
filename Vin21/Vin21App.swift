//
//  Vin21App.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import SwiftUI
import Firebase

@main
struct Vin21App: App {
    let model = Model()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: Model())
        }
    }
}
