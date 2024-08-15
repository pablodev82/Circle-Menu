//
//  ContentView.swift
//  CircleMenu
//
//  Created by Admin on 05/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: propiedades
    @State private var items:  [ItemModel] = {
        return [
            ItemModel(icon: "heart.fill", color: .yellow),
            ItemModel(icon: "cloud.fill", color: .red),
            ItemModel(icon: "folder.fill", color: .blue),
            
            ItemModel(icon: "paperplane.fill", color: .green),
            ItemModel(icon: "square.and.arrow.up.fill", color: .orange),
            
            ItemModel(icon: "folder.fill", color: .blue),
            ItemModel(icon: "trash.fill", color: .purple),
            ItemModel(icon: "folder.fill", color: .pink)
            
            
        ]
    }()
    
    var body: some View {
        CircleView(items: $items) { item in
            print("Complete", item.id)
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
