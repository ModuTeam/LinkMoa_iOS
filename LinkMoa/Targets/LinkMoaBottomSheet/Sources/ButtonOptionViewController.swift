//
//  EditBottomController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import LinkMoaKit
import UIKit

final class ButtonOptionViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var editTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var editTableView: UITableView!

    var editTitle: String?
    var actions: [String] = []
    var handlers: [((Any?) -> Void)?] = []
    var blurVC: BackgroundBlur?
    var isIncludeRemoveButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAndFadeIn()
        prepareTitleLabel()
        prepareBackgroundView()
        prepareEditTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareViewRoundCorner()
    }
    
    private func prepareTitleLabel() {
        if let editTitle = editTitle {
            titleLabel.text = editTitle
        }
    }
    
    private func prepareBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgrounViewTapped))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func prepareViewRoundCorner() {
        sheetView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        sheetView.clipsToBounds = true
    }
    
    private func prepareEditTableView() {
        editTableViewHeightConstraint.constant = CGFloat(actions.count * 58)
        editTableView.register(
            UINib(nibName: EditBottomSheetCell.cellIdentifier, bundle: Bundle.module),
            forCellReuseIdentifier: EditBottomSheetCell.cellIdentifier
        )
        editTableView.dataSource = self
        editTableView.delegate = self
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backgrounViewTapped() {
        dismissAndFadeOut()
    }

    @IBAction func dismissButtonTapped() {
        dismissAndFadeOut()
    }
}

extension ButtonOptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sheetCell = tableView.dequeueReusableCell(
                withIdentifier: EditBottomSheetCell.cellIdentifier, for: indexPath
        ) as? EditBottomSheetCell
        else {
            return UITableViewCell()
        }
        
        if indexPath.row == actions.count - 1, isIncludeRemoveButton {
            sheetCell.sheetNameLabel.textColor = UIColor.linkMoaDarkRedColor
        }
        
        sheetCell.update(by: actions[indexPath.row])
        return sheetCell
    }
}

extension ButtonOptionViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let handler = handlers[indexPath.row] else { return }
        
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true) {
            handler(nil)
        }
    }
}
