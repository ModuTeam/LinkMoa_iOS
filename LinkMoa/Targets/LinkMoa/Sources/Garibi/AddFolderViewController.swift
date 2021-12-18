//
//  BookmarkAddFolderViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/04.
//

import UIKit

import Toast_Swift
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

enum AddFolderType {
    case add
    case edit

    var title: String {
        switch self {
        case .add:
            return "폴더 추가"
        case .edit:
            return "폴더 수정"
        }
    }
}

enum FolderShareType {
    case `public`
    case `private`
}

final class AddFolderViewController: UIViewController {
    @IBOutlet private weak var folderNameTextField: UITextField! // tag 1
    @IBOutlet private weak var tagNameTextField: UITextField! // tag 2
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var publicOptionButtonView: LinkMoaButtonView!
    @IBOutlet private weak var publicTitleLabel: LinkMoaButtonLabel!
    @IBOutlet private weak var privateOptionButtonView: LinkMoaButtonView!
    @IBOutlet private weak var privateTitleLabel: LinkMoaButtonLabel!
    @IBOutlet private weak var nextButtonView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tagNotificationView: UIView!
    
    private lazy var input = AddFolderViewModel.Input(
        fetchFolder: fetchFolder.asSignal(),
        changeShareType: shareTypeTrigger.asSignal(),
        changeFolderName: changeFolderName.asSignal(),
        addTag: addTag.asSignal(),
        removeTag: removeTag.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    // 트리거
    private let fetchFolder = PublishRelay<Void>()
    private let shareTypeTrigger = PublishRelay<FolderShareType>()
    private let changeFolderName = PublishRelay<String>()
    private let addTag = PublishRelay<String>()
    private let removeTag = PublishRelay<String>()
    
    // 의존성 주입
    private let viewModel: AddFolderViewModel
    private let folderAddSucceedTrigger: PublishRelay<Void>
    
    init?(
        coder: NSCoder,
        viewModel: AddFolderViewModel,
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
        fetchFolder.accept(())
    }
    
    private func bind() {
        output.errorMessage
            .emit { [weak self] message in
                guard let self = self else { return }
                self.view.makeToast(message, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.sections
            .drive(tagCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.folderName
            .drive(folderNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isShowTagNotification
            .map { !$0 }
            .drive(tagNotificationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.shareType
            .map { $0 == .private }
            .drive(privateOptionButtonView)
            .disposed(by: disposeBag)
        
        output.shareType
            .map { $0 == .private }
            .drive(privateTitleLabel)
            .disposed(by: disposeBag)
        
        output.shareType
            .map { $0 == .public }
            .drive(publicOptionButtonView)
            .disposed(by: disposeBag)
        
        output.shareType
            .map { $0 == .public }
            .drive(publicTitleLabel)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        tagCollectionView.rx
            .modelSelected(String.self)
            .subscribe { [weak self] (tag: String) in
                guard let self = self else { return }
                self.removeTag.accept(tag)
            }
            .disposed(by: disposeBag)
        
        publicOptionButtonView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.shareTypeTrigger.accept(.public)
            }
            .disposed(by: disposeBag)
        
        privateOptionButtonView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.shareTypeTrigger.accept(.private)
            }
            .disposed(by: disposeBag)
        
        nextButtonView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.nextButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareNextButtonView()
        prepareOptionButtons()
        prepareTagCollectionView()
        prepareTagNameTextField()
        prepareFolderNameTextField()
        prepareTagNotificationView()
        prepareViewGesture()
    }
    
    private func prepareTagNotificationView() {
        tagNotificationView.layer.masksToBounds = true
        tagNotificationView.layer.cornerRadius = 16
    }
    
    private func prepareNextButtonView() {
        nextButtonView.layer.masksToBounds = true
        nextButtonView.layer.cornerRadius = 8
    }
    
    private func prepareOptionButtons() {
        publicOptionButtonView.layer.masksToBounds = true
        publicOptionButtonView.layer.cornerRadius = 8
        privateOptionButtonView.layer.masksToBounds = true
        privateOptionButtonView.layer.cornerRadius = 8
    }
    
    private func prepareTagCollectionView() {
        let tagNib = UINib(nibName: TagCell.identifier, bundle: Bundle.module)
        tagCollectionView.register(tagNib, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    private func prepareFolderNameTextField() {
        let frame = CGRect(x: 0, y: 0, width: 18, height: folderNameTextField.frame.height)
        let paddingView = UIView(frame: frame)
        let font: UIFont = .init(name: "NotoSansCJKkr-Regular", size: 16) ?? .systemFont(ofSize: 16)
    
        folderNameTextField.delegate = self
        folderNameTextField.leftView = paddingView
        folderNameTextField.leftViewMode = .always
        folderNameTextField.attributedPlaceholder = NSAttributedString(
            string: "UXUI 스터디",
            attributes: [.foregroundColor: UIColor.linkMoaPlaceholderColor, .font: font]
        )
        folderNameTextField.layer.masksToBounds = true
        folderNameTextField.layer.cornerRadius = 8
    }
    
    private func prepareTagNameTextField() {
        let frame = CGRect(x: 0, y: 0, width: 18, height: folderNameTextField.frame.height)
        let paddingView = UIView(frame: frame)
        let font: UIFont = .init(name: "NotoSansCJKkr-Regular", size: 16) ?? .systemFont(ofSize: 16)
        
        tagNameTextField.delegate = self
        tagNameTextField.leftView = paddingView
        tagNameTextField.leftViewMode = .always
        tagNameTextField.attributedPlaceholder = NSAttributedString(
            string: "해시 태그 입력",
            attributes: [.foregroundColor: UIColor.linkMoaPlaceholderColor, .font: font]
        )
        tagNameTextField.layer.masksToBounds = true
        tagNameTextField.layer.cornerRadius = 8
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
    
    @objc private func nextButtonTapped() {
        guard let name = folderNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            return
        }
        guard !name.isEmpty else {
            view.makeToast("폴더 이름을 입력해주세요.", position: .top)
            return
        }
        changeFolderName.accept(name)
        
        let nameLimit = 18
        guard name.count <= nameLimit else {
            view.makeToast("폴더 이름은 \(nameLimit)자를 넘길 수 없습니다.", position: .top)
            return
        }
        
        let vc: AddFolderCategoryViewController = DIContainer.shared.resolve(
            arguments: viewModel.addFolderDataManager, viewModel.addFolderType, folderAddSucceedTrigger
        )

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

extension AddFolderViewController {
    func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<TagSectionModel> {
        return RxCollectionViewSectionedAnimatedDataSource(configureCell: {
            dataSource, collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCell.identifier,
                for: indexPath
            ) as? TagCell
            else {
                fatalError()
            }
            
            let tag = dataSource[indexPath]
            cell.update(by: tag)
            return cell
        })
    }
}

extension AddFolderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            textField.resignFirstResponder()
            tagNameTextField.becomeFirstResponder()
        case 2:
            addTag.accept(textField.text ?? "")
            textField.text = ""
        default:
            break
        }
        
        return true
    }
}
