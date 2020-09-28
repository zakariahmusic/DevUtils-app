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
  var currentFormat: Any?
  
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
  
  func setJSONString(_ value: String, _ format: Any? = nil) {
    currentFormat = format
    let output = value.pretifyJSON(format: format)
    
    if output != nil && output != "undefined" {
      self.string = ""
      if self.enableHighlight {
        if let attributedString = highlightr.highlight(output!, as: "json") {
          self.textStorage?.setAttributedString(attributedString)
        }
      } else {
        self.string = output!
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
    setJSONString(self.string, currentFormat)
  }
  
  deinit {
    DistributedNotificationCenter.default().removeObserver(
      self,
      name: NSNotification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
  }
}
