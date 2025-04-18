import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let url: URL
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false

    private var trackName: String { url.deletingPathExtension().lastPathComponent }
    
    var body: some View {
        VStack {
            Text(trackName)
                .font(.headline)
                .padding()
            
            HStack(spacing: 20) {
                AudioPlayerButton(systemName: "play.circle") {
                    if player == nil {
                        player = AVPlayer(url: url)
                    }
                    player?.play()
                    isPlaying = true
                }
                .disabled(isPlaying)
                
                AudioPlayerButton(systemName: "pause.circle") {
                    player?.pause()
                    isPlaying = false
                }
                .disabled(isPlaying == false)
                
                AudioPlayerButton(systemName: "stop.circle") {
                    player?.pause()
                    player?.seek(to: .zero)
                    isPlaying = false
                }
            }
            .padding()
        }
        .onDisappear {
            player?.pause()
            isPlaying = false
        }
    }
}


private struct AudioPlayerButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}
