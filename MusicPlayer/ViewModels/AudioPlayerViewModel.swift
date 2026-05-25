//
//  AudioPlayerViewModel.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 20/05/26.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import Combine

class AudioPlayerViewModel: NSObject, ObservableObject {
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var currentDuration: TimeInterval = 0
    @Published var volume: Float = 0.5
    @Published var playlist: [Song] = []
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupAudioSession()
        setupRemoteCommandCenter()
        playlist = Song.sampleSongs
    }
    
    // MARK: - Configuration
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error configurando audio: \(error)")
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextTrack()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousTrack()
            return .success
        }
    }
    
    // MARK: - Control de Reproducción
    func play(song: Song? = nil) {
        if let newSong = song {
            currentSong = newSong
            loadSong(song: newSong)
        }
        
        audioPlayer?.play()
        isPlaying = true
        startTimer()
        updateNowPlayingInfo()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
        updateNowPlayingInfo()
    }
    
    func togglePlayPause() {
        isPlaying ? pause() : play()
    }
    
    func nextTrack() {
        guard let currentSong = currentSong,
              let currentIndex = playlist.firstIndex(of: currentSong) else { return }
        
        let nextIndex = (currentIndex + 1) % playlist.count
        play(song: playlist[nextIndex])
    }
    
    func previousTrack() {
        guard let currentSong = currentSong,
              let currentIndex = playlist.firstIndex(of: currentSong) else { return }
        
        let previousIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : playlist.count - 1
        play(song: playlist[previousIndex])
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
        updateNowPlayingInfo()
    }
    
    func setVolume(_ value: Float) {
        volume = value
        audioPlayer?.volume = volume
    }
    
    // MARK: - Private Methods
    private func loadSong(song: Song) {
        guard let url = song.fileURL else {
            print("No se encontró el archivo: \(song.fileName).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            currentDuration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            print("Error cargando canción: \(error)")
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self,
                  let player = self.audioPlayer,
                  player.isPlaying else { return }
            
            DispatchQueue.main.async {
                self.currentTime = player.currentTime
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateNowPlayingInfo() {
        guard let song = currentSong else { return }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = song.artist
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentDuration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        if let artworkData = song.artworkData,
           let image = UIImage(data: artworkData) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextTrack()
        }
    }
}
