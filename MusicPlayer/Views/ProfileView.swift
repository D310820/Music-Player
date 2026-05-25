////
//  ProfileView.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 20/05/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Información del usuario
            VStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                
                Text(authViewModel.currentSession?.username ?? "Usuario")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(authViewModel.currentSession?.email ?? "email@ejemplo.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 50)
            
            Spacer()
            
            // Botón Cerrar Sesión
            Button(action: {
                showingLogoutAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Cerrar Sesión")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(10)
            }
            .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    authViewModel.logout()
                    dismiss()
                }
            } message: {
                Text("¿Estás seguro de que quieres cerrar sesión?")
            }
            
            // Botón Borrar Cuenta
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Borrar Cuenta")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(10)
            }
            .alert("Borrar Cuenta", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Borrar", role: .destructive) {
                    authViewModel.deleteAccount()
                    dismiss()
                }
            } message: {
                Text("Esta acción no se puede deshacer. ¿Estás seguro de que quieres borrar tu cuenta permanentemente?")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
    }
}
