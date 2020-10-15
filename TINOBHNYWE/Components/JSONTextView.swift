//
//  JSONTextView.swift
//  DevUtils
//
//  Created by Tony Dinh on 5/30/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa
import Highlightr

class JSONTextView: NSTextView {
  
  var highlightr: Highlightr! = Highlightr()
  var enableHighlight: Bool = true
  var currentFormat: Int?
  var currentSpaces: Bool = true
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setTheme()
    
    DistributedNotificationCenter.default.addObserver(
      self,
      selector: #selector(interfaceModeChanged(sender:)),
      name: NSNotification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
  }
  
  func setHighlight(_ value: Bool) {
    self.enableHighlight = value
  }
  
  // format = nil means compact (minified)
  func setJSONString(_ value: String, format: Int? = 2, spaces: Bool = true) {
    currentFormat = format
    currentSpaces = spaces
    var errors: [JSONParseError] = []
    let output = value.pretifyJSONv2(format: format, spaces: spaces, errors: &errors)
    
    if output != nil && output != "undefined" {
      self.string = ""
      if self.enableHighlight {
        if let attributedString = highlightr.highlight(output!, as: "json") {
          self.textStorage?.setAttributedString(attributedString)
        }
      } else {
        self.string = output!
      }
      
      if errors.count > 0 {
        errors.forEach { (e) in
          self.textStorage?.addAttributes(
            [
              NSAttributedString.Key.backgroundColor: NSColor.red,
              NSAttributedString.Key.foregroundColor: NSColor.black,
              NSAttributedString.Key.underlineStyle: 1,
            ],
            range: .init(location: e.offset, length: e.length)
          )
        }
        
      }
    } else {
      self.string = "Invalid JSON"
    }
  }
  
  private func setTheme() {
    if self.hasDarkAppearance {
      highlightr.setTheme(to: "paraiso-dark")
    } else {
      highlightr.setTheme(to: "paraiso-light")
    }
  }
  
  @objc
  func interfaceModeChanged(sender: NSNotification) {
    setTheme()
    setJSONString(self.string, format: currentFormat, spaces: currentSpaces)
  }
  
  deinit {
    DistributedNotificationCenter.default().removeObserver(
      self,
      name: NSNotification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
  }
}
