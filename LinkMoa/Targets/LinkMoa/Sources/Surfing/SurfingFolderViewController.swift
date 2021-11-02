//
//  SavedFolderViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import LinkMoaCore
import UIKit

import RxCocoa
import RxSwift

enum SurfingFolderType {
    case topTen
    case liked
    case users(name: String, index: Int)
    
    var title: String {
        switch self {
        case .topTen:
            return "TOP 10 링크달"
        case .liked:
            return "찜한 링크달"
        case .users(let name, _):
            return name
        }
    }
}

final class SurfingFolderViewController: UIViewController {
    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var noticeView: UIStackView!

    private lazy var inputs = SurfingFolderViewModel.Input(
        fetchFolder: fetchFolder.asSignal()
    )
    private lazy var outputs = viewModel.transform(input: inputs)
    private let disposeBag = DisposeBag()

    private let fetchFolder = PublishRelay<Void>()
    
    // Dependency Injection
    private let viewModel: SurfingFolderViewModel
    weak var homeNC: HomeNavigationController? /// Property Injection
    
    init?(coder: NSCoder, viewModel: SurfingFolderViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFolder.accept(())
    }
    
    private func bind() {
        outputs.folders
            .drive(folderCollectionView.rx.items(
                    cellIdentifier: FolderCell.cellIdentifier,
                    cellType: FolderCell.self)
            ) { _, result, cell in
                cell.update(by: result)
            }
            .disposed(by: disposeBag)
        
        outputs.folderCount
            .map { $0.toAbbreviationString }
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.toastMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
        
        outputs.isHiddenNoticeView
            .drive(noticeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.isHiddenCountLabel
            .drive(countLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        folderCollectionView.rx.modelSelected(IntegratedFolder.self)
            .bind { [weak self] (folder: IntegratedFolder) in
                guard let self = self else { return }
                let vc: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                    argument: folder.folderIndex
                )
                vc.homeNC = self.homeNC
                self.homeNC?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareFolderCollectionView()
        prepareNavigationBar()
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func prepareFolderCollectionView() {
        folderCollectionView.delegate = self
        let nib = UINib(nibName: FolderCell.cellIdentifier, bundle: Bundle.module)
        folderCollectionView.register(nib, forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        let layout = UICollectionViewFlowLayout()
        folderCollectionView.collectionViewLayout = layout
        folderCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
    }
}

extension SurfingFolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (folderCollectionView.frame.width - 47) / 2
        let height: CGFloat = 214
        return CGSize(width: width, height: height)
    }
}
