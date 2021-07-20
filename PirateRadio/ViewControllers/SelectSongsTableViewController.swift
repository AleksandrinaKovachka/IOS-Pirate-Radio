//
//  SelectSongsTableViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class SelectSongsTableViewController: UITableViewController {
    
    var songsTitle: [String] = []
    var musicData: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMusicData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.songsTitle.count
    }
    
    func initMusicData() {
        if let musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
            self.musicData = musicData
            self.songsTitle = Array(musicData.values)
            self.songsTitle.sort()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSongsCell", for: indexPath) as! SelectSongsTableViewCell
        
        cell.videoTitleLabel.text = self.songsTitle[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
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
