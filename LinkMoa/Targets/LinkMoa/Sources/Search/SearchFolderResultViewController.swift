//
//  SearchFolderResultViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/06/10.
//

import LinkMoaCore
import LinkMoaKit
import UIKit

import RxCocoa
import RxSwift
import Toast_Swift

final class SearchFolderResultViewController: UIViewController {
    @IBOutlet private weak var folderCollectionView: UICollectionView!
    
    private lazy var inputs = SearchFolderResultViewModel.Input(
        searchKeyword: searchKeyword.asSignal(),
        searchMore: searchMore.asSignal()
    )
    private(set) lazy var outputs = viewModel.transform(input: inputs)
    
    private let searchKeyword = PublishRelay<String>()
    private let searchMore = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    let targetString = PublishRelay<String>()
    let scrollTrigger = PublishRelay<Bool>()

    // DI
    private let viewModel: SearchFolderResultViewModel
    private let type: SearchType
    
    init?(coder: NSCoder, viewModel: SearchFolderResultViewModel, type: SearchType) {
        self.viewModel = viewModel
        self.type = type
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
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
            .drive(folderCollectionView.rx.items(cellIdentifier: FolderCell.cellIdentifier, cellType: FolderCell.self)) { [weak self] _, result, cell in
                guard let self = self else { return }
                cell.update(by: result, isHiddenLike: self.type == .my)
            }
            .disposed(by: disposeBag)
        
        folderCollectionView.rx.modelSelected(IntegratedFolder.self)
            .bind { [weak self] folder in
                guard let self = self else { return }
                switch self.type {
                case .my:
                    let vc: SearchFolderDetailViewController = DIContainer.shared.resolve(
                        argument: folder.folderIndex
                    )
                    self.navigationController?.pushViewController(vc, animated: true)
                case .surfing:
                    let vc: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                        argument: folder.folderIndex
                    )
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        folderCollectionView.rx.contentOffset
            .map { $0.y }
            .bind { [weak self] contentYoffset in
                guard let self = self else { return }
                self.scrollTrigger.accept(true)
                let contentYoffset = self.folderCollectionView.contentOffset.y
                let contentHeight = self.folderCollectionView.contentSize.height
                let scrollViewHeight = self.folderCollectionView.frame.size.height
                
                if contentYoffset > contentHeight - scrollViewHeight {
                    self.searchMore.accept(())
                }
            }
            .disposed(by: disposeBag)
    }

    private func prepareFolderCollectionView() {
        folderCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        folderCollectionView.collectionViewLayout = layout
        folderCollectionView.contentInset = UIEdgeInsets(top: 24, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(
            UINib(nibName: FolderCell.cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: FolderCell.cellIdentifier
        )
    }
}

extension SearchFolderResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        return CGSize(width: width, height: height)
    }
}
