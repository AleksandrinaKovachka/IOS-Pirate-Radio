//
//  SongsViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class SongsViewController: UIViewController {

    var musicData: [String: String] = [:]

    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSearchSongs(_:)), name: .didSearchSongs, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidCancelSearchSongs(_:)), name: .didCancelSearchSongs, object: nil)
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
    
    // MARK: - Notification to hide or display play and shuffle buttons
    
    @objc func onDidSearchSongs(_ notification: Notification) {
        self.playButton.isHidden = true
        self.shuffleButton.isHidden = true
    }
    
    @objc func onDidCancelSearchSongs(_ notification: Notification) {
        self.playButton.isHidden = false
        self.shuffleButton.isHidden = false
    }

}
