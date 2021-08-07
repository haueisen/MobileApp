//
//  LocationCell.swift
//  Mobile App
//
//  Created by flavio on 04/08/21.
//

import Foundation
import UIKit

class LocationCell: UICollectionViewCell {

    static let reuseId = "locationcell"

    var locationId: Int?
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var starScore: StarScoreView!
    @IBOutlet weak var score: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.contentView.layer.cornerRadius = 16

        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(UIColor(named: "black10")!.cgColor.alpha)
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
}
