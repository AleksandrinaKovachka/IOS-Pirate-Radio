//
//  SongsViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class SongsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Play music buttons
    @IBAction func playMusicOnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didPlayMusic, object: nil)
    }
    
    @IBAction func shuffleMusicOnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didShuffleMusic, object: nil)
    }

}
