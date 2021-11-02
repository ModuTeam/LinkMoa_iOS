//
//  LeftAlignedCollectionViewFlowLayout.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/17.
//

import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: TagLayoutDelegate?
    
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
        
    private var contentHeight: CGFloat = 34
    private var cache: [UICollectionViewLayoutAttributes] = []

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }

        let cellPadding: CGFloat = 6
        let cellHeight: CGFloat = 34
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let tagWidth = delegate?.collectionView(collectionView, widthForTagAtIndexPath: indexPath) ?? 100
            let width = cellPadding * 2 + tagWidth
            
            if (xOffset + width) > collectionView.frame.width {
                xOffset = 0
                yOffset += cellHeight + cellPadding * 2
                contentHeight += cellHeight + cellPadding * 2
            }
            
            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            xOffset += width
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) { // 셀 frame 과 요청 Rect 가 교차한다면, 리턴 값에 추가합니다.
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
