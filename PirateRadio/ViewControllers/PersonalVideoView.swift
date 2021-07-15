//
//  PersonalVideoView.swift
//  PirateRadio
//
//  Created by A-Team Intern on 8.07.21.
//

import SwiftUI
import AVKit

struct PersonalVideoView: View {

    @State var videoResources: [VideoDataStruct]
    
    @State var index: Int
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying: Bool = false
    @State var isFinished: Bool = false
    @State var time: CGFloat = 0
    @State var currentTime: String = "00:00"
    @State var totalTime: String = "00:00"
    @State var disabledForward: Bool = true
    @State var disabledBackward: Bool = true
    @State var del = AVDelegate()
    
    var body: some View {

        VStack {
            
            HStack {
                Spacer().frame(width: 300, height: 10, alignment: .topLeading)
                Button(action: self.deleteVideo, label: {
                    Text("Delete").font(.system(size: 20.0))
                })
            }
            
            HStack {
                Image(uiImage: (UIImage(named: videoResources[index].videoImagePath) ?? UIImage(named: "no_image"))!).resizable().frame(width: 300, height: 300, alignment: .topLeading).clipShape(Circle()).overlay(Circle().stroke(Color.white)).shadow(radius: 10)
            }
            
            VStack {
                Text(videoResources[index].videoTitle).font(.title)
                
                ZStack(alignment: .leading, content: {
                    Capsule().fill(Color.gray).frame(height: 8).padding(8)
                    
                    Capsule().fill(Color.blue).frame(width: self.time, height: 8).padding(8)
                })
            
                HStack {
                    Text(self.currentTime).offset(x: -110, y: 0)
                    Text(self.totalTime).offset(x: 110, y: 0)
                }
            }
            
            HStack(spacing: UIScreen.main.bounds.width / 3 - 50) {
                
                Button(action: self.backwardAudio, label: {
                    Image(systemName: "backward.fill").resizable().frame(width: 40, height: 40)
                }).disabled(self.disabledBackward)
                
                Button(action: self.playPauseVideo, label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable().frame(width: 60, height: 60)
                })
                
                Button(action: self.forwardAudio, label: {
                    Image(systemName: "forward.fill").resizable().frame(width: 40, height: 40).disabled(self.disabledForward)
                })
            }
        }.padding()
        .offset(x: 0, y: 0)
        .onAppear {
            
            initAudioPlayer()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                (_) in
                
                if self.audioPlayer.isPlaying {
                    let screenWidth = UIScreen.main.bounds.width - 20
                    let currTime = self.audioPlayer.currentTime / audioPlayer.duration
                    self.time = CGFloat(currTime) * screenWidth
                
                    let current = Double(self.audioPlayer.currentTime)
                    
                    self.currentTime = "\(Int(current/60)):\(Int(current.truncatingRemainder(dividingBy: 60)) <= 9 ? "0": "")\(Int(round(current.truncatingRemainder(dividingBy: 60))))"
                }
            }
            
            NotificationCenter.default.addObserver(forName: .didVideoFinished, object: nil, queue: .main) {
                (_) in
                self.forwardAudio()
            }
        }
    }
    
    func initAudioPlayer() {
        
        self.time = 0
        
        self.disabledBackward = self.isDisabledBackward()
        self.disabledForward = self.isDisabledForward()
        
        let url = URL(fileURLWithPath: self.videoResources[index].videoPath)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            print(error)
        }
        
        
        self.audioPlayer.delegate = self.del
        
        self.audioPlayer.prepareToPlay()
        
        let seconds = Double(self.audioPlayer.duration)
        self.totalTime = "\(Int(seconds/60)):\(Int(seconds.truncatingRemainder(dividingBy: 60)) <= 9 ? "0": "")\(Int(round(seconds.truncatingRemainder(dividingBy: 60))))"
        
        self.currentTime = "00:00"
        
        if isPlaying {
            self.audioPlayer.play()
        }
    }
    
    func playPauseVideo() {
        if self.audioPlayer.isPlaying {
            isPlaying = false
            audioPlayer.stop()
        } else {
            
            isPlaying = true
            audioPlayer.play()
        }
    }
    
    func deleteVideo() {
        
        let videoId = self.videoResources[self.index].videoId
        self.videoResources.remove(at: self.index)
        
        if self.videoResources.count == 0 {
            //back to table view

            NotificationCenter.default.post(name: .hasDeleteVideo, object: nil, userInfo: ["videoId": videoId])
            NotificationCenter.default.post(name: .hasDismissSwiftUI, object: nil, userInfo: nil)
//            self.videoResources.remove(at: self.index)
            return
        }
        
//        self.videoResources.remove(at: self.index)
        
        if self.index == self.videoResources.count {
            
            self.index -= 1
            
        }
        
        initAudioPlayer()
        
        //notification with videoId
        NotificationCenter.default.post(name: .hasDeleteVideo, object: nil, userInfo: ["videoId": videoId])
    }
    
    func backwardAudio() {
        
        self.index -= 1
        
        initAudioPlayer()
    }
    
    func forwardAudio() {
        
        self.index += 1
        
        initAudioPlayer()
    }
    
    func isDisabledBackward() -> Bool {
        if self.index == 0 {
            return true
        }
        
        return false
    }
    
    func isDisabledForward() -> Bool {
        if self.index == self.videoResources.count - 1 {
            return true
        }
        
        return false
    }
    
}

struct PersonalVideoView_Previews: PreviewProvider {
    static var previews: some View {
//        PersonalVideoView(videoData: VideoDataStruct(videoId: "id", videoTitle: "Title", videoImagePath: "no_image"))
        
        PersonalVideoView(videoResources: [VideoDataStruct(videoId: "id", videoTitle: "Title", videoImagePath: "no_image", videoPath: "file:///Users/a-teamintern/Library/Developer/CoreSimulator/Devices/7F9371B4-610A-443F-8338-93EC1FC01AA1/data/Containers/Data/Application/6E4FCC91-D34D-4327-B9F7-61547DB717B3/Documents/5kbAFlBuRDY.mp3")], index: 0)
    }
}

class AVDelegate : NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished")
        NotificationCenter.default.post(name: .didVideoFinished, object: nil, userInfo: nil)
    }
}
