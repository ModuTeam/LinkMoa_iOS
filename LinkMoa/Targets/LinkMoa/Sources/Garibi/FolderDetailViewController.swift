//
//  BookMarkDetailViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
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

// internal for subclassing
internal class FolderDetailViewController: UIViewController, CustomAlert, BackgroundBlur {
    @IBOutlet private weak var folderTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var linkCountLabel: UILabel!
    @IBOutlet private weak var lockImageView: UIImageView!
    @IBOutlet private weak var subHeaderView: UIView!
    @IBOutlet private weak var linkCollectionView: UICollectionView!
    @IBOutlet private weak var notificationStackView: UIStackView!
    @IBOutlet private weak var blueViewHeightConstraint: NSLayoutConstraint!

    private lazy var input = FolderDetailViewModel.Input(
        fetchFolder: Signal.merge([
            fetchFolder.asSignal(),
            enterForeground.asSignal()
        ]),
        removeLink: removeLink.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private lazy var webManager: WebManager = DIContainer.shared.resolve(
        argument: self as UIViewController
    )
    
    // trigger
    private let removeLink = PublishRelay<Int>()
    private let removeFolder = PublishRelay<Void>()
    private var removeFolderTapped = PublishRelay<Void>()
    private let enterForeground = PublishRelay<Void>()
    private let fetchFolder = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    // Event
    private let folderActionSucceedTrigger = PublishRelay<Void>()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Dependency Injection
    internal let viewModel: FolderDetailViewModel /// internal for subclassing
    private let removeFolderTrigger: PublishRelay<Int> /// FolderVC 삭제 트리거
    weak var homeNC: HomeNavigationController? /// property injection
    
    init?(
        coder: NSCoder,
        viewModel: FolderDetailViewModel,
        removeFolderTrigger: PublishRelay<Int>
    ) {
        self.viewModel = viewModel
        self.removeFolderTrigger = removeFolderTrigger
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFolder.accept(())
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        output.errorMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message)
            }
            .disposed(by: disposeBag)
        
