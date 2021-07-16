//
//  MusicTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import UIKit

class MusicTableViewController: UITableViewController {
    
    var searchController : UISearchController!
    var videoResources : [VideoStruct] = []
    var popularVideoResources : [VideoStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        //check for internet connection
//        if NetworkMonitor.shared.isConnected {
//            mostPopularSongs()
//        } else {
//            searchController.searchBar.isHidden = true
//        }
        
        //get most popular songs - display in first visit
        mostPopularSongs()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.videoResources.count == 0 {
            setDefaultMessage(message: "Loading...")
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        
        return self.videoResources.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicTableViewCell
        
        let title = self.videoResources[indexPath.row].snippet.title
        let imageURL = self.videoResources[indexPath.row].snippet.thumbnails.high.url
        
        if let url = URL(string: imageURL) {
            if let data = try? Data.init(contentsOf: url) {
                if let image = UIImage.init(data: data) {
                    cell.videoImageView.image = image
                }
            }
        }
        
        cell.titleLabel.text = title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let videoController = self.storyboard?.instantiateViewController(identifier: "VideoViewController") as? VideoViewController {
            
            videoController.videoId = self.videoResources[indexPath.row].id.videoId
            videoController.songTitle = self.videoResources[indexPath.row].snippet.title
            videoController.publishedDate = self.videoResources[indexPath.row].snippet.publishedAt
            videoController.channelId = self.videoResources[indexPath.row].snippet.channelId
            videoController.descriptionOfSong = self.videoResources[indexPath.row].snippet.description
            videoController.imageUrl = self.videoResources[indexPath.row].snippet.thumbnails.high.url
            
            self.navigationController?.pushViewController(videoController, animated: true)
        }

    }

    // MARK: - Search video functions

    func findVideos(searchText: String) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchText)&type=video&key=\(Constants.API_KEY)&maxResults=20"
        guard let url = URL(string: urlString) else {return}

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

            do {
                let jsonData = try JSONDecoder().decode(VideoResources.self, from: data!)
                self.videoResources = jsonData.items
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error.localizedDescription)
            }

        }

        dataTask.resume()
    }
    
    func mostPopularSongs() {
        
        //local code
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as! String
        
        let urlString =
        "https://youtube.googleapis.com/youtube/v3/videos?part=snippet,contentDetails,statistics&chart=mostPopular&maxResults=20&regionCode=\(countryCode)&key=\(Constants.API_KEY)"
        
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
                let jsonData = try JSONDecoder().decode(PopularVideoResources.self, from: data!)
                
                self.representMostPopular(popularVideoStruct: jsonData)
                self.videoResources = self.popularVideoResources
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            catch {
                print(error.localizedDescription)
            }

        }

        dataTask.resume()
    }
    
    func representMostPopular(popularVideoStruct: PopularVideoResources) {
        for videoData in popularVideoStruct.items {
            let data: VideoStruct! = VideoStruct(id: VideoIDStruct(videoId: videoData.id), snippet: videoData.snippet)

            self.popularVideoResources.append(data)
        }
    }
    
    func setDefaultMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
    }

}

extension MusicTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.split(separator: " ").joined(separator: "%20")
        findVideos(searchText: text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.videoResources = self.popularVideoResources
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
