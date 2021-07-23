//
//  SelectSongsTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class SelectSongsTableViewController: UITableViewController {

    var isYoutubePlaylist: Bool = false
    
    var songsTitle: [String] = []
    var musicData: [String: String] = [:]
    var youTubeMusicData: [PlaylistVideosStruct] = []
    
    var delegate: SongsDelegate?
    
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.backgroundImage = UIImage(named: "wp")
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "wp"))
        
        initMusicData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsTitle.count
    }
    
    func initMusicData() {
        if self.isYoutubePlaylist == false {
            if let musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
                self.musicData = musicData
                self.songsTitle = Array(musicData.values)
                self.songsTitle.sort()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSongsCell", for: indexPath) as! SelectSongsTableViewCell
        
        cell.videoTitleLabel.text = self.songsTitle[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellTableView = tableView.cellForRow(at: indexPath) {
            if cellTableView.accessoryType == .checkmark {
                cellTableView.accessoryType = .none
                    
                deleteSong(songsTitle: self.songsTitle[indexPath.row])
                    
            } else {
                cellTableView.accessoryType = .checkmark

                addSong(songsTitle: self.songsTitle[indexPath.row])
            }
        }
    }
    
    
    
    func addSong(songsTitle: String) {
        if self.isYoutubePlaylist {
            for data in self.youTubeMusicData {
                if data.videoTitle == songsTitle {
                    self.delegate?.addYouTubeSong(data: data)
                }
            }
        } else {
            for key in self.musicData.keys {
                if self.musicData[key] == songsTitle {
                    self.delegate?.addSong(songKey: key, songTitle: songsTitle)
                }
            }
        }
    }
    
    func deleteSong(songsTitle: String) {
        if self.isYoutubePlaylist {
            self.delegate?.deleteYoutubeSong(songTitle: songsTitle)
        } else {
            for key in self.musicData.keys {
                if self.musicData[key] == songsTitle {
                    self.delegate?.deleteSong(songKey: key)
                }
            }
        }
    }
    
    // MARK: Search songs
    
    func findSongs(text: String) {
        
        if self.isYoutubePlaylist {
            print("search in youtube api")
            findVideosInYouTube(searchText: text)
        } else {
            var searchedSongs: [String] = []
            
            for title in self.songsTitle {
                if title.uppercased().contains(text.uppercased()) {
                    searchedSongs.append(title)
                }
            }
            
            self.songsTitle.removeAll()
            self.songsTitle.append(contentsOf: searchedSongs)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
    }
    
    func findVideosInYouTube(searchText: String) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchText)&type=video&key=\(Constants.API_KEY)&maxResults=20"
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
                let jsonData = try JSONDecoder().decode(VideoResources.self, from: data!)
                let videoResources: [VideoStruct] = jsonData.items
                
                self.songsTitle.removeAll()
                
                for data in videoResources {
                    self.youTubeMusicData.append(PlaylistVideosStruct(videoId: data.id.videoId, videoTitle: data.snippet.title, videoImage: data.snippet.thumbnails.high.url))
                    self.songsTitle.append(data.snippet.title)
                }
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectSongsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = searchBar.text!
        findSongs(text: text)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.songsTitle.removeAll()
        
        if self.isYoutubePlaylist == false {
            self.songsTitle.append(contentsOf: Array(self.musicData.values).sorted())
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
