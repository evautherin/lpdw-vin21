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
    @EnvironmentObject var model: Model
    
    // Ces 2 états sont en quelque sorte le ViewModel de LoginView
    @State var email = "etienne@vautherin.com"
    @State var password = "Vin21-2021"

    var body: some View {
        VStack {
            GroupBox {
                TextField("Email", text: $email) .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)          .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Le bouton Login essaie de se connecter à Firebase avec le contenu des variables email et password lorsqu'il est pressé
            Button("Login") {
                // Authentification avec Future
                model.signIn(withEmail: email, password: password)
                
                // Authentification sans utiliser un Future
                
//                Auth.auth().signIn(
//                    withEmail: email,
//                    password: password
//                ) { (authResult, error) in
//                    // La fonction signIn appelle ce bloc d'instruction avec le résulat de l'authentification
//                    // error et authResut sont des optionnels
//
//                    // Si error est défini, probème d'authentification
//                    // Sinon authentification OK
//                    if let error = error {
//                        print("Authentification error: \(error.localizedDescription)")
//                    } else {
//                        print("No authentification error")
//                    }
//
//                    // Si authResult est défini, sa propriété user est recopiée dans model
//                    model.user = authResult?.user
//
//                    // Autre manière d'écrire l'instruction précédente
//                    // Plus générale mais plus "lourde"
//    //                    if let authResult = authResult {
//    //                        model.user = authResult.user
//    //                    }
//                }
            }
        }
    }
}

