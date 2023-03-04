//
//  AddJokeTableViewCell.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 04/03/23.
//

import UIKit

class AddJokeTableViewCell: UITableViewCell {
    
    // MARK: - Variable -
    static let identifier = "AddJokeTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "AddJokeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
