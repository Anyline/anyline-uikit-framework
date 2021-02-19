//
//  ImageProcessingViewController.swift
//  AnylineUIKit
//
//  Created by Mac on 12/4/20.
//  Copyright © 2020 Anyline. All rights reserved.
//

import UIKit

class ImageProcessingViewController: UIViewController {

    var presenter: ImageProcessingViewPresenterProtocol

    @IBOutlet weak var pageImageView: UIImageView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    
    @IBOutlet weak var autoContrastSwitch: UISwitch!
    @IBOutlet weak var autoBrightnessSwtich: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    
    var checkColor: [CheckColorOption] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        pageImageView.contentMode = .scaleAspectFit
        
        brightnessSlider.maximumValue = 1
        brightnessSlider.minimumValue = -1
        
        brightnessSlider.value = 0
        
        contrastSlider.maximumValue = 2
        contrastSlider.minimumValue = 0
        
        contrastSlider.value = 1
        
        contrastSlider.isContinuous = false
        brightnessSlider.isContinuous = false

        let nib = UINib(nibName: "ImageProcessingTableViewCell", bundle: Bundle(for: ImageProcessingTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: ImageProcessingTableViewCell.reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply for all images", style: .plain, target: self, action: #selector(onApplyButton))
        
        setupOptions()
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.resultPage()
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        presenter.setImageBrightnesAndContrast(valueBrightnes: sender.value, valueContrast: contrastSlider.value)
        presenter.setFiltredImageVersion(image: pageImageView.image)
        if sender.value == 0 {
            autoBrightnessSwtich.isEnabled = true
        } else {
            autoBrightnessSwtich.isEnabled = false
        }
    }
    @IBAction func contrastSlider(_ sender: UISlider) {
        presenter.setImageBrightnesAndContrast(valueBrightnes: brightnessSlider.value, valueContrast: sender.value)
        presenter.setFiltredImageVersion(image: pageImageView.image)
        if sender.value == 0 {
            autoContrastSwitch.isEnabled = true
        } else {
            autoContrastSwitch.isEnabled = false
        }
    }

    @IBAction func autoContrastSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            presenter.setImageBrightnesAndContrast(valueBrightnes: brightnessSlider.value, valueContrast: 1)
            contrastSlider.value = 1
            presenter.setAutoContrast()
        } else {
            presenter.returnToDefault()
            presenter.setDisableContrast()
            if autoBrightnessSwtich.isOn {
                brightnessSlider.value = 0
                presenter.setAutoBrightness()
            }
        }
    }
    @IBAction func autoBrightnessSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            brightnessSlider.value = 0
            presenter.setAutoBrightness()
        } else {
            presenter.returnToDefault()
            presenter.setDisableBrightness()
            if autoContrastSwitch.isOn {
                brightnessSlider.value = 0
                presenter.setAutoContrast()
            }
        }
    }
    
    
    @IBAction func contrastSliderDidEndEditing(_ sender: UISlider) {
        presenter.setFiltredImageVersion(image: pageImageView.image)
    }
    
    init(presenter: ImageProcessingPresenter) {
        self.presenter = presenter
        super.init(nibName: "ImageProcessingViewController", bundle: Bundle(for: ImageProcessingViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageProcessingViewController {
    @objc func onApplyButton() {
        presenter.applyForAllImages(brigtness: brightnessSlider.value, contrast: contrastSlider.value)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupOptions() {
        checkColor = [CheckColorOption(colorOption: .color, isChecked: false), CheckColorOption(colorOption: .blackAndWhite, isChecked: false), CheckColorOption(colorOption: .gray, isChecked: false)]

        for index in 0...checkColor.count - 1 {
            let currentOption = presenter.getColorProcessingOfImage()
            if currentOption == checkColor[index].colorOption {
                checkColor[index].isChecked = true
            } else {
                checkColor[index].isChecked = false
            }
        }
    }

    func updateOptions(newOption: DocumentScanViewEnums.ImageProccessingMode?) {
        guard let newOption = newOption else {
            for index in 0...checkColor.count - 1 {
                checkColor[index].isChecked = false
            }
            tableView.reloadData()
            return
        }
        for index in 0...checkColor.count - 1  {
            checkColor[index].isChecked = false
        }
        for index in 0...checkColor.count - 1 {
            if checkColor[index].colorOption == newOption {
                checkColor[index].isChecked = true
                presenter.setColorProcessingOfImage(option: newOption)
                switch newOption {
                case .color:
                    presenter.setColorFilter()
                case .blackAndWhite:
                    presenter.setBWFilter()
                case .gray:
                    presenter.setGrayFilter()
                }
            }
        }
        tableView.reloadData()
    }
    
    func getStringColor(option: DocumentScanViewEnums.ImageProccessingMode) -> String {
        switch option {
        case .color:
            return "Color"
        case .blackAndWhite:
            return "Black and White"
        case .gray:
            return "Gray"
        }
    }
}

extension ImageProcessingViewController: ImageProcessingViewProtocol {
    func setControls(isAutoBrightnes: Bool, isAutoContrast: Bool, typeOfColor: DocumentScanViewEnums.ImageProccessingMode) {
        if isAutoBrightnes {
            autoBrightnessSwtich.isOn = true
        } else {
            autoBrightnessSwtich.isOn = false
        }
        
        if isAutoContrast {
            autoContrastSwitch.isOn = true
        } else {
            autoContrastSwitch.isOn = false
        }
    }
    
    func setImage(image: UIImage?) {
        pageImageView.image = image
    }
}

extension ImageProcessingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageProcessingTableViewCell.reuseIdentifier, for: indexPath) as? ImageProcessingTableViewCell else { return UITableViewCell() }
        cell.name = getStringColor(option: checkColor[indexPath.row].colorOption)
        cell.isRadioSelected = checkColor[indexPath.row].isChecked
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateOptions(newOption: checkColor[indexPath.row].colorOption)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
}
