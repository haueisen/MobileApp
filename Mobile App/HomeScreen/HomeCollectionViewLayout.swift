//
//  HomeCollectionViewLayout.swift
//  Mobile App
//
//  Created by flavio on 04/08/21.
//

import Foundation
import UIKit

class HomeCollectionViewLayout: UICollectionViewLayout {

    var contentBounds: CGRect = CGRect.zero
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []

    let heights: [CGFloat] = [296, 218, 234, 283, 253, 269]
    let margin: CGFloat = 16
    let numberOfColumns = 2
    
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        cachedAttributes.removeAll()
        contentBounds = CGRect.zero

        let count = collectionView.numberOfItems(inSection: 0)
        let collectionViewWidth = collectionView.bounds.size.width

        let columnWidth = (collectionViewWidth - CGFloat(numberOfColumns + 1) * margin) / CGFloat(numberOfColumns)

        let columnStart = [margin, 2 * margin + columnWidth]
        var columnHeight = [margin, margin]

        for itemIndex in 0..<count {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: itemIndex, section: 0))

            let column = columnHeight.firstIndex(of: columnHeight.min()!)!

            let height: CGFloat = heights.randomElement()!
            let rect = CGRect(x: columnStart[column], y: columnHeight[column], width: columnWidth, height: height)

            columnHeight[column] += height + margin

            attributes.frame = rect

            cachedAttributes.append(attributes)
            contentBounds = CGRect(x: 0, y: 0, width: collectionViewWidth, height: columnHeight.max()!)
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        for attributes in cachedAttributes {
            if rect.intersects(attributes.frame) {
                attributesArray.append(attributes)
            }
        }
        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
}
