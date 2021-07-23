//
//  MusicCollectionTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class MusicCollectionTableViewController: UITableViewController {
    
    let sections: [String: String] = ["Playlist": "music.note.list", "Songs": "music.note"]
    let sectionNames: [String] = ["Playlist", "Songs"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "wp"))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCollectionCell", for: indexPath) as! MusicCollectionTableViewCell
        
        cell.sectionTypeLabel.text = self.sectionNames[indexPath.row]
        cell.sectionImageView.image = UIImage(systemName: self.sections[self.sectionNames[indexPath.row]]!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.sectionNames[indexPath.row] == "Songs" {
            if let songsController = self.storyboard?.instantiateViewController(identifier: "SongsViewController") as? SongsViewController {
                
                self.navigationController?.pushViewController(songsController, animated: true)
            }
        } else if self.sectionNames[indexPath.row] == "Playlist" {
            if let playlistController = self.storyboard?.instantiateViewController(identifier: "PlaylistTableViewController") as? PlaylistTableViewController {
                
                playlistController.isYoutubePlaylist = false
                
                self.navigationController?.pushViewController(playlistController, animated: true)
            }
        }
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
