//
//  CircleView.swift
//  CircleMenu
//
//  Created by Admin on 05/08/2024.
//

import SwiftUI

struct CircleView: View {
    
    

    // MARK: Propiedades
    var buttonHeight: CGFloat = 55.0   // Define la altura del botón
    var distance: CGFloat = 80.0  // Define la distancia para los elementos

    var starAngle: Double = 0.0
    var endAngle: Double = 360.0  // aca se le da el angulo 360 y los icons ocupen todo el cirulo
    var duration: Double = 0.33


    @Binding var items: [ItemModel]
    
    var completion: (ItemModel) -> ()  // Captura el evento después de que finalice la animación.

    // plus button
    @State private var plusDegrees: Double = 0.0    // creación de efecto de rotación para botón
    @State private var plusOpacity: Double = 1.0   // crea el efecto de opacidad del boton despues de la rotacion
    @State private var plusScale: Bool = false
    @State private var isBounceAnimation: Bool = false

    @State private var setDistance: Double = 0.0   // crea la animacion que se muestra en el boton

    // Stroke
    @State private var cirStrokeTo: Double = 0.0
    // Circle
    @State private var cirAngle: Double = 0.0

    @State private var cirStrokeScale: Double = 1.0

    @State private var cirStrokeOpacity: Double = 0.0

    @State private var cirStrokeColor: Color = .clear

    @State private var cirStrokeColorOpacity: Double = 0.0
    
    



    // MARK: Contenido
    var body: some View {
        Rectangle()  // Rectangle(): Dibuja un rectángulo púrpura.
            .fill(Color.clear)
            .frame(width: distance * 2 + buttonHeight,
                   height: distance * 2 + buttonHeight)
            .overlay(    // .overlay: Añade una capa superior que contiene una vista ZStack.
                ZStack {
                    plusView()
                    ForEach(items) { item in
                        itemView(item)
                    }
                    strokeView()
                }
            )
            .onAppear {
                updateItems()
            }
    }

    fileprivate func updateItems() {
        let step = getStep()

        for i in 0..<items.count {
            let angle: Double = starAngle + Double(i) * step

            items[i].id = i
            items[i].angle = angle
        }
    }

    fileprivate func getStep() -> Double {
        var length = endAngle - starAngle
        var count = items.count

        if length < endAngle {
            count -= 1

        } else if length > endAngle {
            length = endAngle
        }
        return length / Double(count)
    }
}

// MARK: plusView(): Añade el botón "plus".
extension CircleView {

    @ViewBuilder
    private func plusView() -> some View {
        Button {
            guard !isBounceAnimation else {
                return
            }
            isBounceAnimation = true

            print("plus did tap")
            plusDidTap()
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: buttonHeight, height: buttonHeight)
                .clipShape(RoundedRectangle(cornerRadius: buttonHeight / 2))
                .foregroundColor(.black)
        }
        
        
        .zIndex(5)
        .rotationEffect(.degrees(plusDegrees))
        .scaleEffect(plusScale ? 0.9 : 1.0)
        .opacity(plusOpacity)
    }

    fileprivate func plusDidTap() {
        plusScale.toggle()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            plusDegrees = plusDegrees == 45 ? 0 : 45   // esto le da rotacion a simbolo +
            plusOpacity = plusDegrees == 45 ? 0.4 : 1.0

            plusScale.toggle()   // crea la animacion de rebote

            setDistance = plusDegrees == 45 ? Double(distance <= 80 ? 80 : distance) : 0.0  // hace que los icon se centren y queden detras del plus
        }
            isBounceAnimation = false
    }
}

// MARK: Item View
extension CircleView {

    @ViewBuilder
    private func itemView(_ item: ItemModel) -> some View {
        RoundedRectangle(cornerRadius: buttonHeight / 2)
            .fill(Color.red)
            .frame(width: buttonHeight, height: buttonHeight)
            .overlay(
                Button {
                    guard let index = items.firstIndex(where: {
                        $0.id == item.id
                    }) else {
                        return
                    }

                    cirAngle = item.angle
                    cirStrokeColor = item.color

                    withAnimation(.easeInOut(duration: duration)) {
                        items[index].angle = cirAngle + 360
                        cirStrokeTo = 1.0
                    }
                    items[index].angle = cirAngle + 360
                    withAnimation(.easeOut) {
                        completion(item)
                        
                        cirStrokeScale = 1.2
                        cirStrokeTo = 0.0
                        cirStrokeOpacity = 0.0
                        cirStrokeColor = .clear
                        cirStrokeColorOpacity = 0.0
                        
                        cirAngle = 0.0
                        
                        
                    }



                } label: {
                    Image(systemName: item.icon)
                        .frame(width: buttonHeight, height: buttonHeight)
                        .accentColor(.white)
                        .background(item.color)
                        .clipShape(RoundedRectangle(cornerRadius: buttonHeight))
                }
                .rotationEffect(.degrees(Double(-item.angle)))
            )
            .zIndex(2.0)
            .offset(x: CGFloat(-setDistance))
            .rotationEffect(.degrees(Double(item.angle)))
            .scaleEffect(setDistance == 0 ? 0.0 : 1.0)
            .opacity(setDistance == 0 ? 0.0 : 1.0)
     
//   Crea un círculo de marcador de posición después de que se mueva el botón
        if cirStrokeColor != .clear {
            RoundedRectangle(cornerRadius: buttonHeight / 2)
                .fill(cirStrokeColor)
                .frame(width: buttonHeight, height: buttonHeight)
                .offset(x: CGFloat(-setDistance))
                .rotationEffect(.degrees(cirAngle))
                
        }
    }
}

// MARK: Stroke View

extension CircleView {
    @ViewBuilder
    private func strokeView() -> some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(
                Circle()
                    .trim(from: 0.0, to: CGFloat(cirStrokeTo))
                    .stroke(
                            cirStrokeColor
                                .opacity(cirStrokeColorOpacity),
                            style: StrokeStyle(
                                lineWidth: buttonHeight,
                                lineCap: .round,
                                lineJoin: .round
                                )
                    )
                    .scaleEffect(x: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, anchor: .center)
                    .opacity(cirStrokeOpacity)
                    .frame(width: CGFloat(setDistance) * 2, height: CGFloat(setDistance) * 2)  // en esta linea se le da el efecto de expansion al circulo
            )
            .zIndex(1.0)
            .rotationEffect(.degrees(-180 + cirAngle))
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







