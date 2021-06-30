//
//  AudioPlayerViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 30.06.21.
//

import UIKit
import YoutubePlayer_in_WKWebView

class AudioPlayerViewController: UIViewController {

    @IBOutlet weak var playerView: WKYTPlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateOfPublication: UILabel!
    
    var videoID: String!
    var songTitle: String!
    var publishedDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.videoID!)
        self.titleLabel.text = self.songTitle
        convertPublishedData()
        searchVideos()
        
        self.playerView.load(withVideoId: self.videoID)
        
        //request for views
        

    }
    
    func convertPublishedData() {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withFullDate
        let date = dateFormatter.date(from:self.publishedDate)!
        
        self.dateOfPublication.text = dateFormatter.string(from: date)
    }

    
    func searchVideos() {
        let urlString =
        "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=\(self.videoID!)=\(Constants.API_KEY)"
        
        guard let url = URL(string: urlString) else {return}

        let session = URLSession.init(configuration:.default)
        
        let dataTask = session.dataTask(with: url) {
            (data, response, error) in
            
            print("test")
            
            if error != nil {

                print(error!.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {

                print("client error")
                return
            }

            print(data!)
            do {
                let jsonData = try JSONDecoder().decode(VideoResourcesViews.self, from: data!)
                let views = jsonData.items[0].statistics.viewCount
                
                self.viewsLabel.text = "Views: " + views
                
            }
            catch {
                print(error.localizedDescription)
            }

        }

        dataTask.resume()
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
