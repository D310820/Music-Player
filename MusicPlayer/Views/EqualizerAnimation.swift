//
//  EqualizerAnimation.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 21/05/26.
import SwiftUI
struct EqualizerAnimation: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: 4, height: animate ? 20 + CGFloat(i * 5) : 10)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(i) * 0.1),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}
