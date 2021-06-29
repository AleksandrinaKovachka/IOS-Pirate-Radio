//
//  MusicTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import UIKit

class MusicTableViewController: UITableViewController {
    
    var searchController : UISearchController!
    var videoResourses : [VideoStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        //get most popular songs - display in first visit
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoResourses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicTableViewCell

        // load data from structure Video
        
        let title = self.videoResourses[indexPath.row].snippet.title
        let imageURL = self.videoResourses[indexPath.row].snippet.thumbnails.high.url
        
        if let url = URL(string: imageURL) {
            if let data = try? Data.init(contentsOf: url) {
                if let image = UIImage.init(data: data) {
                    cell.imageView?.image = image
                }
            }
        }
        
        cell.titleLabel.text = title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(VideoViewController(), animated: true, completion: nil)
    }


    func searchVideos(searchText: String) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchText)&type=video&key=\(Constants.API_KEY)"
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

            print(data!)
            do {
                let jsonData = try JSONDecoder().decode(VideoResources.self, from: data!)
                self.videoResourses = jsonData.items
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                for video in jsonData.items {
                    print(video.snippet.title)
                }
            }
            catch {
                print(error.localizedDescription)
            }

        }

        dataTask.resume()
    }
    
}

extension MusicTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchVideos(searchText: searchBar.text!)
    }
}
