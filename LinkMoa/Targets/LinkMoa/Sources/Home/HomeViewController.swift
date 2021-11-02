//
//  HomeViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/31.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var topMenuCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    private let topMenuSectionNames = ["나의 링크달", "서핑하기"]
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    private var pages: [UIViewController] = []
    private var selectedTopMenuView = UIView()
    
    // Dependency Injection
    private let folderVC: FolderViewController
    private let surfingVC: SurfingViewController
    
    init?(coder: NSCoder, folderVC: FolderViewController, surfingVC: SurfingViewController) {
        self.folderVC = folderVC
        self.surfingVC = surfingVC
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureUI() {
        preparePageViewController()
        prepareTopMenuCollectionView()
        prepareSelectedTopMenuView()
    }
    
    private func preparePageViewController() {
        folderVC.homeNC = navigationController as? HomeNavigationController
        surfingVC.homeNC = navigationController as? HomeNavigationController
        
        pages = [folderVC, surfingVC]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([surfingVC], direction: .forward, animated: true)
        pageViewController.setViewControllers([folderVC], direction: .forward, animated: true)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        containerView.addSubview(pageViewController.view)
        constaintPageViewControllerView()
    }
    
    private func prepareTopMenuCollectionView() {
        topMenuCollectionView.dataSource = self
        topMenuCollectionView.delegate = self
        topMenuCollectionView.register(
            UINib(nibName: TopMenuCell.cellIdentifier, bundle: Bundle.module),
            forCellWithReuseIdentifier: TopMenuCell.cellIdentifier
        )
        topMenuCollectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: .centeredVertically
        )
    }
    
    private func prepareSelectedTopMenuView() {
        selectedTopMenuView.frame = CGRect(x: 18, y: 47, width: 97.6, height: 3)
        selectedTopMenuView.backgroundColor = .linkMoaBlackColor
        topMenuCollectionView.addSubview(selectedTopMenuView)
    }
    
    private func scrollSelectedTabView(scrollToIndexPath indexPath: IndexPath) {
        UIView.animate(withDuration: 0.15) {
            if let destinationCell = self.topMenuCollectionView.cellForItem(at: indexPath) {
                self.selectedTopMenuView.frame.size.width = destinationCell.frame.width
                self.selectedTopMenuView.frame.origin.x = destinationCell.frame.origin.x
            }
        }
    }
    
    private func setPageController(setToIndexPath indexPath: IndexPath) {
        let isFirstItem = indexPath.item == 0
        let direction: UIPageViewController.NavigationDirection = isFirstItem ? .reverse : .forward
        
        pageViewController.setViewControllers(
            [pages[indexPath.item]],
            direction: direction,
            animated: true
        )
    }
    
    private func constaintPageViewControllerView() {
        let pageContentView: UIView = pageViewController.view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        pageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pageContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pageContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @IBAction private func myPageButtonTapped() {
        let myPageNC: MyPageNavigationController = DIContainer.shared.resolve()
        myPageNC.modalTransitionStyle = .crossDissolve
        myPageNC.modalPresentationStyle = .fullScreen
        present(myPageNC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return topMenuSectionNames.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let titleCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopMenuCell.cellIdentifier,
                for: indexPath
        ) as? TopMenuCell
        else {
            return UICollectionViewCell()
        }
        
        titleCell.titleLabel.text = topMenuSectionNames[indexPath.item]
        return titleCell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollSelectedTabView(scrollToIndexPath: indexPath)
        setPageController(setToIndexPath: indexPath)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        guard index == 1 else { return nil }
        
        let prevIndex = index - 1
        let nc = navigationController as? HomeNavigationController
        nc?.addButtonView.isHidden = true
        return pages[prevIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        guard index == 0 else { return nil }
        
        let nextIndex = index + 1
        let nc = navigationController as? HomeNavigationController
        nc?.addButtonView.isHidden = false
        return pages[nextIndex]
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVC) else { return }
        
        let scrollIndexPath = IndexPath(item: index, section: 0)
        topMenuCollectionView.selectItem(
            at: scrollIndexPath,
            animated: true,
            scrollPosition: .centeredVertically
        )
        collectionView(topMenuCollectionView, didSelectItemAt: scrollIndexPath)
    }
}
