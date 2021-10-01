//
//  SignUpProfileController.swift
//  BWM
//
//  Created by Serhii on 10/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import McPicker
import DatePickerDialog
import Flurry_iOS_SDK

class SignUpProfileController: BaseViewController {

    @IBOutlet private weak var buttonMale: UIButton!
    @IBOutlet private weak var buttonFemale: UIButton!
    
    @IBOutlet private weak var fieldEthnicity: BWMFlatTextField!
    @IBOutlet private weak var fieldBirthdate: BWMFlatTextField!
    @IBOutlet private weak var fieldCategory: BWMFlatTextField!
    
    @IBOutlet private weak var labelStep: UILabel!
    @IBOutlet private weak var labelScreenTitle: UILabel!
    
    
    var userInfo: UserSetupModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("SignUpScreen_profile")
        
//        customizeUI()
//        setupFields()
    }
    
    //MARK: - Actions
    
    @IBAction private func onButtonEthnicity() {
        let names = EthnicityStorage.shared.ethnicities.map { (item) -> String in
            return item.name
        }
        McPicker.show(data: [names]) {  [weak self] (selections: [Int : String]) -> Void in
            Flurry.logEvent("SignUpScreen_profile_selectEthnicity")
            if let name = selections[0] {
                self?.fieldEthnicity.text = name
                self?.fieldEthnicity.isFilled = true
                self?.userInfo.userData["ethnicityId"] = EthnicityStorage.idForName(name)
            }
        }
    }
    
    @IBAction private func onButtonBirthdate() {
        DatePickerDialog().show("DOB", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { (date) -> Void in
            if let dt = date {
                Flurry.logEvent("SignUpScreen_profile_selectDate")
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.fieldBirthdate.text = formatter.string(from: dt)
                self.fieldBirthdate.isFilled = true
                self.userInfo.userData["birthDate"] = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction private func onButtonCategory() {
        let names = CategoryStorage.shared.categories.map { (item) -> String in
            return item.name
        }
        McPicker.show(data: [names]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                Flurry.logEvent("SignUpScreen_profile_selectCategory")
                self?.fieldCategory.text = name
                self?.fieldCategory.isFilled = true
                self?.userInfo.userData["categoryId"] = CategoryStorage.idForName(name)
            }
            
        }
    }
    
    @IBAction private func onButtonGender(_ sender: UIButton) {
        self.selectGender(sender.tag)
    }
    
    //MARK: - Private methods
    
    private func customizeUI() {
        self.buttonMale.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonMale.layer.borderWidth = 1.0
        self.buttonFemale.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonFemale.layer.borderWidth = 1.0
        
//        setupStepLabel()
        
        labelScreenTitle.text = userInfo.isEditing ? "Edit account" : "New Account"
    }
    
    private func setupStepLabel() {
        let currentStep = userInfo.isEditing ? "2" : "3"
        let stepNumberStr = NSMutableAttributedString(string: currentStep,
                                                      attributes: [
                                                        NSAttributedStringKey.foregroundColor : UIColor.lightRed,
                                                        NSAttributedStringKey.font : UIFont(name: "PingFangSC-Medium", size: 28.0)!
            ])
        var stepCount = 4
        if self.userInfo.isEditing {
            stepCount -= 1
        }
        let stepStr = NSAttributedString(string: " / \(stepCount)\nSTEPS",
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.lightGray,
                NSAttributedStringKey.font : UIFont(name: "PingFangSC-Regular", size: 13.0)!
            ])
        let finalStr = NSMutableAttributedString()
        finalStr.append(stepNumberStr)
        finalStr.append(stepStr)
        
        labelStep.attributedText = finalStr
    }
    
    private func setupFields() {
        if let gender = userInfo.userData["gender"] as? Int {
            self.selectGender(gender)
        }
        else {
            self.selectGender(1)
        }
        
        if let itemId = self.userInfo.userData["ethnicityId"] as? Int {
            self.fieldEthnicity.text = EthnicityStorage.nameForId(itemId)
            self.fieldEthnicity.isFilled = true
        }
        if let itemId = self.userInfo.userData["categoryId"] as? Int {
            self.fieldCategory.text = CategoryStorage.nameForId(itemId)
            self.fieldCategory.isFilled = true
        }
        if let birthDate = self.userInfo.userData["birthDate"] as? String {
            self.fieldBirthdate.text = birthDate
            self.fieldBirthdate.isFilled = true
        }
    }
    
    private func selectGender(_ gender: Int) {
//        self.userInfo.userData["gender"] = gender
        
        buttonMale.setTitleColor(gender == 0 ? .white : .black, for: .normal)
        buttonMale.setBackgroundImage(gender == 0 ? R.image.common.gradient() : nil, for: .normal)
        
        buttonFemale.setTitleColor(gender == 1 ? .white : .black, for: .normal)
        buttonFemale.setBackgroundImage(gender == 1 ? R.image.common.gradient() : nil, for: .normal)
    }
    
    private func validateFields() -> Bool {
        var valid: Bool = true
        var errorMessage: String = ""
        if !fieldEthnicity.isFilled {
            valid = false
            errorMessage += "Ethnicity field can't be empty\n"
        }
        
        if !fieldBirthdate.isFilled {
            valid = false
            errorMessage += "Date of birth field can't be empty\n"
        }
        
        if !fieldCategory.isFilled {
            valid = false
            errorMessage += "Category field can't be empty"
        }
        
        if !valid {
            Alerts.showCustomErrorMessage(title: "Error", message: errorMessage, button: "OK")
        }
        
        return valid
    }
    
    //MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return validateFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let screen = segue.destination as? SignUpLocationController {
            screen.userInfo = self.userInfo
        }
    }

}
