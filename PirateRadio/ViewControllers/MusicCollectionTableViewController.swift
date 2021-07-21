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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
                
                self.navigationController?.pushViewController(playlistController, animated: true)
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
