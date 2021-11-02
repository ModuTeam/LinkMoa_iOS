//
//  TagLayoutDelegate.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/02.
//

import UIKit

public protocol TagLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForTagAtIndexPath indexPath: IndexPath
    ) -> CGFloat
}
