//
//  FolderSelectViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/10.
//

import Foundation
import LinkMoaCore
import LinkMoaKit

protocol FolderSelectViewModelOutputs {
    var folders: LMObservable<[FolderList.Result]> { get }
    var toastMessage: LMObservable<String> { get }
}

protocol FolderSelectViewModelInputs {
    func fetchFolders()
}

protocol FolderSelectViewModelType {
    var inputs: FolderSelectViewModelInputs { get }
    var outputs: FolderSelectViewModelOutputs { get }
}

final class FolderSelectViewModel: FolderSelectViewModelOutputs, FolderSelectViewModelInputs, FolderSelectViewModelType {
    private let networkProvider = LinkMoaAPI.provider

    var folders: LMObservable<[FolderList.Result]> = LMObservable([])
    var toastMessage = LMObservable<String>("")
    
    var inputs: FolderSelectViewModelInputs { return self }
    var outputs: FolderSelectViewModelOutputs { return self }
    
    func fetchFolders() {
        networkProvider.request(.myFolderList(index: 0, filter: 1)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if let folders = try? JSONDecoder().decode(FolderList.self, from: response.data).result {
                    self.folders.value = folders
                }
            case .failure(let error):
                self.toastMessage.value = error.localizedDescription
            }
        }
    }
}
