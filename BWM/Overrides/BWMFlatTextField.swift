//
//  BWMTextField.swift
//  BWM
//
//  Created by obozhdi on 23/04/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit

class BWMFlatTextField: UITextField {

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
  
  var placeholderText: String = "" {didSet {self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])} }
  var style: Style = .name {didSet {customize()} }
  
  private var separatorView = UIView()
  
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
      self.keyboardType         = .asciiCapable
      self.isSecureTextEntry    = true
    }
    
    self.keyboardAppearance = .light
    self.backgroundColor = .white
    self.borderStyle    = .none
    self.font = UIFont.systemFont(ofSize: 16)
    self.textColor = UIColor.init(hex: 0x000000)
    self.tintColor = UIColor.init(hex: 0xAF37A9)
    
    separatorView.backgroundColor = UIColor.gray
    
    addSubviews()
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x,
                  y: bounds.origin.y,
                  width: bounds.width,
                  height: bounds.height)
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
    self.addSubview(separatorView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let screenHeight = self.bounds.size.height
    let screenWidth  = self.bounds.size.width
    
    separatorView.frame = CGRect(x: 0, y: screenHeight - 0.5, width: screenWidth, height: 0.5)
  }
  
  @objc func startedTyping() {
    if style == .password {
      if (text?.isEmpty)! {
        setGreyColor()
        isFilled = false
      }
    }
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
      isFilled = true
    }
  }
  
  func setGreyColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.init(hex: 0xC4C4C4)
      self.separatorView.setNeedsDisplay()
    }
  }
  
  func setRedColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.red
      self.separatorView.setNeedsDisplay()
    }
  }
  
  func setGreenColor() {
    UIView.animate(withDuration: 1.0) {
      self.separatorView.backgroundColor = UIColor.init(hex: 0x50E3C2)
      self.separatorView.setNeedsDisplay()
    }
  }

}
