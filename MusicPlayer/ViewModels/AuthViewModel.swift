//
//  AuthViewModel.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 20/05/26.
//

import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var currentSession: UserSession?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        if let savedUser = UserDefaults.standard.data(forKey: "userSession") {
            if let user = try? JSONDecoder().decode(UserSession.self, from: savedUser) {
                currentSession = user
                isLoggedIn = true
                print("✅ Usuario logueado: \(user.username)")
                return
            }
        }
        // Si no hay sesión guardada, asegurar que isLoggedIn es false
        currentSession = nil
        isLoggedIn = false
        print("❌ No hay sesión activa")
    }
    
    @MainActor
    func login(email: String, password: String) async {
        isLoading = true
        showError = false
        errorMessage = nil
        
        // Simular delay de red
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Validación simple
        if email.contains("@") && password.count >= 4 {
            let user = UserSession(
                id: UUID().uuidString,
                username: email.components(separatedBy: "@").first ?? email,
                email: email
            )
            currentSession = user
            isLoggedIn = true
            
            // Guardar sesión
            if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: "userSession")
            }
            print("✅ Login exitoso para: \(user.username)")
        } else {
            showError = true
            errorMessage = "Email o contraseña incorrectos"
            print("❌ Login fallido")
        }
        
        isLoading = false
    }
    
    @MainActor
    func register(username: String, email: String, password: String) async -> Bool {
        isLoading = true
        showError = false
        errorMessage = nil
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if username.isEmpty {
            errorMessage = "El nombre de usuario no puede estar vacío"
            showError = true
            isLoading = false
            return false
        }
        
        if !email.contains("@") {
            errorMessage = "Email inválido"
            showError = true
            isLoading = false
            return false
        }
        
        if password.count < 4 {
            errorMessage = "La contraseña debe tener al menos 4 caracteres"
            showError = true
            isLoading = false
            return false
        }
        
        let user = UserSession(
            id: UUID().uuidString,
            username: username,
            email: email
        )
        
        currentSession = user
        isLoggedIn = true
        
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userSession")
        }
        
        print("✅ Registro exitoso para: \(username)")
        isLoading = false
        return true
    }
    
    func logout() {
        DispatchQueue.main.async {
            self.currentSession = nil
            self.isLoggedIn = false
            UserDefaults.standard.removeObject(forKey: "userSession")
            print("✅ Sesión cerrada - isLoggedIn: \(self.isLoggedIn)")
        }
    }
    
    func deleteAccount() {
        DispatchQueue.main.async {
            self.currentSession = nil
            self.isLoggedIn = false
            UserDefaults.standard.removeObject(forKey: "userSession")
            print("✅ Cuenta borrada - isLoggedIn: \(self.isLoggedIn)")
        }
    }
}

struct UserSession: Codable {
    let id: String
    let username: String
    let email: String
}
