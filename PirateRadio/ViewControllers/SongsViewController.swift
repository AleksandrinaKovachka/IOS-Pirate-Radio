//
//  SongsViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class SongsViewController: UIViewController {
    
    var personalMusicViewController: PersonalMusicTableViewController!
//    var musicData: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.personalMusicViewController.musicData = musicData
        
//        if let musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
//            self.personalMusicViewController.musicData = musicData
//        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonalMusicTableView" {
            let vc = segue.destination as! PersonalMusicTableViewController
            self.personalMusicViewController = vc
//            if let musicData = UserDefaults.standard.object(forKey: "PersonalMusicData") as? [String: String] {
//                vc.musicData = musicData
//            }
        }
    }
    
    // MARK: - Play music buttons
    @IBAction func playMusicOnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didPlayMusic, object: nil)
    }
    
    @IBAction func shuffleMusicOnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didShuffleMusic, object: nil)
    }

}
