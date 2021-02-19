//
//  BottomSheetView.swift
//  AnylineUIKit
//
//  Created by Mac on 10/20/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit
import Anyline

class BottomScanSheetView: UIViewController {

    var presenter: BottomScanSheetViewPresenterProtocol
    
    
    lazy var flashOnToolTipView: UIView = {
        let flashOnToolTipView = UIView()
        flashOnToolTipView.isHidden = true
        flashOnToolTipView.layer.cornerRadius = 5
        flashOnToolTipView.backgroundColor = presenter.getBackgroundMessager()
        return flashOnToolTipView
    }()
    
    lazy var multipleToolTipView: UIView = {
        let multipleToolTipView = UIView()
        multipleToolTipView.isHidden = true
        multipleToolTipView.layer.cornerRadius = 5
        multipleToolTipView.backgroundColor = presenter.getBackgroundMessager()
        return multipleToolTipView
    }()
    
    lazy var flashOnToolTipLabel: UILabel = {
        let flashOnToolTipLabel = UILabel()
        flashOnToolTipLabel.text = "Flash is"
        flashOnToolTipLabel.textAlignment = .center
        flashOnToolTipLabel.font = flashOnToolTipLabel.font.withSize(10)
        flashOnToolTipLabel.tintColor = presenter.getTextMessage()
        return flashOnToolTipLabel
    }()
    
    lazy var multipleToolTipLabel: UILabel = {
        let multipleToolTipLabel = UILabel()
        multipleToolTipLabel.text = "Scan a"
        multipleToolTipLabel.textAlignment = .center
        multipleToolTipLabel.font = flashOnToolTipLabel.font.withSize(10)
        multipleToolTipLabel.tintColor = presenter.getTextMessage()
        return multipleToolTipLabel
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = presenter.getTextBottomBar()
        return countLabel
    }()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var expandView: UIImageView!
    @IBOutlet weak var firstPositionButton: UIButton!
    @IBOutlet weak var secondPositionButton: UIButton!
    @IBOutlet weak var thirdPositionButtonButton: UIButton!
    @IBOutlet weak var fourthPositionButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var bottomBarButtons: [UIButton] = []
    var indexOfOkButton: Int? = nil
    var indexOfManualButton: Int? = nil
    var indexOfFlashButton: Int? = nil
    var indexOfMultipleButton: Int? = nil
    
    var moveCallback: ((Bool) -> Void)?

