//
//  TextViewController.swift
//  BWM
//
//  Created by Serhii on 11/2/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

fileprivate let privacy = """
This privacy policy sets out how SMG Global, LLC uses and protects any information that you give SMG Global, LLC when you use this website.

SMG Global, LLC is committed to ensuring that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, then you can be assured that it will only be used in accordance with this privacy statement.

SMG Global, LLC may change this policy from time to time by updating this page. You should check this page from time to time to ensure that you are happy with any changes. This policy is effective from November 2018.

What we collect

Your email address
Demographic information such as postcode, preferences and interests
information relevant to customer surveys and/or offers

What we do with the information we gather

We require this information to understand your needs and provide you with a better service, and in particular for the following reasons:

Internal record keeping
We may use the information to improve our products and services
We may periodically send promotional emails about new products, special offers or other information which we think you may find interesting using the email address which you have provided
From time to time, we may also use your information to contact you for market research purposes. We may contact you by email, phone, fax or mail. We may use the information to customize the website according to your interests

Security

We are committed to ensuring that your information is secure. In order to prevent unauthorized access or disclosure, we have put in place suitable physical, electronic and managerial procedures to safeguard and secure the information we collect online.

How we use cookies

A cookie is a small file which asks permission to be placed on your computer's hard drive. Once you agree, the file is added and the cookie helps analyze web traffic or lets you know when you visit a particular site. Cookies allow web applications to respond to you as an individual. The web application can tailor its operations to your needs, likes and dislikes by gathering and remembering information about your preferences.

We use traffic log cookies to identify which pages are being used. This helps us analyze data about web page traffic and improve our website in order to tailor it to customer needs. We only use this information for statistical analysis purposes and then the data is removed from the system.

Overall, cookies help us provide you with a better website, by enabling us to monitor which pages you find useful and which you do not. A cookie in no way gives us access to your computer or any information about you, other than the data you choose to share with us.

You can choose to accept or decline cookies. Most web browsers automatically accept cookies, but you can usually modify your browser setting to decline cookies if you prefer. This may prevent you from taking full advantage of the website.

Links to other websites

Our website may contain links to other websites of interest. However, once you have used these links to leave our site, you should note that we do not have any control over that other website. Therefore, we cannot be responsible for the protection and privacy of any information which you provide while visiting such sites and such sites are not governed by this privacy statement. You should exercise caution and look at the privacy statement applicable to the website in question.

Controlling your personal information

You may choose to restrict the collection or use of your personal information in the following ways

Whenever you are asked to fill in a form on the website, look for the box that you can click to indicate that you do not want the information to be used by anybody for direct marketing purposes.

if you have previously agreed to us using your personal information for direct marketing purposes, you may change your mind at any time by writing or by contacting us.

We will not sell, distribute or lease your personal information to third parties unless we have your permission or are required by law to do so. We may use your personal information to send you promotional information about third parties which we think you may find interesting if you tell us that you wish this to happen.

You may request details of personal information which we hold about you under the Data Protection Act 1998. A small fee will be payable. If you would like a copy of the information held on you please write to us.

If you believe that any information we are holding on you is incorrect or incomplete, please write to or email us as soon as possible, at the above address. We will promptly correct any information found to be incorrect.
"""

fileprivate let terms = """
Terms and conditions

Welcome to our website. If you continue to browse and use this website, you are agreeing to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern SMG Global, LLC's relationship with you in relation to this website. If you disagree with any part of these terms and conditions, please do not use our website.

The term 'SMG Global, LLC' or 'us' or 'we' refers to the owner of this website. The term 'you' refers to the user or viewer of our website.

The use of this website is subject to the following terms of use:

The content of the pages of this website is for your general information and use only. It is subject to change without notice.

This website uses cookies to monitor browsing preferences.

Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.

Your use of any information or materials on this website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this website meet your specific requirements.

This website contains material which is owned by or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance and graphics. Reproduction is prohibited other than in accordance with the copyright notice, which forms part of these terms and conditions.

All trademarks reproduced in this website, which are not the property of, or licensed to the operator, are acknowledged on the website.

Unauthorized use of this website may give rise to a claim for damages and/or be a criminal offence.

From time to time, this website may also include links to other websites. These links are provided for your convenience to provide further information. They do not signify that we endorse the website(s). We have no responsibility for the content of the linked website(s).

Your use of this website and any dispute arising out of such use of the website is subject to the laws of England, Northern Ireland, Scotland and Wales.

Age

You must be aged 14 years or older to use or register as a member on this website. If we discover or suspect that you are not over 14 years of age, then We reserve our right to suspend or terminate your membership to this site immediately and without notice.

Disclaimer

The information contained in this website is for general information purposes only. The information is provided by SMG Global, LLC and it's members and while we endeavor to keep the information up to date and correct, we make no representations or warranties of any kind, express or implied, about the completeness, accuracy, reliability, suitability or availability with respect to the website or the information, products, services, or related graphics contained on the website for any purpose. Any reliance you place on such information is therefore strictly at your own risk.

In no event will we be liable for any loss or damage including without limitation, indirect or consequential loss or damage, or any loss or damage whatsoever arising from loss of data or profits arising out of, or in connection with, the use of this website.

Through this website you are able to link to other websites which are not under the control of SMG Global, LLC. We have no control over the nature, content and availability of those sites. The inclusion of any links does not necessarily imply a recommendation or endorse the views expressed within them.

Every effort is made to keep the website up and running smoothly. However, SMG Global, LLC takes no responsibility for, and will not be liable for, the website being temporarily unavailable due to technical issues beyond our control.
"""

enum TextType {
    case termsOfUse
    case privacyPolicy
    case subscriptionInfo
    
    var screenTitle: String {
        switch self {
        case .termsOfUse:
            return "Terms of Use"
        case .privacyPolicy:
            return "Privacy policy"
        case .subscriptionInfo:
            return "Subscription Information"
        }
    }
    
    var screenText: String {
        let text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        switch self {
        case .termsOfUse:
            return terms
        case .privacyPolicy:
            return privacy
        case .subscriptionInfo:
            return text
        }
    }
}

class TextViewController: BaseViewController {

    @IBOutlet private weak var textView: UITextView!
    
    var textType: TextType = .termsOfUse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.textType.screenTitle
        self.textView.text = self.textType.screenText
    }
}
