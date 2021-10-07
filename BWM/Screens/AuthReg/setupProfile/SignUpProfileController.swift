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
import DropDown

class SignUpProfileController: BaseViewController {

    @IBOutlet private weak var buttonMale: UIButton!
    @IBOutlet private weak var buttonFemale: UIButton!
    
    @IBOutlet private weak var fieldEthnicity: BWMFlatTextField!
    @IBOutlet private weak var fieldBirthdate: BWMFlatTextField!
    @IBOutlet private weak var fieldCategory: BWMFlatTextField!
    
    @IBOutlet private weak var labelStep: UILabel!
    @IBOutlet private weak var labelScreenTitle: UILabel!
    
    let drop = DropDown()
    
    var userInfo: UserSetupModel!
    
    var ethnicity = ["Indigenous peoples","Americans","White people","American Indian group","Black people","Jewish people","Asian Americans","Han Chinese","Dravidian peoples","Puerto Ricans","Hispanic","Mexicans","Asian","European","African","Austrians","British"]
    var category = ["Barber","Fitness Trainer","Artist"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("SignUpScreen_profile")
        
//        customizeUI()
//        setupFields()
    }
    
    //MARK: - Actions
    
    @IBAction private func onButtonEthnicity() {
        drop.anchorView = fieldEthnicity
        drop.dataSource = ethnicity
        drop.show()
        drop.selectionAction = {[unowned self] (index: Int,item: String) in
            fieldEthnicity.text = item
            UserDefaults.standard.setValue(item, forKey: "ethnicity")
         }
    }
    
    @IBAction private func onButtonBirthdate() {
        DatePickerDialog().show("DOB", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { [self] (date) -> Void in
            if let dt = date {
                Flurry.logEvent("SignUpScreen_profile_selectDate")
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.fieldBirthdate.text = formatter.string(from: dt)
                self.fieldBirthdate.isFilled = true
                UserDefaults.standard.setValue(fieldBirthdate.text!, forKey: "date")
//                self.userInfo.userData["birthDate"] = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction private func onButtonCategory() {
        drop.anchorView = fieldCategory
        drop.dataSource = category
        drop.show()
        drop.selectionAction = {[unowned self] (index: Int,item: String) in
            fieldCategory.text = item
           
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
        
            UserDefaults.standard.setValue(gender, forKey: "gender")
        print(UserDefaults.standard.value(forKey: "gender"))
        
    }
    
    private func validateFields()-> Bool {
        if fieldCategory.text == "" || fieldCategory.text == "" || fieldBirthdate.text == ""{
            Alerts.showCustomErrorMessage(title: "BWM", message: "Please fill all fields", button: "OK")
        }else{
            return true
        }
        return true
    }
    
    //MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return validateFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let screen = segue.destination as? SignUpLocationController {
            screen.userInfo = self.userInfo
            UserDefaults.standard.setValue(fieldEthnicity.text!, forKey: "ethnicity")
            UserDefaults.standard.setValue(fieldBirthdate.text!, forKey: "date")
            UserDefaults.standard.setValue(fieldCategory.text!, forKey: "category")
            
        }
    }

}
