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
    var videoViews: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = self.songTitle
        convertPublishedData()
        searchVideos()
        
        let playerVars: [AnyHashable: Any] = ["playsinline" : 1, "origin": "https://www.youtube.com"]
        self.playerView.load(withVideoId: self.videoID, playerVars: playerVars)
        

    }
    
    func convertPublishedData() {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withFullDate
        let date = dateFormatter.date(from:self.publishedDate)!
        
        self.dateOfPublication.text = dateFormatter.string(from: date)
    }

    
    func searchVideos() {
        let urlString =
        "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(self.videoID!)&key=\(Constants.API_KEY)"
        
        guard let url = URL(string: urlString) else {return}

        let session = URLSession.init(configuration:.default)
        
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

            do {
                let jsonData = try JSONDecoder().decode(VideoResourcesViews.self, from: data!)
                self.videoViews = jsonData.items[0].statistics.viewCount
                
                DispatchQueue.main.async {
                    self.viewsLabel.text = "Views: " + self.formatViews()
                }
                
            }
            catch {
                print(error.localizedDescription)
            }

        }

        dataTask.resume()
    }
    
    func formatViews() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = " "
        
        return numberFormatter.string(from: NSNumber(value: Int(self.videoViews)!))!
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
