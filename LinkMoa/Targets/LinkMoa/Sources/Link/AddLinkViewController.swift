//
//  AddLinkViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import UIKit
import LinkMoaKit
import LinkMoaBottomSheet

import Toast_Swift
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

enum EditPresetingStyle {
    case add
    case edit
    case share // Share Extension 에서 접근
    
    var title: String {
        switch self {
        case .add, .share:
            return "링크 추가"
        case .edit:
            return "링크 수정"
        }
    }
}

// MARK: - TargetMembership 으로 상속 지원함 따라서 internal 으로 사용.
class AddLinkViewController: UIViewController, CustomAlert {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var linkTitleTextField: UITextField! // tag 1
    @IBOutlet private weak var linkURLTextField: UITextField! // tag 2
    @IBOutlet private weak var folderSelectionView: UIView!
    @IBOutlet private weak var folderPlaceHolderLabel: UILabel!
    @IBOutlet private weak var folderSelectionLabel: UILabel!
    @IBOutlet private weak var saveButtonView: UIView!
    
    private lazy var input = AddLinkViewModel.Input(
        changeSelectFolder: changeSelectFolder.asSignal(),
        changeLinkName: linkTitleTextField.rx.text.asSignal(onErrorJustReturn: ""),
        changeLinkURL: linkURLTextField.rx.text.asSignal(onErrorJustReturn: ""),
        saveButtonTapped: saveButtonTapped.asSignal(),
        requestURLTitle: requestURLTitle.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    // Trigger
    let requestURLTitle = PublishRelay<String>()
    private let changeSelectFolder = PublishRelay<SelectFolder>()
    private let saveButtonTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    // DI
    private let viewModel: AddLinkViewModel
    private let folderAddSucceedTrigger: PublishRelay<Void>
    
    init?(
        coder: NSCoder,
        viewModel: AddLinkViewModel,
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
        bindUI()
        bind()
    }
    
    // MARK: - 상속시 Override 되는 메서드
    // 유저가 X 버튼으로 VC 를 닫았을 때
    func dismissHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    // 링크 Action 이 성공했을 때
    func completionHander() {
        self.navigationController?.dismiss(animated: true) {
            self.folderAddSucceedTrigger.accept(())
        }
    }
    
    private func bind() {
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.selectFolderName
            .drive(folderSelectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.linkName
            .drive(linkTitleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.linkURL
            .drive(linkURLTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isSelectFolderNoticeHidden
            .drive(folderPlaceHolderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isSelectFolderNoticeHidden
            .map { !$0 }
            .drive(folderSelectionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive { [weak self] (isLoading: Bool) in
                guard let self = self else { return }
                
                if isLoading {
                    self.view.makeToastActivity(.center)
                } else {
                    self.view.hideToastActivity()
                }
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.linkActionSucceed
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.completionHander()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        saveButtonView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(RxTimeInterval.milliseconds(30), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.saveButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareViewGesture()
        prepareSaveButtonView()
        prepareLinkTitleTextField()
        prepareLinkURLTextField()
        prepareFolderSelectionView()
    }
    
    private func prepareFolderSelectionView() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(folderSelectionViewTapped)
        )
        folderSelectionView.addGestureRecognizer(tapGesture)
        folderSelectionView.isUserInteractionEnabled = true
        
        folderSelectionView.layer.masksToBounds = true
        folderSelectionView.layer.cornerRadius = 8
        folderSelectionView.layer.borderColor = UIColor.linkMoaFolderSeletionBorderColor.cgColor
        folderSelectionView.layer.borderWidth = 1
    }
    
    private func prepareSaveButtonView() {
        saveButtonView.layer.masksToBounds = true
        saveButtonView.layer.cornerRadius = 8
    }
    
    private func prepareLinkTitleTextField() {
        linkTitleTextField.delegate = self
        linkTitleTextField.tag = 1
        
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 18, height: linkTitleTextField.frame.height)
        )
        linkTitleTextField.leftView = paddingView
        linkTitleTextField.leftViewMode = .always
        
        linkTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "네이버",
            attributes: [
                .foregroundColor: UIColor.placeholderText,
                .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? .boldSystemFont(ofSize: 16)
            ]
        )
        
        linkTitleTextField.layer.masksToBounds = true
        linkTitleTextField.layer.cornerRadius = 8
    }
    
    private func prepareLinkURLTextField() {
        linkURLTextField.delegate = self
        linkURLTextField.tag = 2
        
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 18, height: linkURLTextField.frame.height)
        )
        linkURLTextField.leftView = paddingView
        linkURLTextField.leftViewMode = .always
        
        linkURLTextField.attributedPlaceholder = NSAttributedString(
            string: "https://www.naver.com",
            attributes: [
                .foregroundColor: UIColor.placeholderText,
                .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        
        linkURLTextField.layer.masksToBounds = true
        linkURLTextField.layer.cornerRadius = 8
    }
    
    private func prepareViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    @objc public func folderSelectionViewTapped() {
        guard let folderSelectVC = FolderSelectViewController.storyboardInstance() else { return }
        
        folderSelectVC.selectHandler = { [weak self] folderName, folderIndex in
            guard let self = self else { return }
            self.changeSelectFolder.accept((name: folderName, index: folderIndex))
        }
        
        navigationController?.pushViewController(folderSelectVC, animated: true)
    }
    
    @IBAction private func dismissButtonTapped() {
        dismissHandler()
    }
}

extension AddLinkViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            textField.resignFirstResponder()
            linkURLTextField.becomeFirstResponder()
        case 2:
            textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
