//
//  EditBottomSheetCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/01.
//

import UIKit

final class EditBottomSheetCell: UITableViewCell {
    static let cellIdentifier: String = "EditBottomSheetCell"

    @IBOutlet private(set) weak var sheetNameLabel: UILabel!

    func update(by title: String) {
        sheetNameLabel.text = title
    }
}
