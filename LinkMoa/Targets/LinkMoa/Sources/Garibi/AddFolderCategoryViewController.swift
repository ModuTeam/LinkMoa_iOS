//
//  AddFolderCategoryViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/17.
//

import LinkMoaKit
import LinkMoaBottomSheet
import UIKit

import Toast_Swift
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

final class AddFolderCategoryViewController: UIViewController, CustomAlert {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previousButtonView: UIView!
    @IBOutlet private weak var saveButtonView: UIView!
    @IBOutlet private weak var categoryView: UIView!
    @IBOutlet private weak var categorySelectionLabel: UILabel!
    @IBOutlet private weak var categoryPlaceholderLabel: UILabel!
    @IBOutlet private weak var detailCategoryView: UIView!
    @IBOutlet private weak var detailCategorySelectionLabel: UILabel!
    @IBOutlet private weak var detailCategoryPlaceholderLabel: UILabel!
    
    private lazy var input = AddFolderCategoryViewModel.Input(
        fetchCategory: fetchCategory.asSignal(),
        addFolder: addFolder.asSignal(),
        changeCategory: changeCategory.asSignal(),
        changeDetailCategory: changeDetailCategory.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    private let fetchCategory = PublishRelay<Void>()
    private let addFolder = PublishRelay<Void>()
    private let changeCategory = PublishRelay<Int>()
    private let changeDetailCategory = PublishRelay<Int>()
    
    private var addFolderNC: AddFolderNavigationController? {
        return navigationController as? AddFolderNavigationController
    }
    
    // DI
    private let viewModel: AddFolderCategoryViewModel
    private let folderAddSucceedTrigger: PublishRelay<Void>

    init?(
        coder: NSCoder,
        viewModel: AddFolderCategoryViewModel,
        folderAddSucceedTrigger: PublishRelay<Void>
    ) {
        self.viewModel = viewModel
        self.folderAddSucceedTrigger = folderAddSucceedTrigger
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
    }
    
    private func bind() {
        output.errorMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.categoryTitle
            .drive(categorySelectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.detailCategoryTitle
            .drive(detailCategorySelectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isCategoryNoticeHidden
            .drive(categoryPlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isCategoryNoticeHidden
            .map { !$0 }
            .drive(categorySelectionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isDetailCategoryNoticeHidden
            .drive(detailCategoryPlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isDetailCategoryNoticeHidden
            .map { !$0 }
            .drive(detailCategorySelectionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.addSucceed
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.dismiss(animated: true) {
                    self.folderAddSucceedTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareSaveButtonView()
        prepareCategoryView()
        prepareDetailCategoryView()
        preparePreviousButtonView()
    }
    
    private func initializeCategory() {
        categorySelectionLabel.text = ""
        categorySelectionLabel.isHidden = true
        categoryPlaceholderLabel.isHidden = false
        detailCategorySelectionLabel.text = ""
        detailCategorySelectionLabel.isHidden = true
        detailCategoryPlaceholderLabel.isHidden = false
    }
    
    private func initializeDetailCategory() {
        detailCategorySelectionLabel.text = ""
        detailCategorySelectionLabel.isHidden = true
        detailCategoryPlaceholderLabel.isHidden = false
    }
    
    private func prepareSaveButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButtonView.addGestureRecognizer(tapGesture)
        saveButtonView.isUserInteractionEnabled = true
        saveButtonView.layer.masksToBounds = true
        saveButtonView.layer.cornerRadius = 8
    }
    
    private func prepareCategoryView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryViewTapped))
        categoryView.addGestureRecognizer(tapGesture)
        categoryView.isUserInteractionEnabled = true
        categoryView.layer.masksToBounds = true
        categoryView.layer.cornerRadius = 8
        categoryView.layer.borderColor = UIColor.linkMoaFolderSeletionBorderColor.cgColor
        categoryView.layer.borderWidth = 1
    }
    
    private func prepareDetailCategoryView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detailCategoryViewTapped))
        detailCategoryView.addGestureRecognizer(tapGesture)
        detailCategoryView.isUserInteractionEnabled = true
        detailCategoryView.layer.masksToBounds = true
        detailCategoryView.layer.cornerRadius = 8
        detailCategoryView.layer.borderColor = UIColor.linkMoaFolderSeletionBorderColor.cgColor
        detailCategoryView.layer.borderWidth = 1
    }
    
    private func preparePreviousButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(previousButtonViewTapped))
        previousButtonView.addGestureRecognizer(tapGesture)
        previousButtonView.isUserInteractionEnabled = true
        previousButtonView.layer.masksToBounds = true
        previousButtonView.layer.cornerRadius = 8
        previousButtonView.layer.borderWidth = 1
        previousButtonView.layer.borderColor = UIColor.linkMoaDarkBlueColor.cgColor
    }
    
    @objc private func categoryViewTapped() {
        presentCategory(category: .main) { [weak self] _, number in
            guard let self = self else { return }
            self.changeCategory.accept(number)
        }
    }
    
    @objc private func detailCategoryViewTapped() {
        let category = viewModel.category
        guard category != 5 else { return }
        
        presentCategory(category: .sub(number: category)) { [weak self] _, number in
            guard let self = self else { return }
            self.changeDetailCategory.accept(number)
        }
    }
    
    @objc private func saveButtonTapped() {
        addFolder.accept(())
    }
    
    @objc private func previousButtonViewTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
