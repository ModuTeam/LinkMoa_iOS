//
//  MyPageCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import LinkMoaKit
import UIKit

import RxSwift

final class MyPageCell: UITableViewCell, IdentifierType {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var browserSwitch: UISwitch!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inititalize()
    }
    
    override func prepareForReuse() {
        inititalize()
    }
    
    private func inititalize() {
        titleLabel.text = ""
        subTitleLabel.text = ""
        subTitleLabel.isHidden = true
        browserSwitch.isHidden = true
        disposeBag = DisposeBag()
    }
}
