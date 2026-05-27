//
//  PlayerView.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 20/05/26.
import SwiftUI

struct PlayerView: View {
    @ObservedObject var audioPlayerVM: AudioPlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 250, height: 250)
                
                Image(systemName: "music.note")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
            }
            .padding(.top, 50)
            
            VStack(spacing: 8) {
                Text(audioPlayerVM.currentSong?.title ?? "Sin canción")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(audioPlayerVM.currentSong?.artist ?? "Artista")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                Slider(value: Binding(
                    get: { audioPlayerVM.currentTime },
                    set: { audioPlayerVM.seek(to: $0) }
                ), in: 0...audioPlayerVM.currentDuration)
                .accentColor(.blue)
                
                HStack {
                    Text(formatTime(audioPlayerVM.currentTime))
                        .font(.caption)
                    Spacer()
                    Text(formatTime(audioPlayerVM.currentDuration))
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 40) {
                Button(action: { audioPlayerVM.previousTrack() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 30))
                }
                
                Button(action: { audioPlayerVM.togglePlayPause() }) {
                    Image(systemName: audioPlayerVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 70))
                }
                
                Button(action: { audioPlayerVM.nextTrack() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 30))
                }
            }
            .foregroundColor(.blue)
            
            HStack {
                Image(systemName: "speaker.fill")
                    .foregroundColor(.gray)
                Slider(value: $audioPlayerVM.volume, in: 0...1, onEditingChanged: { _ in
                    audioPlayerVM.setVolume(audioPlayerVM.volume)
                })
                .accentColor(.blue)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Reproduciendo")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if !audioPlayerVM.isPlaying {
                audioPlayerVM.pause()
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
