//
//  SelectSizeView.swift
//  AnylineUIKit
//
//  Created by Mac on 10/21/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class SelectSizeView: UIViewController {

    var presenter: SelectSizeViewPresenterProtocol

    @IBOutlet weak var tableView: UITableView!
    
    var checkSize: [CheckSize] = []
    
    var customSizeValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.Base.lightGray
        presenter.attachView(self)
        setupDismissKeyboardOnTap()
        setupSizes()
        
        title = "Picture Size"
        
        let nibSelectSize = UINib(nibName: "SelectSizeTableViewCell", bundle: Bundle(for: SelectSizeTableViewCell.self))
        let nibSwitchCustom = UINib(nibName: "SwitchCustomSizeTableViewCell", bundle: Bundle(for: SwitchCustomSizeTableViewCell.self))
        let nibCustomSize = UINib(nibName: "CustomSizeTableViewCell", bundle: Bundle(for: CustomSizeTableViewCell.self))
        tableView.register(nibSelectSize, forCellReuseIdentifier: SelectSizeTableViewCell.reuseIdentifier)
        tableView.register(nibSwitchCustom, forCellReuseIdentifier: SwitchCustomSizeTableViewCell.reuseIdentifier)
        tableView.register(nibCustomSize, forCellReuseIdentifier: CustomSizeTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.separatorInsetReference = .fromCellEdges
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(onOkButton))
    }
    
    init(presenter: SelectSizeViewPresenterProtocol) {
        let bundle = Bundle(for: SelectSizeView.self)
        self.presenter = presenter
        super.init(nibName: "SelectSizeView", bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SelectSizeView {
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onOkButton() {
        setSizeTypeAndCustom()
        presenter.okButtonAction()
        self.dismiss(animated: true, completion: nil)
    }
    
    enum Sections: Int, CaseIterable {
        case sizes = 0
        case custom
    }
    
    func getStringSize(size: DocumentScanViewEnums.ReduceSizeOption) -> String {
        switch size {
        case .noReduceSize:
            return "Do not reduce size"
        case .small:
            return "Small (max 300 pixels)"
        case .medium:
            return "Medium (max 600 pixels)"
        case .large:
            return "Large (max 1200 pixels)"
        case .custom:
            return "Custom"
        }
    }
    
    func setupSizes() {
        customSizeValue = presenter.getReducePictureSizeMaxSizeCustom()
        checkSize = [CheckSize(sizeOption: .noReduceSize, isChecked: false), CheckSize(sizeOption: .small, isChecked: false), CheckSize(sizeOption: .medium, isChecked: false), CheckSize(sizeOption: .large, isChecked: false), CheckSize(sizeOption: .custom, isChecked: false)]

        for index in 0...checkSize.count - 1 {
            let currentOption = presenter.getReducePictureSizeOption()
            if currentOption == checkSize[index].sizeOption {
                checkSize[index].isChecked = true
            } else {
                checkSize[index].isChecked = false
            }
        }
    }

    func updateSizes(newOption: DocumentScanViewEnums.ReduceSizeOption?) {
        guard let newOption = newOption else {
            for index in 0...checkSize.count - 1 {
                checkSize[index].isChecked = false
            }
            tableView.reloadData()
            return
        }
        for index in 0...checkSize.count - 1  {
            checkSize[index].isChecked = false
        }
        for index in 0...checkSize.count - 1 {
            if checkSize[index].sizeOption == newOption {
                checkSize[index].isChecked = true
            }
        }
        tableView.reloadData()
    }
    
    func setSizeTypeAndCustom() {
        for index in 0...checkSize.count - 1 {
            if checkSize[index].sizeOption == .custom && checkSize[index].isChecked {
                presenter.setReducePictureSizeMaxSizeCustom(size: customSizeValue)
            }
        }

        for index in 0...checkSize.count - 1 {
            if checkSize[index].isChecked {
                presenter.setReducePictureSizeOption(option: checkSize[index].sizeOption)
                return
            } else {
                presenter.setReducePictureSizeOption(option: .noReduceSize)
            }
        }
    }
}

extension SelectSizeView: SelectSizeViewProtocol {
}

extension SelectSizeView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Sections.sizes.rawValue {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
            footerView.backgroundColor = UIColor.Base.lightGray
            let explanationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 32))
            explanationLabel.textColor = UIColor.darkGray
            explanationLabel.numberOfLines = 0
            explanationLabel.font = explanationLabel.font.withSize(12)
            explanationLabel.text = "This is the maximum height or width of your pictures"
            footerView.addSubview(explanationLabel)
            return footerView
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Sections.sizes.rawValue {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
            headerView.backgroundColor = UIColor.Base.lightGray
            let explanationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 32))
            explanationLabel.textColor = UIColor.darkGray
            explanationLabel.numberOfLines = 0
            explanationLabel.font = explanationLabel.font.withSize(12)
            explanationLabel.text = "PREDEFINED SIZES"
            headerView.addSubview(explanationLabel)
            return headerView
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
            headerView.backgroundColor = UIColor.Base.lightGray
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.sizes.rawValue {
            return checkSize.count - 1
        } else if section == Sections.custom.rawValue {
            if checkSize[checkSize.count - 1].isChecked {
                return 2
            } else {
                return 1
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.sizes.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectSizeTableViewCell.reuseIdentifier, for: indexPath) as? SelectSizeTableViewCell else { return UITableViewCell() }
            cell.name = getStringSize(size: checkSize[indexPath.row].sizeOption)
            cell.isRadioSelected = checkSize[indexPath.row].isChecked
            return cell
        } else if indexPath.section ==  Sections.custom.rawValue {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCustomSizeTableViewCell.reuseIdentifier, for: indexPath) as? SwitchCustomSizeTableViewCell else { return UITableViewCell() }
                cell.name = "Custom"
                for index in 0...checkSize.count - 1 {
                    if checkSize[index].sizeOption == .custom {
                        cell.switchButton.isOn = checkSize[index].isChecked
                    }
                }
                cell.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomSizeTableViewCell.reuseIdentifier, for: indexPath) as? CustomSizeTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                cell.customSizeText = String(presenter.getReducePictureSizeMaxSizeCustom())
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.sizes.rawValue {
            updateSizes(newOption: checkSize[indexPath.row].sizeOption)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SelectSizeView: SwitchCustomSizeTableViewCellDelegate {
    func didChangeCustomSwitch(isOn: Bool) {
        if isOn {
            updateSizes(newOption: .custom)
        } else {
            updateSizes(newOption: nil)
        }
    }
}

extension SelectSizeView: CustomSizeTableViewCellDelegate {
    func customSizeDidChange(customSize: String) {
        customSizeValue = Int(customSize) ?? 0
    }
}
