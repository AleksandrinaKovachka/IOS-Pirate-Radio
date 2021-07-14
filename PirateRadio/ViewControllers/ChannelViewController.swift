//
//  ChannelViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 30.06.21.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var subscribersLabel: UILabel!
    
    var channelId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchChannelNameAndSubscribers()
    }
    
    func searchChannelNameAndSubscribers() {
        let urlString =
        "https://youtube.googleapis.com/youtube/v3/channels?part=snippet,contentDetails,statistics&id=\(self.channelId!)&key=\(Constants.API_KEY)"
        
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
                let jsonData = try JSONDecoder().decode(ChannelStruct.self, from: data!)
                let channelInfo = jsonData.items[0]
                
                DispatchQueue.main.async {
                    self.channelNameLabel.text = channelInfo.snippet.title
                    self.subscribersLabel.text = channelInfo.statistics.subscriberCount + " subscribers"
                    
                    let imageURL = channelInfo.snippet.thumbnails.high.url
                    
                    if let url = URL(string: imageURL) {
                        if let data = try? Data.init(contentsOf: url) {
                            if let image = UIImage.init(data: data) {
                                
                                self.channelImageView.image = image
                                self.channelImageView.layer.masksToBounds = false
                                self.channelImageView.layer.cornerRadius = self.channelImageView.frame.height / 2
                                self.channelImageView.clipsToBounds = true
                                
                            }
                        }
                    }
                    
                }
                
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
