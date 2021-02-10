//
//  Wine.swift
//  Vin21
//
//  Created by Etienne Vautherin on 10/02/2021.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct Wine: Identifiable, Codable {
    @DocumentID var id: String?
    var title = "Test"
}
