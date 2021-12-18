//
//  LinkViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/31.
//

import LinkMoaBottomSheet
import LinkMoaCore
import LinkMoaKit
import UIKit

import Toast_Swift
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

final class FolderViewController: UIViewController, CustomAlert {
    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var notificationStackView: UIStackView!
    
    private let refreshControl = UIRefreshControl()
    private var folderHeaderView: FolderHeaderView?
    private let disposeBag = DisposeBag()
    
    private lazy var input = FolderViewModel.Input(
        fetchFolders: Signal.merge([
            fetchFolders.asSignal(),
            refreshControl.rx.controlEvent(.valueChanged).asSignal()
        ]),
        folderShareTapped: shareFolder.asSignal(),
        fetchFolderOrder: reorderFolder.asSignal(),
        removeFolder: removeFolder.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    // Trigger
    private let fetchFolders = PublishRelay<Void>()
    private let reorderFolder = PublishRelay<FolderFetchType>()
    private let removeFolder = PublishRelay<Int>()
    private let shareFolder = PublishRelay<Int>()
    private let folderWhenAddSucceed = PublishRelay<Void>() // 다른 VC 로 전달
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Dependency Injection
    private let viewModel: FolderViewModel
    weak var homeNC: HomeNavigationController? /// property injection
    
    init?(coder: NSCoder, viewModel: FolderViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchFolderWhenEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFolders.accept(())
        homeNC?.addButtonView.isHidden = false
    }
    
    @objc private func fetchFolderWhenEnterForeground() {
        fetchFolders.accept(())
    }

    private func bind() {
        output.sections
            .drive(folderCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    self.view.makeToastActivity(ToastPosition.center)
                } else {
                    self.view.hideToastActivity()
                    self.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
        output.isEmptyFolder
            .map { !$0 }
            .drive(notificationStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.removeBottomAlert
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.presentImageAlertView(type: .removeFolder)
            }
            .disposed(by: disposeBag)
        
        output.folderShareSheet
            .emit { [weak self] shareItem in
                guard let self = self else { return }
                let activityController = UIActivityViewController(
                    activityItems: [shareItem],
                    applicationActivities: nil
                )
                activityController.excludedActivityTypes = [
                    .saveToCameraRoll,
                    .print,
                    .assignToContact,
                    .addToReadingList
                ]
                self.present(activityController, animated: true)
            }
            .disposed(by: disposeBag)
        
        folderWhenAddSucceed
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.presentImageAlertView(type: .saveFolder)
            }
            .disposed(by: disposeBag)
        
        folderCollectionView.rx.modelSelected(FolderList.Result.self)
            .subscribe { [weak self] (folder: FolderList.Result) in
                guard let self = self else { return }
                let index = folder.index
                let vc: FolderDetailViewController = DIContainer.shared.resolve(
                    arguments: index, self.removeFolder
                )
                vc.homeNC = self.homeNC
                self.homeNC?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        homeNC?.addButtonView.rx
            .tapGesture()
            .when(.recognized)
            .filter { [weak self] _ in
                guard let self = self else { return false }
                guard nil != self.homeNC?.topViewController as? HomeViewController
                else {
                    return false
                }
                return true
            }
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.addButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareFolderCollectionView()
        prepareRefreshControler()
    }
    
    private func prepareRefreshControler() {
        folderCollectionView.refreshControl = refreshControl
    }
    
    private func prepareFolderCollectionView() {
        folderCollectionView.delegate = self
        folderCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(
            UINib(nibName: FolderCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: FolderCell.identifier
        )
        folderCollectionView.register(
            UINib(nibName: FolderHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FolderHeaderView.identifier
        )
    }
}

// MARK: - Present
extension FolderViewController {
    private func presentAddFolder() { // 폴더 추가 페이지 - 플로팅 버튼
        let vc: AddFolderNavigationController = DIContainer.shared.resolve(
            arguments: AddFolderType.add, 0, folderWhenAddSucceed
        )
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func presentAddLink() { // 링크 추가 페이지 - 플로팅 버튼
        let dependency = AddLinkViewModel.Dependency(
            currentFolder: nil,
            destinationFolder: nil,
            link: .init(),
            actionType: .add
        )
        
        let nc: SelectNaviagitonController = DIContainer.shared.resolve(
            arguments: dependency,
            folderWhenAddSucceed
        )
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    @objc private func headerSortButtonTapped() {
        let title = "정렬하기"
        let optionTitles = FolderFetchType.allCases.map { $0.title }
        let options = FolderFetchType.allCases.map { type in
            return { [weak self] (_: Any?) in
                guard let self = self else { return }
                self.reorderFolder.accept(type)
            }
        }
        
        presentOptionView(title: title, optionTitles: optionTitles, options: options)
    }
    
    @objc private func addButtonTapped() { // 플로팅 버튼 클릭됬을 떄
        presentOptionView(
            title: "추가하기",
            optionTitles: ["폴더 추가", "링크 추가"],
            options: [ { [weak self] _ in
                guard let self = self else { return }
                self.presentAddFolder()
            }, { [weak self] _ in
                guard let self = self else { return }
                self.presentAddLink()
            }]
        )
    }
}

// MARK: - RxDataSource
extension FolderViewController {
    private func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<FolderSectionData> {
        return RxCollectionViewSectionedAnimatedDataSource<FolderSectionData>(configureCell: {
            [weak self] dataSource, collectionView, indexPath, _ in
            guard let self = self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FolderCell.identifier,
                    for: indexPath
            ) as? FolderCell
            else {
                fatalError()
            }
            
            let folder = dataSource[indexPath]
            cell.update(by: folder)
            cell.gradientLayer.isHidden = false
            cell.editButton.rx.tapGesture()
                .when(.recognized)
                .throttle(RxTimeInterval.milliseconds(30), scheduler: MainScheduler.instance)
                .subscribe { (gesture: UITapGestureRecognizer) in
                    guard let button = gesture.view as? UICustomTagButton else { fatalError() }
                    let folderIndex = button.customTag
                    let title = "더보기"
                    let optionTitles = ["폴더 수정", "URL 공유하기", "삭제하기"] // "URL 공유하기"
                    let options = [ { (_: Any?) in // 폴더 수정 클릭
                        let nc: AddFolderNavigationController = DIContainer.shared.resolve(
                            arguments: AddFolderType.edit,
                            folderIndex,
                            self.folderWhenAddSucceed
                        )
                        nc.modalPresentationStyle = .fullScreen
                        self.present(nc, animated: true)
                    }, { (_: Any?) in
                        self.shareFolder.accept(folderIndex)
                    }, { (_: Any?) in // 삭제하기 클릭
                        self.presentTextRequestView(type: .removeFolder, name: folder.name) { _ in self.removeFolder.accept(folder.index)
                        }
                    }]
                    
                    self.presentOptionView(
                        title: title,
                        optionTitles: optionTitles,
                        options: options,
                        isIncludeRemoveButton: true
                    )
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }, configureSupplementaryView: { [weak self] _, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: FolderHeaderView.identifier,
                    for: indexPath
                ) as? FolderHeaderView
                else {
                    fatalError()
                }
                
                self.folderHeaderView = headerView
                
                self.output.folderCount.drive { count in
                    headerView.update(by: count)
                }
                .disposed(by: headerView.disposeBag)
                
                self.output.folderOrderTitle.drive { title in
                    headerView.sortLabel.text = title
                }
                .disposed(by: headerView.disposeBag)
                
                headerView.searchView.rx.tapGesture()
                    .when(.recognized)
                    .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
                    .subscribe { _ in
                        let vc: SearchNavigationController = DIContainer.shared.resolve(
                            argument: SearchType.my
                        )
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                    .disposed(by: headerView.disposeBag)
                
                headerView.sortButton.rx.tapGesture()
                    .when(.recognized)
                    .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        self.headerSortButtonTapped()
                    }
                    .disposed(by: headerView.disposeBag)
                                
                return headerView
            default:
                return UICollectionReusableView()
            }
        })
    }
}

extension FolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let width: CGFloat = view.frame.width
        let height: CGFloat = 160
        return CGSize(width: width, height: height)
    }
}

extension FolderViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
