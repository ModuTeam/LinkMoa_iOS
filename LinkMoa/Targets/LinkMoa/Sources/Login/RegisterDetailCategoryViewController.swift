//
//  RegisterDetailCategoryViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/19.
//

import UIKit
import LinkMoaKit
import LinkMoaBottomSheet

import RxCocoa
import RxGesture
import RxSwift

final class RegisterDetailCategoryViewController: UIViewController {
    @IBOutlet private weak var detailCategoryCollectionView: UICollectionView!
    @IBOutlet private weak var nextButtonView: LinkMoaButtonView!
    @IBOutlet private weak var nextButtonLabel: LinkMoaButtonLabel!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var currentProgressView: UIView!
    
    private lazy var input = RegisterDetailCategoryViewModel.Input(
        selectDetailCategory: selectDetailCategory.asSignal(),
        nextButtonTapped: nextButtonTapped.asSignal()
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    private let selectDetailCategory = PublishRelay<Int>()
    private let nextButtonTapped = PublishRelay<Void>()

    private let disposeBag = DisposeBag()
    
    // Dependency Injection
    private let viewModel: RegisterDetailCategoryViewModel
    
    init?(coder: NSCoder, viewModel: RegisterDetailCategoryViewModel) {
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
    
    private func bind() {
        output.nextProgress
            .emit { [weak self] (_: RegisterFlow) in
                guard let self = self else { return }
                self.moveHomeVC()
            }
            .disposed(by: disposeBag)
        
        output.categories
            .drive(detailCategoryCollectionView.rx.items) {
                collectionView, index, detailCategory in
                let indexPath = IndexPath(item: index, section: 0)
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.cellIdentifier,
                    for: indexPath
                ) as? CategoryCell
                else {
                    fatalError()
                }
                
                cell.update(by: detailCategory)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.isEnableNextButton
            .drive(nextButtonView)
            .disposed(by: disposeBag)
        
        output.isEnableNextButton
            .drive(nextButtonLabel)
            .disposed(by: disposeBag)
        
        output.toastMessage
            .emit { [weak self] (message: String) in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        nextButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: nextButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareProgressViews()
        prepareNextButtonView()
        prepareCategoryCollectionView()
    }
    
    private func prepareNextButtonView() {
        nextButtonView.isUserInteractionEnabled = false
        nextButtonView.layer.masksToBounds = true
        nextButtonView.layer.cornerRadius = 8
    }
    
    private func prepareProgressViews() {
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2
        currentProgressView.layer.masksToBounds = true
        currentProgressView.layer.cornerRadius = 2
    }
    
    private func prepareCategoryCollectionView() {
        detailCategoryCollectionView.register(
            UINib(nibName: CategoryCell.cellIdentifier, bundle: Bundle.module),
            forCellWithReuseIdentifier: CategoryCell.cellIdentifier
        )
        detailCategoryCollectionView.delegate = self
    }
}

// MARK:- Present
extension RegisterDetailCategoryViewController {
    private func moveHomeVC() {
        let window: UIWindow = DIContainer.shared.resolve()
        let homeNC: HomeNavigationController = DIContainer.shared.resolve()
        
        window.rootViewController = homeNC
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}

extension RegisterDetailCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - (19 * 2) - 13) / 2
        let height: CGFloat = 54
        return CGSize(width: width, height: height)
    }
}

extension RegisterDetailCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cells = collectionView.visibleCells as? [CategoryCell] else { return }
        
        for cell in cells {
            cell.isSelectedCell = false
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        cell.isSelectedCell = true
        
        if let index = cell.detailCategory?.index {
            selectDetailCategory.accept(index)
        }
    }
}
