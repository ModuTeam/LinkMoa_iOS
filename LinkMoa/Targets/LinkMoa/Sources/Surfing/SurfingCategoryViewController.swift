//
//  CategoryDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import LinkMoaCore
import LinkMoaKit
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Toast_Swift
import SwiftUI

final class SurfingCategoryViewController: UIViewController {
    
    let folderCollectionView2: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.layer.zPosition = -2
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let nib = UINib(nibName: FolderCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FolderCell.identifier)
        return collectionView
    }()
    
    let titleLabel2: UILabel = {
        let label = UILabel()
        return label
    }()
    let tagCollectionView2: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
        collectionView.register(SurfingCategoryTagCell.classForCoder(), forCellWithReuseIdentifier: SurfingCategoryTagCell.identifier)
     
         return collectionView
    }()
    let textView2: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        return view
    }()
    let containerView2: UIView = {
        let view = UIView()
        view.layer.zPosition = -1
        return view
    }()
    let noticeStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let noticeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "seeshelCharacter")
        return imageView
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegular(size: 16)
        label.text = "카테고리에 맞는 가리비가 아직 없어요."
        return label
    }()
    
    func setupUI() {
        view.addSubview(textView2)
        textView2.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(132)
        }
        
        textView2.addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { make in
            make.left.equalTo(textView2.snp.left).inset(19)
            make.bottom.equalTo(textView2.snp.bottom).inset(10)
            make.height.equalTo(24)
        }
        
        view.addSubview(folderCollectionView2)
        folderCollectionView2.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(textView2)
        }
        
        view.addSubview(noticeStackView2)
        noticeStackView2.snp.makeConstraints { make in
            make.center.equalTo(folderCollectionView2.snp.center)
        }
        
        noticeStackView2.addArrangedSubview(noticeImageView)
        noticeStackView2.addArrangedSubview(noticeLabel)
        noticeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        view.addSubview(containerView2)
        containerView2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(textView2)
        }
        
        containerView2.addSubview(tagCollectionView2)
        tagCollectionView2.snp.makeConstraints { make in
            make.left.right.equalTo(containerView2).inset(20)
            make.top.bottom.equalTo(containerView2).inset(10)
            make.height.equalTo(100).priority(.low)
        }
    }
    
    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    
    @IBOutlet private weak var textView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var noticeStackView: UIStackView!
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tagTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var blueViewHeightConstraint: NSLayoutConstraint!
    
    
    private let refreshControl = UIRefreshControl()
    private let categoryMain = ["개발", "디자인", "마케팅/광고", "기획", "기타"]
    private var tagLength: [CGFloat] = []
    private var lastContentOffset: CGFloat = 0
    private var tagDynamicHeight: CGFloat = 0
    private var containerViewHeight: CGFloat = 0
    
    private lazy var inputs = SurfingCategoryViewModel.Input(
        fetchFolders: fetchFolders.asSignal(),
        resetFolders: resetFolders.asSignal(),
        fetchCategory: fetchCategory.asSignal(),
        changeSubIndex: changeSubIndex.asSignal()
    )
    private lazy var outputs = viewModel.transform(input: inputs)
    
    private let fetchFolders = PublishRelay<Void>()
    private let resetFolders = PublishRelay<Void>()
    private let fetchCategory = PublishRelay<Void>()
    private let changeSubIndex = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    // Dependency Injection
    private let viewModel: SurfingCategoryViewModel
    weak var homeNC: HomeNavigationController?
    
    init?(coder: NSCoder, viewModel: SurfingCategoryViewModel)  {
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
        fetchCategory.accept(())
        fetchFolders.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollBind()
    }
    
    private func bind() {
        outputs.isHiddenNoticeView
            .drive(noticeStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.categories
            .drive(tagCollectionView.rx.items(
                cellIdentifier: SurfingCategoryTagCell.identifier,
                cellType: SurfingCategoryTagCell.self)
            ) { _, result, cell in
                cell.update(by: result)
            }.disposed(by: disposeBag)

        outputs.categories
            .drive { [weak self] result in
                guard let self = self else { return }
                let font = UIFont.notoSansMedium(size: 14)
                self.tagLength = result.map {
                    $0.detailName.size(withAttributes: [NSAttributedString.Key.font: font]).width + 40
                }
                self.tagCollectionView.selectItem(
                    at: IndexPath(item: 0, section: 0),
                    animated: false,
                    scrollPosition: .left
                )
                // 태그 갯수에 따라 컨테이너 뷰 높이 동적으로 변경하기
                self.tagDynamicHeight = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.collectionViewHeightConstraint.constant = self.tagDynamicHeight
                self.tagCollectionView2.snp.remakeConstraints { make in
                    make.left.right.equalTo(self.containerView2).inset(20)
                    make.top.bottom.equalTo(self.containerView2).inset(10)
                    make.height.equalTo(self.tagDynamicHeight).priority(.low)
                }
                
                self.containerViewHeight = self.tagDynamicHeight + 20
                // 폴더 셀이 태그따라서 안올라가도록 수정
                self.folderCollectionView.contentInset.top = self.containerViewHeight + 15
                self.folderCollectionView.verticalScrollIndicatorInsets.top = self.containerViewHeight
                self.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)

        tagCollectionView.rx.modelSelected(CategoryInfo.DetailCategoryList.self)
            .bind { [weak self] result in
                guard let self = self else { return }
                self.folderCollectionView.setContentOffset(
                    .init(x: -15, y: -self.containerViewHeight - 15),
                    animated: false
                )
                self.changeSubIndex.accept(result.detailIndex)
                self.resetFolderData()
                self.fetchData()
            }
            .disposed(by: disposeBag)
        
        outputs.categoryDetailFolders
            .drive(folderCollectionView.rx.items(cellIdentifier: FolderCell.identifier, cellType: FolderCell.self)) { _, result, cell in
                cell.update(by: result)
            }.disposed(by: disposeBag)

        outputs.categoryDetailFolders
            .drive { [weak self] _ in
                guard let self = self else { return }
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
        folderCollectionView.rx.modelSelected(IntegratedFolder.self)
            .bind { [weak self] folder in
                guard let self = self else { return }
                let vc: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                    argument: folder.folderIndex
                )
                vc.homeNC = self.homeNC
                self.homeNC?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
                
        outputs.toastMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollBind() {
        folderCollectionView.rx.contentOffset
            .map { $0.y }
            .bind { [weak self] contentYoffset in
                guard let self = self else { return }
                let contentHeight = self.folderCollectionView.contentSize.height
                let scrollViewHeight = self.folderCollectionView.frame.size.height
                let delta = contentYoffset - self.lastContentOffset
             
                if delta < 0 {
                    // 스크롤 내릴 때
                    if scrollViewHeight + contentYoffset <= contentHeight + 15,
                        contentHeight + 30 > scrollViewHeight {
                        self.tagTopConstraint.constant = min(self.tagTopConstraint.constant - delta, 0)
                    }
                } else {
                    // 스크롤 올릴 때
                    if contentYoffset + self.containerViewHeight + 15 >= 0,
                        contentHeight + 30 > scrollViewHeight {
                        self.tagTopConstraint.constant = max(
                            -self.containerViewHeight,
                             self.tagTopConstraint.constant - delta
                        )
                    }
                }
                
                self.lastContentOffset = contentYoffset
                
                if contentYoffset > contentHeight - scrollViewHeight {
                    self.fetchFolders.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareNavigationBar()
        prepareRefreshControler()
    }
    
    private func fetchData() {
        fetchFolders.accept(())
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        blueViewHeightConstraint.constant = Device.statusBarHeight + Device.navigationBarHeight + 44
    }
    
    @objc private func pullToRefresh() {
        resetFolderData()
        fetchData()
    }

    private func resetFolderData() {
        resetFolders.accept(())
    }
    
    private func prepareRefreshControler() {
        folderCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
}

extension SurfingCategoryViewController: TagLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForTagAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        return tagLength[indexPath.item]
    }
}

extension SurfingCategoryViewController: UICollectionViewDelegateFlowLayout {
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
