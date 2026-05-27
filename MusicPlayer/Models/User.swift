//
//  User.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 21/05/26.
import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var email: String
    var username: String
    var password: String
    var joinDate: Date
    
    init(id: UUID = UUID(), email: String, username: String, password: String) {
        self.id = id
        self.email = email.lowercased()
        self.username = username
        self.password = password
        self.joinDate = Date()
    }
}

struct Session: Codable {
    let userId: UUID
    let username: String
    let email: String
    let loginDate: Date
    
    static func save(_ session: Session) {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "currentSession")
        }
    }
    
    static func load() -> Session? {
        guard let data = UserDefaults.standard.data(forKey: "currentSession"),
              let session = try? JSONDecoder().decode(Session.self, from: data) else {
            return nil
        }
        return session
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: "currentSession")
    }
}
