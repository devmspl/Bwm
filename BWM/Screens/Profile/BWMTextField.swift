//
//  BWMTextField.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit

class BWMTextField: UITextField {

  private struct Length {
    static var minNameLength = 3
    static var minPassLength = 4
  }
  
  enum Style {
    case name
    case email
    case password
  }
  
  var isFilled: Bool = false
  
  var placeholderText: String = "" {
    didSet {
      self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
    }
  }
  
  var style: Style = .name {didSet {customize()} }
  
  private var contourView: UIView = UIView()
  private var currentColor: CGColor = UIColor(233, 233, 233).cgColor
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    customize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    customize()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  fileprivate func customize() {
    self.addTarget(self, action: #selector(startedTyping), for: .editingDidBegin)
    self.addTarget(self, action: #selector(typedCharacter), for: .allEditingEvents)
    self.addTarget(self, action: #selector(finishedTyping), for: .editingDidEnd)
    
    switch style {
    case .name:
      self.autocapitalizationType = .none
      self.keyboardType = .asciiCapable
      self.keyboardType = .default
    case .email:
      self.keyboardType = .emailAddress
    case .password:
      self.keyboardType      = .asciiCapable
      self.isSecureTextEntry = true
    }
    
    self.keyboardAppearance = .light
    self.backgroundColor = .white
    self.borderStyle    = .none
    self.font = UIFont.systemFont(ofSize: 15)
    self.textColor = UIColor.gray
    self.tintColor = UIColor.red
    
    contourView.backgroundColor = UIColor.gray
    
    addSubviews()
  }
  
  fileprivate struct Padding {
    static let side   = CGFloat(12)
    static let top    = CGFloat(20)
    static let bottom = CGFloat(20)
    static let inter  = CGFloat(10)
    
    struct Image {
      static let side = CGFloat(12)
      static let top  = CGFloat(12)
    }
    
    struct Button {
      static let height = CGFloat(50)
      static let width  = CGFloat(296)
    }
  }
  
  func addSubviews() {
    self.insertSubview(contourView, at: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let h = self.bounds.size.height
    let w = self.bounds.size.width
    
    contourView.frame = CGRect(x: 0, y: 0, width: w, height: h)
    contourView.layer.cornerRadius = 8.0
    contourView.isUserInteractionEnabled = false
    contourView.layer.borderWidth = 1.0
    contourView.layer.borderColor = UIColor(233, 233, 233).cgColor
    contourView.backgroundColor = .clear
  }
  
  @objc func startedTyping() {
    if style == .password {
      if (text?.isEmpty)! {
        setGreyColor()
        isFilled = false
      }
    }
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
  }
  
  @objc func typedCharacter() {
    switch style {
    case .name:
      if (text?.isEmpty)! {
        setGreyColor()
        isFilled = false
      } else if 0..<Length.minNameLength ~= (text?.count)! {
        setRedColor()
        isFilled = false
      } else {
        setGreenColor()
        isFilled = true
      }
    case .email:
      if (text?.isEmpty)! {
        setGreyColor()
        isFilled = false
      } else if !(text?.isValidEmail())! {
        setRedColor()
        isFilled = false
      } else {
        setGreenColor()
        isFilled = true
      }
    case .password:
      if (text?.isEmpty)! {
        setGreyColor()
        isFilled = false
      } else if 0..<Length.minPassLength ~= (text?.count)! {
        setRedColor()
        isFilled = false
      } else {
        setGreenColor()
        isFilled = true
      }
    }
  }
  
  @objc func finishedTyping() {
    if (text?.isEmpty)! {
      setGreyColor()
      isFilled = false
    }
  }
  
  func setGreyColor() {
    contourView.layer.borderWidth = 1
    contourView.layer.borderColor = UIColor(233, 233, 233).cgColor
    self.setNeedsDisplay()
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.contourView.setNeedsDisplay()
    self.contourView.setNeedsLayout()
    self.contourView.layoutIfNeeded()
  }
  
  func setRedColor() {
    contourView.layer.borderWidth = 1
    contourView.layer.borderColor = UIColor.red.cgColor
    self.setNeedsDisplay()
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.contourView.setNeedsDisplay()
    self.contourView.setNeedsLayout()
    self.contourView.layoutIfNeeded()
  }
  
  func setGreenColor() {
    contourView.layer.borderWidth = 1
    contourView.layer.borderColor = UIColor.green.cgColor
    self.setNeedsDisplay()
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.contourView.setNeedsDisplay()
    self.contourView.setNeedsLayout()
    self.contourView.layoutIfNeeded()
  }

}
