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
    @IBOutlet weak var downloadProgressView: UIProgressView!
    
    weak var videoDataDelegate: VideoDataProtocol?
    
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
        
    }
    
    @IBAction func downloadOnAction(_ sender: Any) {
        //modified personalMusicData in PersonalMusicTableViewController
        //videoId and title
        videoDataDelegate?.addVideoIdAndTitle(videoId: self.videoId, title: self.title!)
        
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
        
        DispatchQueue.main.async {
            self.downloadProgressView.isHidden = false
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURLName = (documentDirectory.appendingPathComponent(self.videoId + ".mp3"))
        
        if FileManager.default.fileExists(atPath: videoURLName.path) {
            print("The file already exists")
            return
        }
        
//        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
//        let task = session.dataTask(with: url) {
//            (data, response, error) in
//
//            if error != nil {
//
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//
//                print("client error")
//                return
//            }
//
//            if let _ = try? data?.write(to: videoURLName) {
//                print("save video")
//            }
//        }
//        task.resume()
        
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())

        let downloadTask = session.downloadTask(with: url) {
            (data, response, error) in

            if let localUrl = data, error == nil {

                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: localUrl, to: videoURLName)
                } catch (let writeError) {
                    print("Error creating a file \(videoURLName) : \(writeError)")
                }

            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "not specified");
            }
        }

        downloadTask.resume()
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

extension VideoViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("download finished")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
        DispatchQueue.main.async {
            self.downloadProgressView.progress = progress
        }
        
            print(totalBytesWritten, totalBytesExpectedToWrite)
        //}
    }
}
