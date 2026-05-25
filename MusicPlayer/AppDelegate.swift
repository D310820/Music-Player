//
//  AppDelegate.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
//

// AppDelegate.swift
import UIKit
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configurando audio session: \(error)")
        }
        
        return true
    }
}
