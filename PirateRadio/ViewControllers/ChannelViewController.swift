//
//  ChannelViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 30.06.21.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var subscribersLabel: UILabel!
    
    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.videoID!)
        self.channelNameLabel.text = self.videoID

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
