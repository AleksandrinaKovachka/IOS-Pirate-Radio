//
//  VideoViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 29.06.21.
//

import UIKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var descriptionOfSongTextView: UITextView!
    
    var videoId: String!
    var songTitle: String!
    var publishedDate: String!
    var channelId: String!
    var descriptionOfSong: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionOfSongTextView.text = self.descriptionOfSong
    }
    
    @IBAction func downloadOnAction(_ sender: Any) {
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let audioController = self.storyboard?.instantiateViewController(identifier: "AudioViewController") as? AudioPlayerViewController {
//
//            audioController.videoID = self.videoID
//        }
        
        if segue.destination is AudioPlayerViewController {
            let audioViewController = segue.destination as! AudioPlayerViewController
            audioViewController.videoID = self.videoId
            audioViewController.songTitle = self.songTitle
            audioViewController.publishedDate = self.publishedDate
        }
        
        if segue.destination is ChannelViewController {
            let channelViewController = segue.destination as! ChannelViewController
            channelViewController.videoID = self.videoId
            channelViewController.channelId = self.channelId
        }
        
//        if segue.destination is DescriptionViewController {
//            let descriptionViewController = segue.destination as! DescriptionViewController
//            descriptionViewController.videoID = self.videoID
//        }
    }
    

}
