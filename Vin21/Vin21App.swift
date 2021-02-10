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
    
    func testException() {
        let fm = FileManager.default
        do {
            try fm.createDirectory(atPath: "", withIntermediateDirectories: true, attributes: .none)
            try fm.removeItem(atPath: "")
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func test2Exception() throws {
        let fm = FileManager.default
        try fm.createDirectory(atPath: "", withIntermediateDirectories: true, attributes: .none)
        try fm.removeItem(atPath: "")
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model, isShowingLogin: model.noSignedUser)
        }
    }
}
