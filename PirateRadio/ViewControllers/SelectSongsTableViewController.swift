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
    var playlistSongs: [String: String] = [:]
    
    var delegate: SongsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "wp"))
        
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
        for key in self.musicData.keys {
            if self.musicData[key] == songsTitle {
                self.delegate?.addSong(songKey: key, songTitle: songsTitle)
            }
        }
    }
    
    func deleteSong(songsTitle: String) {
        for key in self.musicData.keys {
            if self.musicData[key] == songsTitle {
                self.delegate?.deleteSong(songKey: key)
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
