//
//  CustomAlert.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/27.
//

import LinkMoaCore
import UIKit

public enum Reconfirm {
    case reportFolder
    case deleteAccount
    case logout
}

public enum ImageAlert {
    case saveFolder
    case editNickname
    case reportFolder
    case removeFolder
}

public enum TextRequest {
    case removeFolder
    case editNickname
}

public enum Category {
    case main
    case sub(number: Int)
}

public protocol CustomAlert: BackgroundBlur {}

extension CustomAlert {
    var blurVC: BackgroundBlur {
        guard let nc = navigationController as? BackgroundBlur else { return self }
        return nc
    }
    
    public func presentImageAlertView(
        type: ImageAlert = .saveFolder,
        completion: (() -> Void)? = nil
    ) {
        guard let imageAlertVC = ImageAlertViewController.storyboardInstance() else { return }
        imageAlertVC.modalPresentationStyle = .overCurrentContext
        imageAlertVC.modalTransitionStyle = .coverVertical
        imageAlertVC.blurVC = blurVC
        imageAlertVC.succeed = type
        imageAlertVC.completion = completion
        present(imageAlertVC, animated: true)
    }
    
    public func presentReconfirmView(
        type: Reconfirm,
        completion: (() -> Void)? = nil
    ) {
        guard let reconfirmVC = ReconfirmViewController.storyboardInstance() else { return }
        reconfirmVC.blurVC = blurVC
        reconfirmVC.modalPresentationStyle = .overCurrentContext
        reconfirmVC.modalTransitionStyle = .coverVertical
        reconfirmVC.completion = completion
        reconfirmVC.reconfirm = type
        present(reconfirmVC, animated: true)
    }
    
    public func presentTextRequestView(
        type: TextRequest = .removeFolder,
        name: String,
        completion: ((Any?) -> Void)? = nil
    ) {
        guard let textRequestVC = TextRequestViewController.storyboardInstance() else { return }
        textRequestVC.modalPresentationStyle = .overCurrentContext
        textRequestVC.modalTransitionStyle = .coverVertical
        textRequestVC.blurVC = blurVC
        textRequestVC.name = name
        textRequestVC.removeRequest = type
        textRequestVC.completion = completion
        present(textRequestVC, animated: true)
    }
    
    public func presentOptionView(
        title: String,
        optionTitles: [String],
        options: [((Any?) -> Void)],
        isIncludeRemoveButton: Bool = false
    ) {
        guard let buttonOptionVC = ButtonOptionViewController.storyboardInstance(),
              optionTitles.count == options.count
        else {
            fatalError()
        }
        
        buttonOptionVC.blurVC = blurVC
        buttonOptionVC.modalPresentationStyle = .overCurrentContext
        buttonOptionVC.modalTransitionStyle = .coverVertical
        buttonOptionVC.editTitle = title
        buttonOptionVC.actions = optionTitles
        buttonOptionVC.handlers = options
        buttonOptionVC.isIncludeRemoveButton = isIncludeRemoveButton
        present(buttonOptionVC, animated: true)
    }
    
    public func presentCategory(
        category: Category = .main,
        selection: ((String, Int) -> Void)? = nil
    ) {
        guard let selectCategoryBottomVC = SelectCategoryViewController.storyboardInstance()
        else {
            return
        }
        var categories: [Dictionary<Int, String>.Element]? = []

        switch category {
        case .main:
            categories = Constant.categoryData.sorted(by: { $0.0 < $1.0 })
        case .sub(let number):
            categories = Constant.detailCategoryData[number]?.sorted(by: { $0.0 < $1.0 })
        }

        guard let categories = categories else { return }
        selectCategoryBottomVC.blurVC = blurVC
        selectCategoryBottomVC.categoryNumbers = categories.map { $0.key }
        selectCategoryBottomVC.categories = categories.map { $0.value }
        selectCategoryBottomVC.modalPresentationStyle = .overCurrentContext
        selectCategoryBottomVC.modalTransitionStyle = .coverVertical
        selectCategoryBottomVC.completion = nil
        selectCategoryBottomVC.selection = selection
        present(selectCategoryBottomVC, animated: true)
    }
}