        output.bottomAlert
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.presentImageAlertView()
            }
            .disposed(by: disposeBag)
        
        output.sections
            .drive(linkCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.folderName
            .drive(folderTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive { [weak self] isLoading in
                guard let self = self else { return }
                
                if isLoading {
                    self.view.makeToastActivity(.center)
                } else {
                    self.view.hideToastActivity()
                }
            }
            .disposed(by: disposeBag)
        
        output.tags
            .drive { [weak self] tags in
                guard let self = self else { return }
                self.updateTagStackView(by: tags)
            }
            .disposed(by: disposeBag)
        
        output.linksCount
            .map { String($0) }
            .drive(linkCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isShared
            .drive(lockImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isEmptyFolder
            .map { !$0 }
            .drive(notificationStackView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        linkCollectionView.rx.modelSelected(FolderDetail.Link.self)
            .subscribe { [weak self] (link: FolderDetail.Link) in
                guard let self = self else { return }
                self.webManager.openURL(link.url)
            }
            .disposed(by: disposeBag)
        
        homeNC?.addButtonView.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] _ in
                guard let self = self else { return false }
                guard self === self.homeNC?.topViewController else { return false }
                return true
            }
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.addButtonTapped()
            }
            .disposed(by: disposeBag)
        
        removeFolderTapped
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: true)
                    self.removeFolderTrigger.accept(self.viewModel.folderIndex)
                }
            }
            .disposed(by: disposeBag)
        
        folderActionSucceedTrigger
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.presentImageAlertView(type: .saveFolder, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareLinkCollectionView()
        prepareSubHeaderView()
        prepareNavigationItem()
        prepareNavigationBar()
    }
    
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = UILabel(frame: CGRect.zero)
            label.text = "#" + tag
            label.textColor = UIColor.white
            label.font = UIFont(name: "NotoSansKR-Regular", size: 14)

            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.delegate = self
        linkCollectionView.register(
            UINib(nibName: LinkCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LinkCell.identifier
        )
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        blueViewHeightConstraint.constant = Device.statusBarHeight + Device.navigationBarHeight + 168
    }
    
    private func prepareNavigationItem() {
        let editBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "editDot"),
            style: .plain,
            target: self,
            action: #selector(folderEditButtonTapped)
        )
        editBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        editBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    private func prepareSubHeaderView() {
        subHeaderView.layer.masksToBounds = true
        subHeaderView.layer.cornerRadius = 10
    }
    
    @objc func folderEditButtonTapped() {
        let title = "더보기"
        let optionTitles = ["폴더 수정", "URL 공유하기", "삭제하기"]
        let options = [ { [weak self] (_: Any?) in // 폴더 수정 클릭
            guard let self = self else { return }
            
            let folderIndex = self.viewModel.folderIndex
            let vc: AddFolderNavigationController = DIContainer.shared.resolve(
                arguments: AddFolderType.edit, folderIndex, self.folderActionSucceedTrigger
            )
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }, { [weak self] (_: Any?) in
            guard let self = self else { return }
            
            let shareItem = self.viewModel.shareItem
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
        }, { [weak self] (_: Any?) in // 삭제하기
            guard let self = self else { return }
            
            self.presentTextRequestView(name: self.viewModel.removeFolderName) { _ in
                self.removeFolderTapped.accept(())
            }
        }]

        presentOptionView(
            title: title,
            optionTitles: optionTitles,
            options: options,
            isIncludeRemoveButton: true
        )
    }
    
    @objc private func addButtonTapped() {
        let folder = viewModel.folder
        let dependency = AddLinkViewModel.Dependency(
            currentFolder: (name: folder.name, index: folder.folderIndex),
            destinationFolder: nil,
            link: .init(),
            actionType: .add
        )
        
        let nc: SelectNaviagitonController = DIContainer.shared.resolve(
            arguments: dependency,
            self.folderActionSucceedTrigger
        )
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
    }
    
    private func linkEditButtonTapped(index: Int) { // edit 버튼 클릭됬을 때
        guard let link = viewModel.links.filter({ $0.index == index }).first else { return }
        
        let title = "더보기"
        let optionTitles = ["링크 수정", "URL 공유하기", "삭제하기"] // "URL 공유하기"
        let options = [ { [weak self] (_: Any?) in // 링크 수정
            guard let self = self else { return }
            let folder = self.viewModel.folder
            let dependency = AddLinkViewModel.Dependency(
                currentFolder: (name: folder.name, index: folder.folderIndex),
                destinationFolder: nil,
                link: link,
                actionType: .edit
            )
            
            let nc: SelectNaviagitonController = DIContainer.shared.resolve(
                arguments: dependency,
                self.folderActionSucceedTrigger
            )
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: true)
        }, { [weak self] (_: Any?) in // URL 공유하기
            guard let self = self else { return }
             let activityController = UIActivityViewController(
                activityItems: ["\(link.name)\n\(link.url)"],
                applicationActivities: nil
             )
             activityController.excludedActivityTypes = [
                .saveToCameraRoll,
                .print,
                .assignToContact,
                .addToReadingList
             ]
            
             self.present(activityController, animated: true)
        }, { [weak self] (_: Any?) in // 삭제하기
            guard let self = self else { return }
            self.removeLink.accept(index)
        }]

        presentOptionView(
            title: title,
            optionTitles: optionTitles,
            options: options,
            isIncludeRemoveButton: true
        )
    }
    
    @objc private func willEnterForeground() {
        enterForeground.accept(())
    }
}

extension FolderDetailViewController {
    func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<LinkSectionData> {
        return RxCollectionViewSectionedAnimatedDataSource(configureCell: {
            [weak self] dataSource, collectionView, indexPath, _ in
                guard let self = self else { fatalError() }
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LinkCell.identifier,
                    for: indexPath
                ) as? LinkCell
                else {
                    fatalError()
                }
                
                let link = dataSource[indexPath]
                cell.update(by: link)
                cell.editButton.rx.tapGesture()
                    .when(.recognized)
                    .subscribe { [weak self] (sender: UITapGestureRecognizer) in
                        guard let self = self else { return }
                        guard let button = sender.view as? UICustomTagButton else { return }
                        let linkIndex = button.customTag
                        self.linkEditButtonTapped(index: linkIndex)
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        )
    }
}

extension FolderDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension FolderDetailViewController: UICollectionViewDelegateFlowLayout {
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
