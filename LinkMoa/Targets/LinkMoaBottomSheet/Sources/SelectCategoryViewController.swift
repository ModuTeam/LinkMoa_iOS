//
//  SelectCategoryBottomViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/17.
//

import UIKit

final class SelectCategoryViewController: UIViewController {
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var backGroundView: UIView!
    @IBOutlet private weak var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var categoryCollectionView: UICollectionView!

    var completion: (() -> Void)?
    var selection: ((String, Int) -> Void)? // 카테고리 이름 / 카테고리 넘버
    var blurVC: BackgroundBlur?
    var categoryNumbers: [Int] = []
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAndFadeIn()
        prepareBackgroundView()
        prepareCategoryCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preparebottomViewRoundConer()
    }
    
    private func prepareCategoryCollectionView() {
        let nib = UINib(nibName: SelectCategoryCell.cellIdentifier, bundle: Bundle.module)
        categoryCollectionView.register(nib, forCellWithReuseIdentifier: SelectCategoryCell.cellIdentifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionViewHeightConstraint.constant = CGFloat((categories.count / 2 + categories.count % 2) * 67)
    }
    
    private func preparebottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    private func prepareBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backGroundView.addGestureRecognizer(tapGesture)
        backGroundView.isUserInteractionEnabled = true
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion?()
        }
    }
    
    @objc private func backgroundViewTapped() {
        dismissAndFadeOut()
    }
    
    @IBAction func dismissButtonTapped() {
        dismissAndFadeOut()
    }
}

extension SelectCategoryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectCategoryCell.cellIdentifier, for: indexPath
        ) as? SelectCategoryCell
        else {
            fatalError()
        }
        
        categoryCell.update(title: categories[indexPath.item])
        return categoryCell
    }
}

extension SelectCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - (19 * 2) - 14) / 2
        let height: CGFloat = 54
        return CGSize(width: width, height: height)
    }
}

extension SelectCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let categoryNumber = categoryNumbers[indexPath.row]
        let categoryName = categories[indexPath.row]
        selection?(categoryName, categoryNumber)
        dismissAndFadeOut()
    }
}
