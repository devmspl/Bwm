//
//  FilterController.swift
//  BWM
//
//  Created by obozhdi on 21/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import RangeSeekSlider
import McPicker

class FilterController: BaseViewController {
    @IBOutlet private weak var distanceSlider : RangeSeekSlider!
    @IBOutlet private weak var ageSlider      : RangeSeekSlider!
    
    @IBOutlet private weak var genderBtn   : BWMFlatButton!
    @IBOutlet private weak var ethnoBtn    : BWMFlatButton!
    @IBOutlet private weak var categoryBtn : BWMFlatButton!
    @IBOutlet private weak var cityBtn     : BWMFlatButton!
    
    lazy var searchRequest: SearchRequestObject = {
        return SearchStore.shared.filterObject
    }()
    
    @IBOutlet weak var igtextField: BWMTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageSlider.delegate = self
        distanceSlider.delegate = self
        distanceSlider.selectedHandleDiameterMultiplier = 1.33
        ageSlider.selectedHandleDiameterMultiplier      = 1.33
        distanceSlider.handleBorderWidth                = 0.5
        ageSlider.handleBorderWidth                     = 0.5
        
        self.title = "SEARCH FILTER"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilter))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateValues()
        unblockView()
    }
    
    func updateValues() {
        if let radius = self.searchRequest.radius{
            self.distanceSlider.selectedMaxValue = CGFloat(radius)
        }
        else {
            self.distanceSlider.selectedMaxValue = self.distanceSlider.maxValue
        }
        if let ageMin = self.searchRequest.ageFrom,
            let ageMax = self.searchRequest.ageTo {
            self.ageSlider.selectedMinValue = CGFloat(ageMin)
            self.ageSlider.selectedMaxValue = CGFloat(ageMax)
        }
        else {
            self.ageSlider.selectedMinValue = self.ageSlider.minValue
            self.ageSlider.selectedMaxValue = self.ageSlider.maxValue
        }
        if let name = self.searchRequest.userName{
            self.igtextField.text = name
        }
        else {
            self.igtextField.text = ""
        }
        if let gender = self.searchRequest.gender {
            self.genderBtn.setTitle(gender == 0 ? "Male" : "Female", for: .normal)
            self.genderBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
        }
        else {
            self.genderBtn.setTitle("All", for: .normal)
            self.genderBtn.setTitleColor(UIColor.init(hex: 0xD8D8D8), for: .normal)
        }
        if let ethnicity = self.searchRequest.ethnicity {
            self.ethnoBtn.setTitle(ethnicity.name, for: .normal)
            self.ethnoBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
        }
        else {
            self.ethnoBtn.setTitle("All", for: .normal)
            self.ethnoBtn.setTitleColor(UIColor.init(hex: 0xD8D8D8), for: .normal)
        }
        if let category = self.searchRequest.category {
            self.categoryBtn.setTitle(category.name, for: .normal)
            self.categoryBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
        }
        else {
            self.categoryBtn.setTitle("All", for: .normal)
            self.categoryBtn.setTitleColor(UIColor.init(hex: 0xD8D8D8), for: .normal)
        }
        if let city = self.searchRequest.city {
            self.cityBtn.setTitle(city, for: .normal)
            self.cityBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
        }
        else {
            self.cityBtn.setTitle("All", for: .normal)
            self.cityBtn.setTitleColor(UIColor.init(hex: 0xD8D8D8), for: .normal)
        }
    }
    
    @objc private func clearFilter() {
        self.searchRequest.clear()
        self.updateValues()
    }
    
    @IBAction func togglePicker(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            McPicker.show(data: [["Male", "Female"]]) {  [weak self] (selections: [Int : String]) -> Void in
                if let name = selections[0] {
                    self?.searchRequest.gender = name == "Male" ? 0 : 1
                    self?.genderBtn.setTitle(name, for: .normal)
                    self?.genderBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
                }
            }
        case 1:
            let values = EthnicityStorage.shared.ethnicities.values
            McPicker.show(data: [values]) {  [weak self, values] (selections: [Int : String]) -> Void in
                if let value = selections.first {
                    let index = values.index(of: value.value)!
                    self?.searchRequest.ethnicity = EthnicityStorage.shared.ethnicities[index]
                    self?.ethnoBtn.setTitle(value.value, for: .normal)
                    self?.ethnoBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
                }
            }
        case 3:
            let values = CategoryStorage.shared.categories.values
            McPicker.show(data: [values]) { [weak self, values] (selections: [Int : String]) -> Void in
                if let value = selections.first {
                    let index = values.index(of: value.value)!
                    self?.searchRequest.category = CategoryStorage.shared.categories[index]
                    self?.categoryBtn.setTitle(value.value, for: .normal)
                    self?.categoryBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
                }
            }
        default:
            break
        }
    }
    
    @IBAction private func onLocationButton() {
        /*let screen = Storyboards.AuthReg.instantiateAddAddressController()
        screen.shouldGetAddress = false
        screen.delegate = self
        screen.shouldDismiss = false
        screen.shouldShowCityName = true
        self.navigationController?.pushViewController(screen, animated: true)*/
    }
    
    @IBAction func tapApply(_ sender: Any) {
        if let string = igtextField.text,
            string.trimmingCharacters(in: .whitespaces).count > 0{
            self.searchRequest.userName = string
        }
        SearchStore.shared.filterObject = self.searchRequest
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider == self.ageSlider {
            if slider.selectedMinValue == self.ageSlider.minValue && slider.selectedMaxValue == self.ageSlider.maxValue {
                self.searchRequest.ageFrom = nil
                self.searchRequest.ageTo = nil
            }
            else {
                self.searchRequest.ageFrom = Int(slider.selectedMinValue)
                self.searchRequest.ageTo = Int(slider.selectedMaxValue)
            }
        }
        else if slider == self.distanceSlider {
            if slider.selectedMaxValue != 0 {
                self.searchRequest.radius = Int(slider.selectedMaxValue)
            }
            else {
                self.searchRequest.radius = nil
            }
        }
    }
}

/*extension FilterController: AddAddressControllerDelegate {
    func didSelectItem(_ item: String) {
        self.searchRequest.city = item
        self.cityBtn.setTitle(item, for: .normal)
        self.cityBtn.setTitleColor(UIColor.init(hex: 0x000000), for: .normal)
    }
}*/
