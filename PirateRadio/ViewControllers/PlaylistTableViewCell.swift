//
//  PlaylistTableViewCell.swift
//  PirateRadio
//
//  Created by A-Team Intern on 20.07.21.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playlistImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
