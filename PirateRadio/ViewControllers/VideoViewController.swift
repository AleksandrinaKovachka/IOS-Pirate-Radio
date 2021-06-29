//
//  VideoViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 29.06.21.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var viewLabel: UILabel!
    
    @IBOutlet weak var dateOfPublicationLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    @IBOutlet weak var channelLabel: UILabel!
    
    @IBOutlet weak var subscribersLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "test"
    }
    

    @IBAction func backToMusicTableOnAction(_ sender: Any) {
    }
    
    @IBAction func downloadOnAction(_ sender: Any) {
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
