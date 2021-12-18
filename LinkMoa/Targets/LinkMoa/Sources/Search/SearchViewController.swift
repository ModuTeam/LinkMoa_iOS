//
//  SearchViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/26.
//

import LinkMoaBottomSheet
import UIKit

import RxCocoa
import RxGesture
import RxSwift

enum SearchType: Int {
    case surfing
    case my
}

final class SearchViewController: UIViewController, CustomAlert {
    @IBOutlet private weak var topMenuCollectionView: CustomCollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    private let resultCountStrings = BehaviorRelay<[String]>(value: ["폴더(0)개", "링크(0)개"])
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private let disposeBag = DisposeBag()
    
    private weak var searchFolderResultVC: SearchFolderResultViewController?
    private weak var searchLinkResultVC: SearchLinkResultViewController?
    private var pages: [UIViewController] = []
    
    private var selectedTopMenuView = UIView()
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    // DI
    private let type: SearchType

    init?(coder: NSCoder, type: SearchType) {
        self.type = type
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func bindUI() {
        guard let folderVC = searchFolderResultVC, let linkVC = searchLinkResultVC else { return }
        let folder = folderVC.outputs.count.map { "폴더(\($0))개" }
        let link = linkVC.outputs.count.map { "링크(\($0))개" }
        
        Driver.combineLatest(folder, link)
            .map { [$0, $1] }
            .drive(resultCountStrings)
            .disposed(by: disposeBag)
        
        resultCountStrings
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] (_: [String]) in
                guard let self = self else { return }
                self.topMenuCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        topMenuCollectionView.reloadDataWithCompletion { [weak self] in
            guard let self = self else { return }
            self.topMenuCollectionView.selectItem(
                at: self.selectedIndexPath,
                animated: false,
                scrollPosition: .bottom
            )
            self.scrollSelectedTopMenuView(scrollTo: self.selectedIndexPath)
        }
        
        searchTextField.rx.text
            .compactMap { $0 }
            .distinctUntilChanged()
            .throttle(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe { (text: String) in
                folderVC.targetString.accept(text)
                linkVC.targetString.accept(text)
            }
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.searchTextField.text = ""
                self.searchTextField.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        searchLinkResultVC?.scrollTrigger
            .bind { [weak self] bool in
                guard let self = self else { return }
                self.view.endEditing(bool)
            }
            .disposed(by: disposeBag)
        
        searchFolderResultVC?.scrollTrigger
            .bind { [weak self] bool in
                guard let self = self else { return }
                self.view.endEditing(bool)
            }
            .disposed(by: disposeBag)
        
        view.rx
            .tapGesture { [weak self] gestureRecognizer, _ in
                guard let self = self else { return }
                gestureRecognizer.delegate = self
            }
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.searchTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareTopMenuCollectionView()
        preparePageViewController()
        prepareSelectedTopMenuView()
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
    
    private func preparePageViewController() {
        let folderVC: SearchFolderResultViewController = DIContainer.shared.resolve(argument: type)
        let linkVC: SearchLinkResultViewController = DIContainer.shared.resolve(argument: type)
        
        searchFolderResultVC = folderVC
        searchLinkResultVC = linkVC
        pages = [folderVC, linkVC]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([linkVC], direction: .forward, animated: true)
        pageViewController.setViewControllers([folderVC], direction: .forward, animated: true)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        containerView.addSubview(pageViewController.view)
        constraintPageViewControllerView()
    }
    
    private func constraintPageViewControllerView() {
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
    
    private func prepareSelectedTopMenuView() {
        let label = UILabel()
        label.text = resultCountStrings.value.first
        label.font = UIFont(name: "NotoSansKR-Medium", size: 19)
        let width = label.intrinsicContentSize.width

        selectedTopMenuView.frame = CGRect(x: 0, y: 46, width: width, height: 3)
        selectedTopMenuView.backgroundColor = .linkMoaGrayColor
        topMenuCollectionView.addSubview(selectedTopMenuView)
    }
    
    private func prepareTopMenuCollectionView() {
        topMenuCollectionView.dataSource = self
        topMenuCollectionView.delegate = self
        topMenuCollectionView.register(
            UINib(nibName: TopMenuCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: TopMenuCell.identifier
        )
        topMenuCollectionView.selectItem(
            at: selectedIndexPath,
            animated: false,
            scrollPosition: .bottom
        )
    }
    
    private func scrollSelectedTopMenuView(scrollTo indexPath: IndexPath) {
        UIView.animate(withDuration: 0.15) {
            if let cell = self.topMenuCollectionView.cellForItem(at: indexPath) as? TopMenuCell {
                self.selectedTopMenuView.frame.size.width = cell.frame.width
                self.selectedTopMenuView.frame.origin.x = cell.frame.origin.x
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return resultCountStrings.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopMenuCell.identifier,
            for: indexPath
        ) as? TopMenuCell
        else {
            fatalError()
        }
        cell.titleLabel.text = resultCountStrings.value[indexPath.item]
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        scrollSelectedTopMenuView(scrollTo: indexPath)
        setPageController(setToIndexPath: indexPath)
        searchTextField.resignFirstResponder()
    }
}

extension SearchViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        return index == 1 ? pages[index - 1] : nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        return index == 0 ? pages[index + 1] : nil
    }
}

extension SearchViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVC) else { return }
        
        let scrollIndexPath = IndexPath(item: index, section: 0)
        topMenuCollectionView.selectItem(at: scrollIndexPath, animated: true, scrollPosition: .left)
        collectionView(topMenuCollectionView, didSelectItemAt: scrollIndexPath)
        searchTextField.resignFirstResponder()
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard let view = touch.view else { return false }
        return !view.isDescendant(of: containerView)
            && !view.isDescendant(of: topMenuCollectionView)
    }
}
