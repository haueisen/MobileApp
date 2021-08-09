//
//  TitleCell.swift
//  Mobile App
//
//  Created by flavio on 04/08/21.
//

import Foundation
import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starScore: BigStarScoreView!
    @IBOutlet weak var score: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        name.text = nil
        starScore.clearScore()
        score.text = nil
    }
}
