//
//  FilterChip.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterChip(title: "Pop", isSelected: true, action: {})
}
