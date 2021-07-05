//
//  VideoViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 29.06.21.
//

import UIKit
import HTMLKit
import WebKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var descriptionOfSongTextView: UITextView!
    
    //TODO: template for optional property
    var videoId: String = "ii6mAgRxCeg"
    var songTitle: String!
    var publishedDate: String!
    var channelId: String!
    var descriptionOfSong: String!
    var imageUrl: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionOfSongTextView.text = self.descriptionOfSong
    }
    
    @IBAction func downloadOnAction(_ sender: Any) {
        //modified personalMusicData in PersonalMusicTableViewController
        
        print("Test download")
        
        let urlString = "https://www.yt-download.org/api/button/mp3/\(self.videoId)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Wrong URL")
            return
            
        }

        let session = URLSession.init(configuration:.default)
        
        //error states
        
        let dataTask = session.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {

                print(error!.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {

                print("client error")
                return
            }

            print(data!)
            
            let contents = String(data: data!, encoding: .utf8)
            let types: NSTextCheckingResult.CheckingType = .link
            
            do {
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matches(in: contents!, options: .reportCompletion, range: NSMakeRange(0, contents!.count))
                    
                let urls = matches.compactMap({$0.url})
                
                for url in urls {
                    let stringURL = url.absoluteString
                    if stringURL.contains(self.videoId) {
                        print(url)
                        //download with url
                        self.downloadVideo(url: url)
                        break
                    }
                }
                
            } catch let error {
                debugPrint(error.localizedDescription)
            }

        }

        dataTask.resume()
        
        
    }
    
    func downloadVideo(url: URL) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let videoName = (documentDirectory?.appendingPathComponent(self.songTitle + ".mp3"))!
        URLSession.shared.downloadTask(with: url) {
            (data, response, error) in
            
            if let videoUrl = data {
                do {
                    let videoData = try Data(contentsOf: videoUrl)
                    try videoData.write(to: videoName)
                } catch {
                    print("error")
                }
            }
        }
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
            channelViewController.channelId = self.channelId
        }
        
//        if segue.destination is DescriptionViewController {
//            let descriptionViewController = segue.destination as! DescriptionViewController
//            descriptionViewController.videoID = self.videoID
//        }
    }
    

}
