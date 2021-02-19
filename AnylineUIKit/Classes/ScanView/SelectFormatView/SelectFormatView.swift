//
//  SelectFormatView.swift
//  AnylineUIKit
//
//  Created by Mac on 10/22/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class SelectFormatView: UIViewController {

    var presenter: SelectFormatViewPresenterProtocol

    @IBOutlet weak var tableView: UITableView!

    var checkFormat: [CheckFormat] = []
    
    var longSide = ""
    var shortSide = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.Base.lightGray
        title = "Scan Formats"
        setupSelectedFormats()
        presenter.attachView(self)
        setupDismissKeyboardOnTap()
        let nib = UINib(nibName: "SelectFormatTableViewCell", bundle: Bundle(for: SelectFormatTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: SelectFormatTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.separatorInsetReference = .fromCellEdges
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(onOkButton))
    }

    init(presenter: SelectFormatPresenter) {
        let bundle = Bundle(for: SelectFormatView.self)
        self.presenter = presenter
        super.init(nibName: "SelectFormatView", bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SelectFormatView {
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onOkButton() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            self.setFormats()
            self.presenter.okAction()
        }
    }
    
    func setupSelectedFormats() {
        shortSide = String(presenter.getCustomRatioValueShortSide())
        longSide = String(presenter.getCustomRatioValueLongSide())
        
        checkFormat = [CheckFormat(formatOption: .a4, isChecked: presenter.getScanFormat(scanRatio: .a4)), CheckFormat(formatOption: .complimentSlip, isChecked: presenter.getScanFormat(scanRatio: .complimentSlip)), CheckFormat(formatOption: .businessCard, isChecked: presenter.getScanFormat(scanRatio: .businessCard)), CheckFormat(formatOption: .letter, isChecked: presenter.getScanFormat(scanRatio: .letter)), CheckFormat(formatOption: .customRatio, isChecked: presenter.getScanFormat(scanRatio: .customRatio))]
        
        if presenter.getSelectScanFormat() == .all {
            for index in 0...checkFormat.count - 1 {
                checkFormat[index].isChecked = true
            }
        } else if presenter.getSelectScanFormat() == .predefined {
            for index in 0...checkFormat.count - 1 {
                checkFormat[index].isChecked = presenter.getScanFormat(scanRatio: checkFormat[index].formatOption)
            }
        }
    }
    
    func getFormatString(scanRatio: DocumentScanViewEnums.ScanRatio) -> String {
        switch scanRatio {
        case .a4:
            return "A4"
        case .complimentSlip:
            return "Compliment Slip"
        case .businessCard:
            return "Business Card"
        case .letter:
            return "Letter"
        case .customRatio:
            return "Custom Ratio"
        }
    }
    
    func setFormats() {
        var isAllFormats = true
        checkFormat.forEach { (format) in
            if format.isChecked == false {
                isAllFormats = false
            }
        }
        if isAllFormats {
            presenter.setSelectScanFormat(scanFormat: .all)
            presenter.setCustomRatioValueShortAndLongSide(shortSide: shortSide, longSide: longSide)
        } else {
            checkFormat.forEach { (format) in
                presenter.setScanFormat(scanRatio: format.formatOption, scanFormat: format.isChecked)
            }
            presenter.setSelectScanFormat(scanFormat: .predefined)
            for index in 0...checkFormat.count - 1 {
                if checkFormat[index].formatOption == .customRatio && checkFormat[index].isChecked == true {
                    presenter.setCustomRatioValueShortAndLongSide(shortSide: shortSide, longSide: longSide)
                }
            }
        }
    }
}

extension SelectFormatView: SelectFormatViewProtocol {
    func dismissSelectView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectFormatView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkFormat.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFormatTableViewCell.reuseIdentifier, for: indexPath) as? SelectFormatTableViewCell else { return UITableViewCell() }
        var indexOfCustom = 4
        for index in 0...checkFormat.count - 1 {
            if checkFormat[index].formatOption == .customRatio {
                indexOfCustom = index
            }
        }
        if indexPath.row == indexOfCustom {
            cell.name = getFormatString(scanRatio: checkFormat[indexPath.row].formatOption)
            cell.delegate = self
            cell.isCustomCell = true
            cell.layoutMargins = UIEdgeInsets.zero
            cell.isBoxSelected = checkFormat[indexPath.row].isChecked
            cell.shortSideText = String(presenter.getCustomRatioValueShortSide())
            cell.longSideText = String(presenter.getCustomRatioValueLongSide())
        } else {
            cell.name = getFormatString(scanRatio: checkFormat[indexPath.row].formatOption)
            cell.delegate = self
            cell.isCustomCell = false
            cell.layoutMargins = UIEdgeInsets.zero
            cell.isBoxSelected = checkFormat[indexPath.row].isChecked
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
        footerView.backgroundColor = UIColor.Base.lightGray

        let explanationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 32))
        explanationLabel.textColor = UIColor.darkGray
        explanationLabel.numberOfLines = 0
        explanationLabel.font = explanationLabel.font.withSize(12)
        explanationLabel.text = "The selected formats will be detected automatically"
        footerView.addSubview(explanationLabel)
        return footerView
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor.Base.lightGray
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFormatTableViewCell.reuseIdentifier, for: indexPath) as? SelectFormatTableViewCell else { return }
        let isSelected = !checkFormat[indexPath.row].isChecked
        checkFormat[indexPath.row].isChecked = isSelected
        cell.isBoxSelected = isSelected
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SelectFormatView: SelectFormatTableViewCellDelegate {
    func shortSideDidChange(shortSide: String) {
        self.shortSide = shortSide
        presenter.setCustomRatioValueShortAndLongSide(shortSide: shortSide, longSide: longSide)
    }
    
    func longSideDidChange(longSide: String) {
        self.longSide = longSide
        presenter.setCustomRatioValueShortAndLongSide(shortSide: shortSide, longSide: longSide)
    }
}
