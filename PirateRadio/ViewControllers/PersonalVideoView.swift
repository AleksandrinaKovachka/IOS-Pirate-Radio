//
//  PersonalVideoView.swift
//  PirateRadio
//
//  Created by A-Team Intern on 8.07.21.
//

import SwiftUI

struct PersonalVideoView: View {
    
    let videoData: VideoDataStruct
    
    @State var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer().frame(width: 300, height: 50, alignment: .topLeading)
                Button(action: self.deleteVideo, label: {
                    Text("Delete").font(.system(size: 20.0))
                })
            }
            
            HStack {
                Image(uiImage: UIImage(named: videoData.videoImagePath)!).resizable().frame(width: 300, height: 300, alignment: .topLeading).clipShape(Circle()).overlay(Circle().stroke(Color.white)).shadow(radius: 10)
            }
            
            VStack {
                Text(videoData.videoTitle).font(.title)
                Button(action: self.playPauseVideo, label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable().frame(width: 60, height: 60)
                })
            }
        }
    }
    
    func playPauseVideo() {
        
    }
    
    func deleteVideo() {
        
    }
}

struct PersonalVideoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalVideoView(videoData: VideoDataStruct(videoId: "id", videoTitle: "Title", videoImagePath: "no_image"))
    }
}
