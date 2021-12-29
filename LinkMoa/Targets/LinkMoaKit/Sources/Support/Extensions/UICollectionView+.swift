//
//  UICollectionView+.swift
//  LinkMoaKit
//
//  Created by Beomcheol Kwon on 2021/12/28.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable & NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
    }
    
    func registerFooter<T: UICollectionReusableView>(_: T.Type) where T: Reusable {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }
        
        return cell
    }
    
    func dequeueReusableHeaderView<T: UICollectionReusableView>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
    
    func dequeueReusableFooterView<T: UICollectionReusableView>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
}

