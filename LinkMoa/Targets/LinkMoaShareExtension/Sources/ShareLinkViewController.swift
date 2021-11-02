//
//  ShareLinkViewController.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/08/25.
//

import LinkMoaCore
import MobileCoreServices
import Social
import UIKit

final class ShareLinkViewController: AddLinkViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = item.attachments?.first else { return }
        
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (url, _) in
                if let shareURL = url as? NSURL, let absoluteString = shareURL.absoluteString {
                    self.requestURLTitle.accept(absoluteString)
                }
            }
        }
    }
    
    override func dismissHandler() {
        hideExtensionWithCompletionHandler { [weak self] in
            guard let self = self else { return }
            guard let extensionContext = self.extensionContext else { return }
            extensionContext.cancelRequest(withError: NSError())
        }
    }
    
    override func completionHander() {
        self.presentImageAlertView(type: .saveFolder) {
            self.hideExtensionWithCompletionHandler {
                guard let extensionContext = self.extensionContext else { return }
                extensionContext.completeRequest(returningItems: nil, completionHandler: nil)
            }
        }
    }
    
    private func hideExtensionWithCompletionHandler(completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        }, completion: { _ in
            completionHandler()
        })
    }
}
