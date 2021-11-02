//
//  SearchFolderDetailViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/10/09.
//  Copyright © 2021 com.makeus.linkMoa. All rights reserved.
//

import UIKit

final class SearchFolderDetailViewController: FolderDetailViewController {
    override func folderEditButtonTapped() {
        let title = "더보기"
        let optionTitles = ["URL 공유하기"]
        let options = [{ [weak self] (_: Any?) in
            guard let self = self else { return }
            
            let shareItem = self.viewModel.shareItem
            let activityController = UIActivityViewController(
                activityItems: [shareItem],
                applicationActivities: nil
            )
            
            activityController.excludedActivityTypes = [
                .saveToCameraRoll,
                .print,
                .assignToContact,
                .addToReadingList
            ]
            
            self.present(activityController, animated: true)
        }]
        
        presentOptionView(
            title: title,
            optionTitles: optionTitles,
            options: options
        )
    }
}
