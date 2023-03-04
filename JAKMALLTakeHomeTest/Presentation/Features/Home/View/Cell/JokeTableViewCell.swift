//
//  JokeTableViewCell.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var jokeLabel: UILabel!
    
    // MARK: - Variable -
    static let identifier = "JokeTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "JokeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(joke: Joke?) {
        guard let joke = joke else { return }
        jokeLabel.text = joke.joke ?? ""
    }
    
}
