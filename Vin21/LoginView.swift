//
//  LoginView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 08/02/2021.
//

import Foundation
import SwiftUI
import Firebase


struct LoginView: View {
    @ObservedObject var model: Model
    
    @State var email = "etienne@vautherin.com"
    @State var password = "Vin21-2021"

    var body: some View {
        VStack {
            GroupBox {
                TextField("Email", text: $email) .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)          .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button("Login") {
                Auth.auth().signIn(
                    withEmail: email,
                    password: password
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

