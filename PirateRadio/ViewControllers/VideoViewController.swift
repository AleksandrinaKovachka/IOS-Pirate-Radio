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
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var showDownloadMusicButton: UIButton!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    
    //TODO: template for optional property
    var videoId: String!
    var songTitle: String!
    var publishedDate: String!
    var channelId: String!
    var descriptionOfSong: String!
    var imageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionOfSongTextView.text = self.descriptionOfSong
        
        self.downloadProgressView.progress = 0
        self.downloadProgressView.isHidden = true
        
        //check if video is download
        didDownloadVideo()
        
    }
    
    @IBAction func downloadOnAction(_ sender: Any) {
        downloadImage()
        
        searchVideoURLForDownload()
    }
    
    @IBAction func showDownloadMusicOnAction(_ sender: Any) {
        //send notification with videoId - in personal music table view highlight cell
        
        if let personalController = self.storyboard?.instantiateViewController(identifier: "PersonalMusicTableView") as? PersonalMusicTableViewController {
            
            personalController.showDownloadVideo["videoId"] = self.videoId
            
            self.navigationController?.pushViewController(personalController, animated: true)
            
            //self.present(personalController, animated: true, completion: nil)
        }
    }
    
    
    func didDownloadVideo() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURLName = (documentDirectory.appendingPathComponent(self.videoId + ".mp3"))
        
        if FileManager.default.fileExists(atPath: videoURLName.path) {
            print("The file already exists")
            
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = false
            }
            
        }
    }
    
    func downloadImage() {
        
        guard let url = URL(string: self.imageUrl) else {
            print("wrong image url")
            return
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURLName = (documentDirectory.appendingPathComponent(self.videoId + ".jpg"))

        if FileManager.default.fileExists(atPath: imageURLName.path) {
            print("The file already exists")
            return
        }

        let session = URLSession(configuration: .default)

        let downloadTask = session.downloadTask(with: url) {
            (data, response, error) in

            if let localUrl = data, error == nil {

                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded image. Status code: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: localUrl, to: imageURLName)
                } catch (let writeError) {
                    print("Error creating a file \(imageURLName) : \(writeError)")
                }

            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "not specified");
            }
        }

        downloadTask.resume()
    }
    
    func searchVideoURLForDownload() {
        
        DispatchQueue.main.async {
            self.downloadButton.isHidden = true
            self.downloadLabel.isHidden = false
        }
        
        let urlString = "https://www.yt-download.org/api/button/mp3/\(self.videoId ?? "noVideo")"

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
            
            let contents = String(data: data!, encoding: .utf8)
            let types: NSTextCheckingResult.CheckingType = .link
            
            do {
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matches(in: contents!, options: .reportCompletion, range: NSMakeRange(0, contents!.count))
                    
                let urls = matches.compactMap({$0.url})
                
                for url in urls {
                    let stringURL = url.absoluteString
                    if stringURL.contains(self.videoId) {
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
        
        DispatchQueue.main.async {
            self.downloadProgressView.isHidden = false
        }
        
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURLName = (documentDirectory.appendingPathComponent(self.videoId + ".mp3"))

        if FileManager.default.fileExists(atPath: videoURLName.path) {
            print("The file already exists")
            return
        }

        let session = URLSession(configuration: .default)

        let downloadTask = session.downloadTask(with: url) {
            (data, response, error) in

            if let localUrl = data, error == nil {

                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded video. Status code: \(statusCode)")
                    
                    DispatchQueue.main.async {
                        self.downloadLabel.text = "Downloaded!"
                        self.showDownloadMusicButton.isHidden = false
                    }
                }

                do {
                    try FileManager.default.copyItem(at: localUrl, to: videoURLName)
                    self.saveDownloadVideoData()
                } catch (let writeError) {
                    print("Error creating a file \(videoURLName) : \(writeError)")
                }

            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "not specified");
            }
        }

        downloadTask.resume()
        
        DispatchQueue.main.async {
            self.downloadProgressView.observedProgress = downloadTask.progress
        }
    }
    
    func saveDownloadVideoData() {
        if var musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
            musicData[self.videoId] = self.songTitle
            UserDefaults.standard.set(musicData, forKey: "PersonalMusicData")
        } else {
            UserDefaults.standard.set([self.videoId: self.songTitle], forKey: "PersonalMusicData")
        }
        
        NotificationCenter.default.post(name: .hasDownloadVideo, object: nil, userInfo: [self.videoId: self.songTitle ?? "no title"])
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        
    }
    

}
