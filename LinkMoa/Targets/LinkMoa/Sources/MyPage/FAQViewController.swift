//
//  FAQViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/19.
//

import LinkMoaCore
import UIKit

final class FAQViewController: UIViewController {
    @IBOutlet private weak var faqTableView: UITableView!

    private var hiddenSections = Set<Int>()
    private var sectionIsSelected: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    private func prepareTableView() {
        faqTableView.delegate = self
        faqTableView.dataSource = self
        
        faqTableView.register(
            UINib(nibName: QuestionHeaderView.identifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: QuestionHeaderView.identifier
        )
        faqTableView.rowHeight = UITableView.automaticDimension
        
        for i in 0..<Constant.faqData.count {
            self.hiddenSections.insert(i)
            self.sectionIsSelected.append(false)
        }
    }
    
    @IBAction private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

extension FAQViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.faqData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hiddenSections.contains(section) ? 0 : 1
    }
}

extension FAQViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = Constant.faqData[indexPath.section].answer
        cell.backgroundColor = .init(rgb: 0xf8f8f8)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: QuestionHeaderView.identifier
        ) as? QuestionHeaderView
        else {
            fatalError()
        }
        headerView.questionLabel.text = Constant.faqData[section].question
        headerView.sectionButton.tag = section
        
        let isSelected = sectionIsSelected[section]
        let arrowImage = isSelected ? LinkMoaAsset.topArrow.image : LinkMoaAsset.bottomArrow.image
        headerView.arrowImageView.image = arrowImage

        headerView.sectionButton.addTarget(
            self,
            action: #selector(self.hideSection(sender:)),
            for: .touchUpInside
        )
        return headerView
    }
    
    @objc private func hideSection(sender: UIButton) {
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            indexPaths.append(IndexPath(row: 0, section: section))
            return indexPaths
        }
        
        let section = sender.tag
        sectionIsSelected[section] = !sectionIsSelected[section]

        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.faqTableView.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.faqTableView.deleteRows(at: indexPathsForSection(), with: .fade)
        }
        
        if let header = faqTableView.headerView(forSection: section) as? QuestionHeaderView {
            let isSelected = sectionIsSelected[section]
            let arrowImage = isSelected ? LinkMoaAsset.topArrow.image : LinkMoaAsset.bottomArrow.image
            header.arrowImageView.image = arrowImage
        }
    }
}
