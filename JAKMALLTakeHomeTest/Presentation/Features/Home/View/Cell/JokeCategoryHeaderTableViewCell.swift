//
//  JokeCategoryHeaderTableViewCell.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import UIKit

class JokeCategoryHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var topButton: UIButton!
    
    // MARK: - Variable -
    static let identifier = "JokeCategoryHeaderTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "JokeCategoryHeaderTableViewCell", bundle: nil)
    }
    
    var delegate: JokeTableViewDelegate?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topButton.addTarget(
            self, action: #selector(topButtonTapped(_:)), for: .touchUpInside
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(category: String, index: Int) {
        categoryTitle.text = category
        numberLabel.text = String(index + 1)
        if index == 0 {
            topButton.setTitle("Top", for: .normal)
            topButton.backgroundColor = .systemGreen
        }
        else {
            topButton.setTitle("Go Top", for: .normal)
            topButton.backgroundColor = .systemRed
        }
        self.index = index
    }
    
    @objc func topButtonTapped(_ sender: UIButton) {
        guard let index = index else { return }
        delegate?.goTopClicked(index: index)

    }
    
}
