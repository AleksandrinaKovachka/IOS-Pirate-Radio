//
//  SongsViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class SongsViewController: UIViewController {

    var musicData: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PersonalMusicTableViewController {
            let personalMusicController = segue.destination as! PersonalMusicTableViewController
            personalMusicController.musicData = self.musicData
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
