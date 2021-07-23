//
//  PersonalYouTubePlaylistViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 23.07.21.
//

import UIKit
import YoutubePlayer_in_WKWebView

class PersonalYouTubePlaylistViewController: UIViewController {

    @IBOutlet weak var youTybePlayerView: WKYTPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var videoResources: [VideoDataStruct] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayVideo()
    }
    
    func displayVideo() {
        let playerVars: [AnyHashable: Any] = ["playsinline" : 1, "origin": "https://www.youtube.com"]
        self.youTybePlayerView.load(withVideoId: self.videoResources[index].videoId, playerVars: playerVars)

        self.videoTitleLabel.text = self.videoResources[index].videoTitle
        
        if self.index == 0 {
            self.backwardButton.isEnabled = false
        } else {
            self.backwardButton.isEnabled = true
        }
        
        if self.index == self.videoResources.count - 1 {
            self.forwardButton.isEnabled = false
        } else {
            self.forwardButton.isEnabled = true
        }
    }
    
    @IBAction func playPauseOnAction(_ sender: Any) {
        if self.playPauseButton.currentImage == UIImage(systemName: "play.circle.fill") {
            self.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            self.youTybePlayerView.playVideo()
        } else {
            self.playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            self.youTybePlayerView.stopVideo()
        }
    }
    
    
    @IBAction func backwardOnAction(_ sender: Any) {
        self.index -= 1
        displayVideo()
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        self.index += 1
        displayVideo()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
