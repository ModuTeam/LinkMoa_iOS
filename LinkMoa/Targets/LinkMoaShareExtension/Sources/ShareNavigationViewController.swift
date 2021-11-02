//
//  ShareNavigationViewController.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/02/26.
//

import LinkMoaBottomSheet
import LinkMoaCore
import LinkPresentation
import UIKit

import Moya
import RxRelay
import RxSwift

final class ShareNavigationViewController: UINavigationController, BackgroundBlur {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        prepareNavigationBar()
        
        let dependency = AddLinkViewModel.Dependency(
            currentFolder: nil,
            destinationFolder: nil,
            link: .init(),
            actionType: .add
        )
        
        let viewModel = AddLinkViewModel(
            networkProvider: MoyaProvider<LinkMoaAPI>(),
            linkService: LinkPresentaionService(
                urlSession: URLSession.shared,
                metadataProvider: LPMetadataProvider()
            ),
            dependency: dependency
        )
        
        let sb = UIStoryboard(name: ShareLinkViewController.storyboardName(), bundle: Bundle.module)
        
        let vc = sb.instantiateInitialViewController { coder in
            ShareLinkViewController(
                coder: coder,
                viewModel: viewModel,
                folderAddSucceedTrigger: PublishRelay<Void>()
            )
        }
        
        if let vc = vc {
            pushViewController(vc, animated: false)
        }
    }
    
    func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        
        let edgeInset = UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0)
        let image = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(edgeInset)
        
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }
}

extension ShareNavigationViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
