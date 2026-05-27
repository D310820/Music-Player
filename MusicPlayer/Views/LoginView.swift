//
//  LoginView.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 21/05/26.
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var navigateToContent = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 70))
                        .foregroundColor(.blue)
                    
                    Text("MusicPlayer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Tu música, donde quieras")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                Button("Limpiar Datos Guardados") {
                    UserDefaults.standard.removeObject(forKey: "userSession")
                    UserDefaults.standard.removeObject(forKey: "savedSongs")
                    print("✅ Datos limpiados")
                }
                .font(.caption)
                .foregroundColor(.red)
                
                Spacer()
                
                VStack(spacing: 20) {
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
                            .textContentType(.password)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                if authViewModel.showError, let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    Task {
                        await authViewModel.login(email: email, password: password)
                    }
                }) {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Iniciar Sesión")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .padding(.horizontal)
                
                HStack {
                    Text("¿No tienes cuenta?")
                        .foregroundColor(.secondary)
                    Button(action: { showRegister = true }) {
                        Text("Regístrate")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(authViewModel)
            }
            .navigationBarHidden(true)
        }
    }
}
