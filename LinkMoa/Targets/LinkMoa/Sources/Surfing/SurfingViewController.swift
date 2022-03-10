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
import SnapKit
import LinkMoaKit

final class SurfingViewController: UIViewController {
    var surfingCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
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
    
    init(viewModel: SurfingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareCollectionView()
        bind()
        topTenTrigger.accept(())
        likedTrigger.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeNC?.addButtonView.isHidden = true
    }
    
    private func setupUI() {
        view.addSubview(surfingCollectionView)
        surfingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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
        surfingCollectionView.backgroundColor = UIColor.init(rgb: 0xf9f9f9)
        surfingCollectionView.register(
            UINib(nibName: FolderCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: FolderCell.identifier
        )
        surfingCollectionView.registerCell(SurfingCategoryCell.self)
        surfingCollectionView.registerHeader(SurfingHeaderView.self)
        surfingCollectionView.registerFooter(SurfingFooterView.self)
        surfingCollectionView.registerHeader(SurfingSearchHeaderView.self)
        
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
        if sender.view?.tag == 0 {
            let type = SurfingFolderType.topTen
            let vc: SurfingFolderViewController = DIContainer.shared.resolve(argument: type)
            vc.homeNC = homeNC
            homeNC?.pushViewController(vc, animated: true)
        } else if sender.view?.tag == 2 {
            let type = SurfingFolderType.liked
            let vc: SurfingFolderViewController = DIContainer.shared.resolve(argument: type)
            vc.homeNC = homeNC
            homeNC?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - DataSource & Layout
extension SurfingViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SurfingSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SurfingSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch dataSource[indexPath] {
            case .topTenItem(let folder):
                let cell = collectionView.dequeueReusableCell(FolderCell.self, for: indexPath)
                cell.update(by: folder)
               
                return cell
            case .categoryItem:
                let cell = collectionView.dequeueReusableCell(SurfingCategoryCell.self, for: indexPath)
                cell.index = indexPath.item
                cell.categoryImageView.image = UIImage(named: "category_\(indexPath.item)")
                return cell
            case .likedItem(let folder):
                let cell = collectionView.dequeueReusableCell(FolderCell.self, for: indexPath)
                
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
                    let headerView = collectionView.dequeueReusableHeaderView(SurfingSearchHeaderView.self, for: indexPath)
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
                    tapGesture.cancelsTouchesInView = false
                    headerView.searchView.addGestureRecognizer(tapGesture)
                    headerView.searchView.isUserInteractionEnabled = true
                    
                    let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.headerViewTapped(_:)))
                    tapGesture2.cancelsTouchesInView = false
                    headerView.titleHeaderView.addGestureRecognizer(tapGesture2)
                    headerView.titleHeaderView.isUserInteractionEnabled = true
                    
                    return headerView
                } else  {
                    let headerView = collectionView.dequeueReusableHeaderView(SurfingHeaderView.self, for: indexPath)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerViewTapped(_:)))
                    headerView.tag = indexPath.section
                    headerView.gestureRecognizers?.forEach {headerView.removeGestureRecognizer($0)}
                    headerView.addGestureRecognizer(tapGesture)
                    headerView.titleLabel.text = headerTitle[indexPath.section]
                    headerView.moreButton.isHidden = headerView.tag == 1 ? true: false
                    
                    return headerView
                }
                
            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableFooterView(SurfingFooterView.self, for: indexPath)
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
