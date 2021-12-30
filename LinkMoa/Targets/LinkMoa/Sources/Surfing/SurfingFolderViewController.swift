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

    private let folderCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
        let nib = UINib(nibName: FolderCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FolderCell.identifier)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMedium(size: 20)
        label.textColor = .white
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegular(size: 14)
        label.textColor = .white
        return label
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .linkMoaDarkBlueColor
        return view
    }()
    
    private let noticeView = SurfingNoticeView(message: "아직 아무것도 찜하지 않았어요.")
    
    private lazy var inputs = SurfingFolderViewModel.Input(
        fetchFolder: fetchFolder.asSignal()
    )
    private lazy var outputs = viewModel.transform(input: inputs)
    private let disposeBag = DisposeBag()

    private let fetchFolder = PublishRelay<Void>()
    
    // Dependency Injection
    private let viewModel: SurfingFolderViewModel
    weak var homeNC: HomeNavigationController? /// Property Injection
   
    init(viewModel: SurfingFolderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
                    cellIdentifier: FolderCell.identifier,
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
        folderCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
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
}

extension SurfingFolderViewController {
    
    private func configureUI() {
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupUI() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(158)
        }
        print(Device.statusBarHeight + Device.navigationBarHeight)
        
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).inset(22)
            make.bottom.equalTo(topView.snp.bottom).inset(20)
        }
        
        topView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        view.addSubview(folderCollectionView)
        folderCollectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        view.addSubview(noticeView)
        noticeView.snp.makeConstraints { make in
            make.center.equalTo(folderCollectionView.snp.center)
        }
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
