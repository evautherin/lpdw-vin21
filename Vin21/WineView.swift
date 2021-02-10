//
//  WineView.swift
//  Vin21
//
//  Created by Etienne Vautherin on 10/02/2021.
//

import Foundation
import SwiftUI


struct WineView: View {
    let wine: Wine
    
    var body: some View {
        Text(wine.title)
    }
}
