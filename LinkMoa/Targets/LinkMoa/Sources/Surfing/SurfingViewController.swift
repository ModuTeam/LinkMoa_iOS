//
//  SurfingViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class SurfingViewController: UIViewController {
    @IBOutlet private weak var surfingCollectionView: UICollectionView!
    
    private lazy var inputs: SurfingViewModel.Input = .init(
        fetchTopTenFolders: topTenTrigger.asSignal(),
        fetchLikedFolders: likedTrigger.asSignal()
    )
    private lazy var outputs: SurfingViewModel.Output = viewModel.transform(input: inputs)
    
    private let topTenTrigger = PublishRelay<Void>()
    private let likedTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private var lastContentOffset: CGFloat = 0
    
    // Dependency Injection
    private let viewModel: SurfingViewModel
    weak var homeNC: HomeNavigationController? /// property injection
    
    init?(coder: NSCoder, viewModel: SurfingViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topTenTrigger.accept(())
        likedTrigger.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homeNC?.addButtonView.isHidden = true
    }
    
    private func bind() {
        let dataSource = dataSource()
        
        outputs.sections
            .drive(surfingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        surfingCollectionView.rx.modelSelected(SurfingSectionItem.self)
            .bind { [weak self] folderSection in
                guard let self = self else { return }
                switch folderSection {
                case let .topTenItem(folder), let .likedItem(folder):
                    let vc: SurfingFolderDetailViewController = DIContainer.shared.resolve(
                        argument: folder.folderIndex
                    )
                    vc.homeNC = self.homeNC
                    self.homeNC?.pushViewController(vc, animated: true)
                case .categoryItem(let index):
                    let vc: SurfingCategoryViewController = DIContainer.shared.resolve(
                        argument: index
                    )
                    vc.homeNC = self.homeNC
                    self.homeNC?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        outputs.errorMessage
            .emit { [weak self] errorMessage in
                guard let self = self else { return }
                self.view.makeToast(errorMessage, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func prepareCollectionView() {
        surfingCollectionView.register(
            UINib(nibName: FolderCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: FolderCell.identifier
        )
        surfingCollectionView.register(SurfingCategoryCell.classForCoder(), forCellWithReuseIdentifier: SurfingCategoryCell.identifier)
        surfingCollectionView.register(SurfingHeaderView.classForCoder(),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SurfingHeaderView.identifier
        )
        surfingCollectionView.register(SurfingFooterView.classForCoder(),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SurfingFooterView.identifier
        )
        surfingCollectionView.register(
            UINib(nibName: SurfingSearchHeaderView.reuseableViewIndetifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SurfingSearchHeaderView.reuseableViewIndetifier
        )
        surfingCollectionView.collectionViewLayout = createSectionLayout()
    }
    
    @objc private func viewTapped() {
        let vc: SearchNavigationController = DIContainer.shared.resolve(
            argument: SearchType.surfing
        )
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func headerViewTapped(_ sender: UIGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            let type = SurfingFolderType.topTen
            let vc: SurfingFolderViewController = DIContainer.shared.resolve(argument: type)
            vc.homeNC = homeNC
            homeNC?.pushViewController(vc, animated: true)
        case 2:
            let type = SurfingFolderType.liked
            let vc: SurfingFolderViewController = DIContainer.shared.resolve(argument: type)
            vc.homeNC = homeNC
            homeNC?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

// MARK: - DataSource & Layout
extension SurfingViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SurfingSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SurfingSectionModel>(configureCell: { dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .topTenItem(let folder):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FolderCell.identifier, for: indexPath
                ) as? FolderCell
                else {
                    return UICollectionViewCell()
                }
                
                cell.update(by: folder)
                return cell
            case .categoryItem:
                guard let cell: SurfingCategoryCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SurfingCategoryCell.identifier, for: indexPath
                ) as? SurfingCategoryCell
                else {
                    return UICollectionViewCell()
                }
                
                cell.index = indexPath.item
                cell.categoryImageView.image = UIImage(named: "category_\(indexPath.item)")
                return cell
            case .likedItem(let folder):
                guard let cell: FolderCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FolderCell.identifier,
                    for: indexPath
                ) as? FolderCell
                else {
                    return UICollectionViewCell()
                }
                
                cell.gradientLayer.isHidden = false
                cell.update(by: folder)
                return cell
            default:
                return UICollectionViewCell()
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { fatalError() }
            let headerTitle = ["TOP10 링크달", "카테고리", "찜한 링크달"]
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if indexPath.section == 0 {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SurfingSearchHeaderView.reuseableViewIndetifier, for: indexPath) as? SurfingSearchHeaderView else { fatalError() }
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
                    tapGesture.cancelsTouchesInView = false
                    headerView.searchView.addGestureRecognizer(tapGesture)
                    headerView.searchView.isUserInteractionEnabled = true
                    
                    let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.headerViewTapped(_:)))
                    tapGesture2.cancelsTouchesInView = false
                    headerView.titleHeaderView.addGestureRecognizer(tapGesture2)
                    headerView.titleHeaderView.isUserInteractionEnabled = true
                    
                    return headerView
                } else if indexPath.section > 0 && indexPath.section < 3  {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SurfingHeaderView.identifier, for: indexPath) as? SurfingHeaderView else { fatalError() }
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerViewTapped(_:)))
                    headerView.tag = indexPath.section
                    headerView.gestureRecognizers?.forEach {headerView.removeGestureRecognizer($0)}
                    headerView.addGestureRecognizer(tapGesture)
                    headerView.titleLabel.text = headerTitle[indexPath.section]
                    headerView.moreButton.isHidden = headerView.tag == 1 ? true: false
                    
                    return headerView
                }
                return UICollectionReusableView()
                
            case UICollectionView.elementKindSectionFooter:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SurfingFooterView.identifier, for: indexPath) as? SurfingFooterView else { fatalError() }
                return footerView
            
            default:
                return UICollectionReusableView()
            }
        })
    }
    
    private func createSectionLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, _) -> NSCollectionLayoutSection? in
            // 인셋이 좌우상하로 들어가기 때문에 원래 의도한 16의 1/2값을 사용함
            let inset: CGFloat = 8
            var itemsPerRow: Int = 2
            // height 는 214 고정값이고 item inset을 적용하면 셀 안쪽으로 작아지기 때문에 인셋추가
            var height: CGFloat = 214 + inset * 2
            
            // 가운데 섹션만 레이아웃이 달라 sectionIndex로 구분
            if sectionIndex == 1 {
                itemsPerRow = 1
                height = 67 + inset * 2
            }
            
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            
            /// item
            var itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(height))
            
            if sectionIndex == 1 {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(height))
            }
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            /// Group
            var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            
            if sectionIndex == 1 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            }
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            /// Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            /// Supplementary Item
            var headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            
            if sectionIndex == 0 {
                headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(143))
            }
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            if sectionIndex == 3 {
                let footerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(260))
                let footerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerItemSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .top)
                section.boundarySupplementaryItems = [footerItem]
            } else {
                section.boundarySupplementaryItems = [headerItem]
            }
            
            return section
        })
        
        return compositionalLayout
    }
}
