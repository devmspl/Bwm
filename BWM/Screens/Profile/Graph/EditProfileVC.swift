//
//  EditProfileVC.swift
//  BWM
//
//  Created by mac on 13/10/21.
//  Copyright © 2021 Almet Systems. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class EditProfileVC: UIViewController,UITextFieldDelegate {
//MARK: - outlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var ethnicity: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var aboutMe: UITextField!
//MARK: - BTN
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
// MARK: - VARIABLES
    let url = ""
    let drop = DropDown()
    var ethnicityId = ["Indigenous peoples","Americans","White people","American Indian group","Black people","Jewish people","Asian Americans","Han Chinese","Dravidian peoples","Puerto Ricans","Hispanic","Mexicans","Asian","European","African","Austrians","British"]
    var categoryId = ["Barber","Fitness Trainer","Artist"]
//MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        dob.delegate = self
    }
    
    func saveData(){
        if Reachability.isConnectedToNetwork(){
            let para : [String:Any] = ["firstName": ""]
            print(para)
            
            Alamofire.request(url, method: .put,parameters: para,encoding: JSONEncoding.default).responseJSON{
                response in
                
                switch(response.result){
                case .success(let json): do{
                    print(json)
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
                    if success == 200{
                        let succes = respond.object(forKey: "success") as! Bool
                        let message = respond.object(forKey: "message") as! String
                        if succes == true{
                            print(respond)
                            
                            let alert = UIAlertController.init(title: "BWM", message: message, preferredStyle: .actionSheet)
                            let ok = UIAlertAction.init(title: "OK", style: .default) { ok in
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                            self.view.isUserInteractionEnabled = true
                        }else{
                            self.view.isUserInteractionEnabled = true
                            Alerts.showCustomErrorMessage(title: "", message: message, button: "OK")
                        }
                    }else{
                        self.view.isUserInteractionEnabled = true
                        Alerts.showCustomErrorMessage(title: "", message: "server error", button: "OK")
                    }
                }
                case .failure(let error):do{
                    print("errorrrrrrr",error)
                    self.view.isUserInteractionEnabled = true
                }
                }
            }
            
        }else{
            Alerts.showNoConnectionErrorMessage()
        }
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        saveData()
    }
    
    @IBAction func ethnicity(_ sender: Any) {
        drop.anchorView = ethnicity
        drop.dataSource = ethnicityId
        drop.show()
        drop.selectionAction = {[unowned self] (index: Int,item: String) in
            ethnicity.text = item
            
        }
    }
    @IBAction func categoryTapped(_ sender: Any) {
        drop.anchorView = ethnicity
        drop.dataSource = categoryId
        drop.show()
        drop.selectionAction = {[unowned self] (index: Int,item: String) in
            category.text = item
            
        }
    }
    @IBAction func dob(_ sender: Any) {
        opendatepicker()
//
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        opendatepicker()
    
    }
}

extension EditProfileVC{
    
            func opendatepicker(){
                let datepicker = UIDatePicker()
                datepicker.datePickerMode = .date
                dob.inputView = datepicker
                
                if #available(iOS 13.4, *) {
                                   datepicker.preferredDatePickerStyle = .wheels
                               } else {
                                   // Fallback on earlier versions
                               }
                
                let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
                
                let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cnclBtnclick))
                
                let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnclick))
                
                let flexiblebtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                
                toolbar.setItems([cancelBtn,flexiblebtn,doneBtn], animated: false)
                dob.inputAccessoryView = toolbar
            }
            
            @objc
            func cnclBtnclick(){
                dob.resignFirstResponder()
            }
            
            @objc
            func doneBtnclick(){
                
                if let datePicker = dob.inputView as? UIDatePicker{
                    let dateformatter  = DateFormatter()
                    dateformatter.dateStyle = .medium
                    dob.text = dateformatter.string(from: datePicker.date)
                }
                dob.resignFirstResponder()
            }

        }

         
