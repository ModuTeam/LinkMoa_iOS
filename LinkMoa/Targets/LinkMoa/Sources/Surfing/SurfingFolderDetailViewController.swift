//
//  SurfingFolderDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import LinkMoaBottomSheet
import LinkMoaCore
import LinkMoaKit
import UIKit

import Toast_Swift
import RxSwift
import RxCocoa

final class SurfingFolderDetailViewController: UIViewController, CustomAlert, BackgroundBlur {
    
    private let linkCollectionView2: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
        let nib = UINib(nibName: FolderCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FolderCell.identifier)
        return collectionView
    }()
    
    private let folderTitleLabel2: UILabel = {
        let label = UILabel()
        label.font = .notoSansMedium(size: 20)
        label.textColor = .white
        return label
    }()
    
    private let linkCountLabel2: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegular(size: 14)
        label.textColor = .white
        return label
    }()
    
    private let likeCountLabel2: UILabel = {
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
    
    let tagStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let heartImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "seeshelCharacter")
        return imageView
    }()
    
    let seashellImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "seeshelCharacter")
        return imageView
    }()
    
    
    
    private let noticeView2 = SurfingNoticeView(message: "아직 아무것도 저장하지 않았어요.")
    
    @IBOutlet private weak var folderTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var linkCountLabel: UILabel!
    @IBOutlet private weak var likeCountLabel: UILabel!
    @IBOutlet private weak var userNameButton: UIButton!
    @IBOutlet private weak var linkCollectionView: UICollectionView!
    @IBOutlet private weak var heartImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var noticeView: UIStackView!
    
    @IBOutlet private weak var blueViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var inputs = SurfingFolderDetailViewModel.Input(
        fetchFolderDetail: fetchFolderTrigger.asSignal(),
        likeAction: likeTrigger.asSignal(),
        reportAction: reportTrigger.asSignal()
    )
    private lazy var outputs = viewModel.transform(input: inputs)
    private lazy var webManager: WebManager = DIContainer.shared.resolve(
        argument: self as UIViewController
    )
    
    private let fetchFolderTrigger = PublishRelay<Void>()
    private let likeTrigger = PublishRelay<Void>()
    private let reportTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // Dependency Injection
    private let viewModel: SurfingFolderDetailViewModel
    weak var homeNC: HomeNavigationController?
    
    init?(coder: NSCoder, viewModel: SurfingFolderDetailViewModel) {
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
        fetchFolderTrigger.accept(())
        homeNC?.addButtonView.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        outputs.isHiddenNoticeView
            .drive(noticeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.folderDetail
            .drive { [weak self] results in
                guard let self = self else { return }
                self.view.hideToastActivity()
                self.updateUI(folderDetail: results)
            }
            .disposed(by: disposeBag)
        
        outputs.folderDetail
            .map { $0.linkList }
            .drive(linkCollectionView.rx.items(
                cellIdentifier: LinkCell.identifier,
                cellType: LinkCell.self
            )) {
                _, result, cell in
                cell.update(by: result, isHiddenEdit: true)
            }
            .disposed(by: disposeBag)
  
        outputs.likeResult
            .drive { [weak self] results in
                guard let self = self else { return }
                self.updateLikeStatus(status: results.status, count: results.count)
            }
            .disposed(by: disposeBag)
        
        outputs.reportResult
            .drive { [weak self] isReported in
                guard let self = self else { return }
                if isReported {
                    self.presentImageAlertView(type: .reportFolder)
                }
            }
            .disposed(by: disposeBag)
        
        linkCollectionView.rx.modelSelected(FolderDetail.Link.self)
            .bind { [weak self] link in
                guard let self = self else { return }
                self.webManager.openURL(link.url)
            }
            .disposed(by: disposeBag)
        
        userNameButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let type = SurfingFolderType.users(
                    name: self.viewModel.userNickname,
                    index: self.viewModel.userIndex
                )
                let vc: SurfingFolderViewController = DIContainer.shared.resolve(argument: type)
                vc.homeNC = self.homeNC
                self.homeNC?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.likeTrigger.accept(())
            }
            .disposed(by: disposeBag)

        outputs.errorMessage
            .emit { [weak self] errorMessage in
                guard let self = self else { return }
                self.view.makeToast(errorMessage, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareNavigation()
        prepareLinkCollectionView()
    }
    
    private func updateUI(folderDetail: FolderDetail.Result) {
        let tags = folderDetail.hashTagList.map { $0.name }
        updateTagStackView(tags: tags)
        folderTitleLabel.text = folderDetail.name
        userNameButton.setTitle(folderDetail.userNickname, for: .normal)
        linkCountLabel.text = folderDetail.linkCount.toAbbreviationString
        updateLikeStatus(
            status: folderDetail.likeStatus,
            count: folderDetail.likeCount
        )
        
    }
    
    private func updateLikeStatus(status: Int, count: Int) {
        likeCountLabel.text = count.toAbbreviationString
        let imageName = status == 1 ? "heart.fill" : "heart"
        heartImageView.image = UIImage(systemName: imageName)
    }
    
    private func updateTagStackView(tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = UILabel(frame: CGRect.zero)
            label.text = "#" + tag
            label.textColor = UIColor.white
            label.font = .notoSansRegular(size: 14)
            
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func prepareNavigation() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        blueViewHeightConstraint.constant = Device.statusBarHeight + Device.navigationBarHeight + 168
        
        let shareBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "editDot"),
            style: .plain,
            target: self,
            action: #selector(shareBarButtonTapped(_:))
        )
        
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        shareBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItems = [shareBarButtonItem]
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.delegate = self
        let nib = UINib(nibName: LinkCell.identifier, bundle: nil)
        linkCollectionView.register(nib, forCellWithReuseIdentifier: LinkCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 21, left: 0, bottom: 21, right: 0)
        linkCollectionView.collectionViewLayout = layout
    }
    
    @objc private func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        let title = "더보기"
        let isIncludeRemoveButton = true // 마지막 label red
        let optionTitles = ["URL 공유하기", "신고하기"]
        let options = [
            { [weak self] (_: Any?) in
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
            },
            { [weak self] (_: Any?) in
                guard let self = self else { return }
                self.presentReconfirmView(type: .reportFolder) {
                    self.reportTrigger.accept(())
                }
            }
        ]
        
        self.presentOptionView(
            title: title,
            optionTitles: optionTitles,
            options: options,
            isIncludeRemoveButton: isIncludeRemoveButton
        )
    }
}

extension SurfingFolderDetailViewController: UICollectionViewDelegateFlowLayout {
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
