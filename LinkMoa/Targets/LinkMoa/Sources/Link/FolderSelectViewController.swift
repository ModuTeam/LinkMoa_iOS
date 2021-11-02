//
//  FolderSelectViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/18.
//

import LinkMoaCore
import UIKit

import Toast_Swift

final class FolderSelectViewController: UIViewController {
    @IBOutlet private weak var folderSelectCollectionView: UICollectionView!
    
    var selectHandler: ((String, Int) -> Void)? // 폴더 이름, 폴더 인덱스
    
    private let folderSelectViewModel = FolderSelectViewModel()
    private var folders: [FolderList.Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        preparefolderSelectCollectionView()
        bind()
        
        view.makeToastActivity(ToastPosition.center)
        folderSelectViewModel.inputs.fetchFolders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func bind() {
        folderSelectViewModel.outputs.folders.bind { [weak self] results in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.folders = results
                self.view.hideToastActivity()
                self.folderSelectCollectionView.reloadData()
            }
        }
         
        folderSelectViewModel.outputs.toastMessage.bind { [weak self] message in
            guard let self = self else { return }
            guard !message.isEmpty else { return }
            
            DispatchQueue.main.async {
                self.view.makeToast(message, position: .top)
            }
        }
    }
    
    private func prepareNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func preparefolderSelectCollectionView() {
        folderSelectCollectionView.dataSource = self
        folderSelectCollectionView.delegate = self
        folderSelectCollectionView.contentInset = .init(top: 15, left: 15, bottom: 50, right: 15)
        folderSelectCollectionView.register(
            UINib(nibName: FolderCell.cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: FolderCell.cellIdentifier
        )
    }
}

extension FolderSelectViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return folders.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath
        ) as? FolderCell
        else {
            return UICollectionViewCell()
        }
        
        let folder = folders[indexPath.item]
        folderCell.update(by: folder, isLowImageMode: true)
        return folderCell
    }
}

extension FolderSelectViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let folder = folders[indexPath.item]
        selectHandler?(folder.name, folder.index)
        navigationController?.popViewController(animated: true)
    }
}

extension FolderSelectViewController: UICollectionViewDelegateFlowLayout {
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
