//
//  WineView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 10/02/2021.
//

import Foundation
import SwiftUI


struct WineView: View {
    let model: Model
    let wine: Wine
    
    var body: some View {
        HStack {
            Text(wine.title)
            Spacer()
//            Button("Delete") {
//                guard let wineId = wine.id else { return }
//                model.deleteWine(id: wineId)
//            }
        }
    }
}
