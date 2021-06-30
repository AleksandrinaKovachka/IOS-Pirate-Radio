//
//  DescriptionViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 30.06.21.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var videoID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.videoID!)
        self.descriptionTextView.text = self.videoID
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
