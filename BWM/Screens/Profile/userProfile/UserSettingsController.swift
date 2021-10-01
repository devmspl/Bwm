//
//  UserSettingsController.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import FacebookLogin
import SwiftyUserDefaults
import MessageUI
import Flurry_iOS_SDK

class UserSettingsController: UITableViewController, UserProfileTabController {
    var tabType: UserProfileTabType {
        return .settings
    }
    
    //MARK: - Outlets
    @IBOutlet private weak var labelCode: UILabel?
    @IBOutlet private weak var switchSearch: UISwitch?
    @IBOutlet private weak var switchTracking: UISwitch?
    
    //MARK: - Properties
    var delegate: UserProfileTabControllerDelegate?
    var confirmationCode: String = ""
    var settings: Settings?
    private var isPro: Bool {
        return Defaults[.userIsPro] == true
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.confirmationCode.count > 0 {
            self.labelCode?.text = confirmationCode
        }
        else {
            self.tableView.tableFooterView = nil
        }
        
        self.switchSearch?.isOn = self.settings?.search == 1 ? true : false
        self.switchTracking?.isOn = self.settings?.tracking == 1 ? true : false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Flurry.logEvent("UserProfileScreen_settings")
        self.delegate?.didChangeContentHeight(self.tableView.contentSize.height)
    }

    //MARK: - Private methods
    
    private func signOut() {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            Flurry.logEvent("UserProfileScreen_settings_signOut")
            Defaults[.token] = nil
            Defaults[.userIsPro] = false
            Defaults[.liveTracking] = false
            Defaults[.verificationCode] = nil
            LoginManager().logOut()
            self.present(Storyboards.Start.instantiateInitialViewController(), animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAccount() {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            Flurry.logEvent("UserProfileScreen_settings_deleteAccount")
            DeleteAccountRequest.fire(completion: { (success) in
                if success {
                    let alert = UIAlertController(title: "", message: "Your account was deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                        Defaults[.token] = nil
                        Defaults[.verificationCode] = nil
                        LoginManager().logOut()
                        self.present(Storyboards.Start.instantiateInitialViewController(), animated: true, completion: nil)
                    }))
                }
            })
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction private func onAllowSearchSwitch(_ sender: UISwitch) {
        if let settings = self.settings {
            Flurry.logEvent("UserProfileScreen_settings_allowSearch", withParameters: ["value": sender.isOn])
            let screen = self.parent?.parent as? UserProfileController
            screen?.blockSelf()
            self.settings?.search = sender.isOn == true ? 1 : 0
            UpdateSettingsRequest.fire(data: settings.dictionaryRepresentation()) { [screen](completed) in
                screen?.unblockSelf()
            }
        }
    }
    
    @IBAction private func onAllowTrackingSwitch(_ sender: UISwitch) {
        if isPro {
            if let settings = self.settings {
                Flurry.logEvent("UserProfileScreen_settings_allowTracking", withParameters: ["value": sender.isOn])
                let screen = self.parent?.parent as? UserProfileController
                screen?.blockSelf()
                self.settings?.tracking = sender.isOn == true ? 1 : 0
                Defaults[.liveTracking] = sender.isOn
                UpdateSettingsRequest.fire(data: settings.dictionaryRepresentation()) { [screen](completed) in
                    screen?.unblockSelf()
                }
            }
        }
        else {
            PurchaseUtils.shared.checkOnScreen(self, sCase: .tracking)
            sender.setOn(false, animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 5
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 40.0
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                if MFMailComposeViewController.canSendMail() {
                    Flurry.logEvent("UserProfileScreen_settings_contact")
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["info@trymonetize.com"])
                    present(mail, animated: true)
                }
            }
        }
        else {
            switch indexPath.row {
            case 3:
                signOut()
            case 4:
                deleteAccount()
            default: break
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let screen = segue.destination as? TextViewController {
            if segue.identifier == R.segue.userSettingsController.termsSegue.identifier {
                Flurry.logEvent("UserProfileScreen_settings_termsOfUse")
                screen.textType = .termsOfUse
            }
            else if segue.identifier == R.segue.userSettingsController.privacySegue.identifier {
                Flurry.logEvent("UserProfileScreen_settings_privacyPolicy")
                screen.textType = .privacyPolicy
            }
            else if segue.identifier == R.segue.userSettingsController.subscriptionSegue.identifier {
                Flurry.logEvent("UserProfileScreen_settings_subscriptionInfo")
                screen.textType = .subscriptionInfo
            }
        }
    }
}

extension UserSettingsController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
