//
//  ToolSettingViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 6/13/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

protocol ToolSettingDelegate {
  func onOptionsChanged(options: ToolOptions)
}

class ToolSettingViewController: NSViewController {
  var delegate: ToolSettingDelegate?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  required init(nibName: NSNib.Name?) {
    super.init(nibName: nibName, bundle: nil)
  }
  
  func getOptions() -> ToolOptions? {
    return nil
  }
  
  func ensureDefaults(_ forceDefaults: Bool = false) {
  }
  
  func readBool(_ key: String) -> Bool {
    guard let value = NSUserDefaultsController.shared.value(forKeyPath: "values." + key) as? Bool else {
      return false
    }
    
    return value
  }
  
  func readString(_ key: String) -> String {
    guard let value = NSUserDefaultsController.shared.value(forKeyPath: "values." + key) as? String else {
      return ""
    }
    
    return value
  }
}
