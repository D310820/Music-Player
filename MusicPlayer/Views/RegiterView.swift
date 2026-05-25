//
//  RegisterView.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 25) {
            // Logo y título
            VStack(spacing: 15) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
                
                Text("Crear Cuenta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Regístrate para comenzar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Formulario de registro
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .frame(width: 30)
                    TextField("Nombre de usuario", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .frame(width: 30)
                    TextField("correo@ejemplo.com", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .frame(width: 30)
                    SecureField("Contraseña", text: $password)
                        .textContentType(.newPassword)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "lock.shield")
                        .foregroundColor(.gray)
                        .frame(width: 30)
                    SecureField("Confirmar Contraseña", text: $confirmPassword)
                        .textContentType(.newPassword)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Mensaje de error
            if authViewModel.showError, let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Botón de registro
            Button(action: {
                Task {
                    // Verificar que las contraseñas coincidan
                    if password != confirmPassword {
                        authViewModel.showError = true
                        authViewModel.errorMessage = "Las contraseñas no coinciden"
                        return
                    }
                    
                    let success = await authViewModel.register(
                        username: username,
                        email: email,
                        password: password
                    )
                    
                    if success {
                        // Regresar al login después de registrarse exitosamente
                        dismiss()
                    }
                }
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Registrarse")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || authViewModel.isLoading)
            .padding(.horizontal)
            
            // Botón para volver al login
            Button(action: {
                dismiss()
            }) {
                Text("¿Ya tienes cuenta? Inicia Sesión")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 40)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
