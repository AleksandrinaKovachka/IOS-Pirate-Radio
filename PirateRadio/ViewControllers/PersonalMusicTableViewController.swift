//
//  PersonalMusicTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 1.07.21.
//

import UIKit

class PersonalMusicTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchController : UISearchController!
    
    var personalMusicData: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController = UISearchController.init(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        //get music data from user default
        if let musicData = UserDefaults.standard.object(forKey: "personalMusicData") as? [String: String] {
            self.personalMusicData = musicData
        }
        
        //observ self when video is download
        NotificationCenter.default.addObserver(self, selector: #selector(onHasDownloadVideo(_:)), name: .hasDownloadVideo, object: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalMusicData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMusicCell", for: indexPath) as! PersonalMusicTableViewCell

        let videosId = [String] (self.personalMusicData.keys)
        
        let title = self.personalMusicData[videosId[indexPath.row]]
        //let imageData = self.personalMusicData[title]!
        
        cell.titleLabel.text = title
        
//        if let image = UIImage.init(data: imageData) {
//            cell.videoImage.image = image
//        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */
    
    //MARK: - Notification
    
    @objc func onHasDownloadVideo(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            for (videoId, title) in data {
                print(videoId, title)
                personalMusicData[videoId] = title
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}
