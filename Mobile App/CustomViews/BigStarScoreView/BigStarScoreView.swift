//
//  BigStarScoreView.swift
//  Mobile App
//
//  Created by flavio on 08/08/21.
//

import Foundation
import UIKit

class BigStarScoreView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    let minimumStars = 0
    let maximumStars = 5

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    func loadViewFromNib() {
        Bundle.main.loadNibNamed("BigStarScoreView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setStarScore(_ score: Float) {
        let stars = [star1, star2, star3, star4, star5]

        let roundedScore = min(maximumStars, max(minimumStars, Int(round(score))))

        for star in 1...stars.count {
            if star <= roundedScore {
                stars[star-1]?.image = UIImage(named: "on")
            } else {
                stars[star-1]?.image = UIImage(named: "off")
            }
        }
    }

    func clearScore() {
        let stars = [star1, star2, star3, star4, star5]
        for star in 1...stars.count {
            stars[star-1]?.image = nil
        }
    }
}