    var fullViewYPosition: CGFloat {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        return UIScreen.main.bounds.height - contentView.frame.height - bottomPadding
    }
    var partialViewYPosition: CGFloat {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        let bottomSheetViewHeight: CGFloat = 55.0
        let defaultTopTableViewConstraint: CGFloat = 20.0
        
        return UIScreen.main.bounds.height - (bottomSheetViewHeight + defaultTopTableViewConstraint + bottomPadding)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        contentView.addGestureRecognizer(gesture)
        
        let nib = UINib(nibName: "BottomScanSheetViewCell", bundle: Bundle(for: BottomScanSheetView.self))
        tableView.register(nib, forCellReuseIdentifier: BottomScanSheetViewCell.reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        bottomBarButtons = [firstPositionButton, secondPositionButton, thirdPositionButtonButton, fourthPositionButton, fifthButton]

        setupBottomBar()
        setOkButton(count: 0)
        setupFlashMode()
        setupMultipleButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    init(presenter: BottomSheetPresenter) {
        let bundle = Bundle(for: BottomScanSheetView.self)
        self.presenter = presenter
        super.init(nibName: "BottomSheetView", bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BottomScanSheetView {
    
    func setupBottomBar() {
        contentView.backgroundColor = presenter.getBackgroundBottomBar()
        tableView.separatorColor = presenter.getDivider()
        let bundle = Bundle(for: BottomScanSheetView.self)
        expandView.image = UIImage(named: "arrowUp", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        expandView.tintColor = presenter.getTintControls()
        
        let bottomBarItems = presenter.getScanBottomBarControls()
        for item in 0..<bottomBarItems.count {
            switch bottomBarItems[item] {
            case .flash:
                indexOfFlashButton = item
                bottomBarButtons[item].setupBaseBottomScanUIButton(imageName: "flashOn", selectedImageName: "flashOff", tintColor: presenter.getTintControls())
                bottomBarButtons[item].addTarget(self, action: #selector(onFlashOnButton), for: .touchUpInside)
                view.addSubview(flashOnToolTipView)
                flashOnToolTipView.addSubview(flashOnToolTipLabel)
                flashOnToolTipView.snp.makeConstraints {
                    $0.centerX.equalTo(bottomBarButtons[item])
                    $0.width.equalTo(73)
                    $0.height.equalTo(30)
                    $0.bottom.equalTo(bottomBarButtons[item].snp.top).offset(5)
                }
                flashOnToolTipLabel.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            case .scanMode:
                indexOfMultipleButton = item
                bottomBarButtons[item].setupBaseBottomScanUIButton(imageName: "modeMulti", selectedImageName: "modeSingle", tintColor: presenter.getTintControls())
                bottomBarButtons[item].addTarget(self, action: #selector(onMultipleButton), for: .touchUpInside)
                view.addSubview(multipleToolTipView)
                multipleToolTipView.addSubview(multipleToolTipLabel)
                multipleToolTipView.snp.makeConstraints {
                    $0.centerX.equalTo(bottomBarButtons[item])
                    $0.width.equalTo(120)
                    $0.height.equalTo(30)
                    $0.bottom.equalTo(bottomBarButtons[item].snp.top).offset(5)
                }
                multipleToolTipLabel.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            case .manualPicture:
                indexOfManualButton = item
                bottomBarButtons[item].setupBaseBottomScanUIButton(imageName: "uiShooter", selectedImageName: nil, tintColor: presenter.getTintManualPictureButton())
                bottomBarButtons[item].addTarget(self, action: #selector(onManualButton), for: .touchUpInside)
            case .cancel:
                bottomBarButtons[item].setupBaseBottomScanUIButton(imageName: "cancel", selectedImageName: nil, tintColor: presenter.getTintControls())
                bottomBarButtons[item].addTarget(self, action: #selector(onCancelButton), for: .touchUpInside)
            case .ok:
                indexOfOkButton = item
                bottomBarButtons[item].setupBaseBottomScanUIButton(imageName: "ok", selectedImageName: nil, tintColor: presenter.getTintControls())
                view.addSubview(countLabel)
                countLabel.snp.makeConstraints {
                    $0.centerX.equalTo(bottomBarButtons[item])
                    $0.bottom.equalTo(bottomBarButtons[item].snp.top).offset(10)
                }
                bottomBarButtons[item].addTarget(self, action: #selector(onOkButton), for: .touchUpInside)
            case .format:
                bottomBarButtons[item].isHidden = true
            case .pictureResize:
                bottomBarButtons[item].isHidden = true
            case .empty:
                bottomBarButtons[item].isHidden = true
            }
        }
    }
    
    func setupMultipleButton() {
        let scanMode = presenter.getScanMode()
        guard let index = indexOfMultipleButton else {
            return
        }
        if scanMode == DocumentScanViewEnums.ScanMode.multiplePages {
            bottomBarButtons[index].isSelected = false
        } else {
            bottomBarButtons[index].isSelected = true
        }
    }
    
    private func setupFlashMode() {
        let status = presenter.getFlashMode()
        guard let index = indexOfFlashButton else {
            return
        }
        switch status {
        case .off:
            bottomBarButtons[index].isSelected = false
        case .on, .auto:
            bottomBarButtons[index].isSelected = true
        @unknown default:
            break
        }
    }

    @objc func onManualButton() {
        presenter.onManualButton()
    }

    @objc func onFlashOnButton() {
        guard let index = indexOfFlashButton else {
            return
        }
        let isSelected = !bottomBarButtons[index].isSelected
        bottomBarButtons[index].isSelected = isSelected
        if isSelected {
            flashOnToolTipLabel.text = "Flash is OFF"
            presenter.onFlash(status: .off)
        } else {
            flashOnToolTipLabel.text = "Flash is ON"
            presenter.onFlash(status: .on)
        }
        showToolTip(toolTipView: flashOnToolTipView)
    }

    @objc func onMultipleButton() {
        guard let index = indexOfMultipleButton else {
            return
        }
        let isSelected = !bottomBarButtons[index].isSelected
        bottomBarButtons[index].isSelected = isSelected
        if isSelected {
            presenter.setScanMode(scanMode: DocumentScanViewEnums.ScanMode.singlePage)
            multipleToolTipLabel.text = "Scan a single page"
        } else {
            multipleToolTipLabel.text = "Scan multiple page"
            presenter.setScanMode(scanMode: DocumentScanViewEnums.ScanMode.multiplePages)
        }
        showToolTip(toolTipView: multipleToolTipView)
    }
    
    @objc func onCancelButton() {
        presenter.onCancelButton()
    }
    
    @objc func onOkButton() {
        presenter.onOkButton()
    }
    
    private func moveView(state: Bool) {
        let yPosition = state == true ? partialViewYPosition : fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
        
        for bottomButton in self.bottomBarButtons {
            bottomButton.isEnabled = state
        }
        if state {
            self.expandView.alpha = 0
            self.expandView.isHidden = false
            
            self.presenter.setExpandedState(state: false)
            UIView.animate(withDuration: 1) {
                self.expandView.alpha = 1
            }
        } else {
            self.expandView.isHidden = true
            self.presenter.setExpandedState(state: true)
        }
        moveCallback?(state)
    }

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY

        if (minY + translation.y >= fullViewYPosition) && (minY + translation.y <= partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: { [weak self] in
                guard let self = self else {
                    return
                }
                let state: Bool = recognizer.velocity(in: self.contentView).y > 0 ? true : false
                self.moveView(state: state)

                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func showToolTip(toolTipView: UIView) {
        let firstFadeDuration: CGFloat = 1
        let secondFadeDuration: CGFloat = 4
        toolTipView.isHidden = false
        UIView.animate(withDuration: TimeInterval(firstFadeDuration), animations: {
            toolTipView.alpha = 1
        })
        UIView.animate(withDuration: TimeInterval(secondFadeDuration), animations: {
            toolTipView.alpha = 0
        })
    }
}

extension BottomScanSheetView: BottomScanSheetViewProtocol {
    func setOkButton(count: Int) {
        guard let index = indexOfOkButton else {
            return
        }
        let scanMode = presenter.getScanMode()
        if count == 0 {
            bottomBarButtons[index].isEnabled = false
            countLabel.text = ""
        } else if scanMode == DocumentScanViewEnums.ScanMode.singlePage {
            countLabel.text = ""
            bottomBarButtons[index].isEnabled = true
        } else {
            countLabel.text = String(count)
            bottomBarButtons[index].isEnabled = true
        }
    }
    
    func showSelectFormat() {
        let presenterFormat = presenter.createSelectFormatPresenter()
        let selectFormatView = SelectFormatView(presenter: presenterFormat)
        let navigationView = UINavigationController(rootViewController: selectFormatView)
        self.present(navigationView, animated: true, completion: nil)
    }
    
    func showSelectSize() {
        let presenterSize = presenter.createSelectSizePresenter()
        let selectSizeView = SelectSizeView(presenter: presenterSize)
        let navigationView = UINavigationController(rootViewController: selectSizeView)
        self.present(navigationView, animated: true, completion: nil)
    }
    
    public func updateView() {
        tableView.reloadData()
    }
    
    func closeView() {
        moveView(state: true)
    }
}

extension BottomScanSheetView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let barExtension = presenter.getScanBottomBarExtensionControls()
        return barExtension.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomScanSheetViewCell.reuseIdentifier, for: indexPath) as? BottomScanSheetViewCell else { return UITableViewCell() }
        let barExtension = presenter.getScanBottomBarExtensionControls()
        switch barExtension[indexPath.row] {
        case .flash: break
        case .scanMode: break
        case .manualPicture: break
        case .cancel: break
        case .ok: break
        case .format:
            cell.name = "Scan Formats: " + presenter.getScanFormatString()
            cell.icon = "selectFormat"
            cell.tintIconColor = presenter.getTintControls()
        case .pictureResize:
            cell.name = "Picture Size: " + presenter.getScanSizeString()
            cell.icon = "pictureSize"
            cell.tintIconColor = presenter.getTintControls()
        case .empty:
            cell.name = ""
            cell.icon = nil
            cell.tintIconColor = nil
        }
        return cell
    }
}

extension BottomScanSheetView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let barExtension = presenter.getScanBottomBarExtensionControls()
        switch barExtension[indexPath.row] {
        case .flash: break
        case .scanMode: break
        case .manualPicture: break
        case .cancel: break
        case .ok: break
        case .format:
            showSelectFormat()
        case .pictureResize:
            showSelectSize()
        case .empty: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
