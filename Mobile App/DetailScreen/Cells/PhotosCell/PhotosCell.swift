//
//  PhotosCell.swift
//  Mobile App
//
//  Created by flavio on 08/08/21.
//

import Foundation
import UIKit

class PhotosCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var photos: [UIImage] = []

    func setPhotos(_ photos: [UIImage]) {
        self.photos = photos
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.register(UINib(nibName: "PhotoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "photocell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PhotosCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 10// photos.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as? PhotoCell else {
            fatalError()
        }

        if indexPath.item < photos.count {
            cell.photo.image = photos[indexPath.item]
        }
        return cell
    }
}

extension PhotosCell: UICollectionViewDelegate {

}
