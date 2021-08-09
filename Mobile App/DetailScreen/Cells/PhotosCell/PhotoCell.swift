//
//  PhotoCell.swift
//  Mobile App
//
//  Created by flavio on 08/08/21.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        self.layer.cornerRadius = 8
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
}
