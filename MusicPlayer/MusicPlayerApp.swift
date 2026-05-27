//  MusicPlayerApp.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 20/05/26.
import SwiftUI

@main
struct MusicPlayerApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                ContentView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

