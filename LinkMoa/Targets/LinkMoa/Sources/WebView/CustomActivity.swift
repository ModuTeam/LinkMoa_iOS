//
//  CustomActivity.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/22.
//

import UIKit

protocol CustomActivityDelegate: NSObjectProtocol {
    func performActionCompletion(actvity: CustomActivity)
}

final class CustomActivity: UIActivity {

    weak var delegate: CustomActivityDelegate?

    override class var activityCategory: UIActivity.Category {
        return .action // default
    }

    override var activityType: UIActivity.ActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivity.ActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }

    override var activityTitle: String? {
        return "사파리에서 열기"
    }

    override var activityImage: UIImage? {
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        return UIImage(systemName: "safari", withConfiguration: largeConfig)

    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {}

    override func perform() {
        self.delegate?.performActionCompletion(actvity: self)
        activityDidFinish(true)
    }
}
