//
//  ItemModel.swift
//  CircleMenu
//
//  Created by Admin on 06/08/2024.
//

import SwiftUI

struct ItemModel: Identifiable, Hashable {
     
    var id: Int = 0
    var angle: Double = 0.0
    var icon: String  // nombre del icono
    var color: Color  // color de fondo
    var zIndex: Double = 1.0
    
}
