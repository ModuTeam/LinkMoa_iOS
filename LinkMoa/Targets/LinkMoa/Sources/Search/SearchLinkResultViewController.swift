//
//  LinkListViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/10.
//

import UIKit
import LinkMoaKit
import LinkMoaCore

import RxSwift
import RxCocoa
import Toast_Swift

final class SearchLinkResultViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet private weak var linkCollectionView: UICollectionView!
    
    private lazy var inputs = SearchLinkResultViewModel.Input(
        searchKeyword: searchKeyword.asSignal(),
        searchMore: searchMore.asSignal()
    )
    private(set) lazy var outputs = viewModel.transform(input: inputs)
    private lazy var webManager: WebManager = DIContainer.shared.resolve(
        argument: self as UIViewController
    )
    
    private let searchKeyword = PublishRelay<String>()
    private let searchMore = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    let targetString = PublishRelay<String>()
    let scrollTrigger = PublishRelay<Bool>()

    private let viewModel: SearchLinkResultViewModel
    private let type: SearchType
    
    init?(coder: NSCoder, viewModel: SearchLinkResultViewModel, type: SearchType) {
        self.viewModel = viewModel
        self.type = type
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func bind() {
        targetString
            .subscribe { [weak self] (keyword: String) in
                guard let self = self else { return }
                self.searchKeyword.accept(keyword)
            }
            .disposed(by: disposeBag)
        
        outputs.results
            .drive(linkCollectionView.rx.items(
                cellIdentifier: LinkCell.cellIdentifier,
                cellType: LinkCell.self)) { _, result, cell in
                cell.update(by: result, isHiddenEdit: true)
            }
            .disposed(by: disposeBag)
        
        linkCollectionView.rx.modelSelected(SearchLink.Result.self)
            .bind { [weak self] link in
                guard let self = self else { return }
                self.webManager.openURL(link.url)
            }
            .disposed(by: disposeBag)
        
        linkCollectionView.rx.contentOffset
            .map { $0.y }
            .bind { [weak self] contentYoffset in
                guard let self = self else { return }
                self.scrollTrigger.accept(true)
                let contentYoffset = self.linkCollectionView.contentOffset.y
                let contentHeight = self.linkCollectionView.contentSize.height
                let scrollViewHeight = self.linkCollectionView.frame.size.height
                
                if contentYoffset > contentHeight - scrollViewHeight {
                    self.searchMore.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareLinkCollectionView()
    }

    private func prepareLinkCollectionView() {
        linkCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        linkCollectionView.collectionViewLayout = layout
        linkCollectionView.contentInset.top = 15
        linkCollectionView.contentInset.bottom = 50
        linkCollectionView.register(
            UINib(nibName: LinkCell.cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: LinkCell.cellIdentifier
        )
    }
}

extension SearchLinkResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (18 * 2)
        let height: CGFloat = 83
        return CGSize(width: width, height: height)
    }
}
