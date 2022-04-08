//
//  RegexTesterSettingViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 11/6/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class RegexTesterOptions: ToolOptions {
  var flags: String
  init(autoDetect: Bool, flags: String) {
    self.flags = flags
    super.init(autoDetect: autoDetect)
  }
  
  func getFlags() -> String {
    if flags.count == 0 {
      return ""
    }
    
    return "(?\(flags))"
  }
}

class RegexTesterSettingViewController: ToolSettingViewController {
  @IBOutlet weak var flagICheckbox: NSButton!
  @IBOutlet weak var flagXCheckbox: NSButton!
  @IBOutlet weak var flagSCheckbox: NSButton!
  @IBOutlet weak var flagMCheckbox: NSButton!
  @IBOutlet weak var flagWCheckbox: NSButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateFlagCheckboxes()
  }
  
  func updateFlagCheckboxes() {
    flagICheckbox.objectValue = false
    flagXCheckbox.objectValue = false
    flagSCheckbox.objectValue = false
    flagMCheckbox.objectValue = false
    flagWCheckbox.objectValue = false
    
    let flags = getOptions().flags
    
    if flags.contains("i") {
      flagICheckbox.objectValue = true
    }
    if flags.contains("x") {
      flagXCheckbox.objectValue = true
    }
    if flags.contains("s") {
      flagSCheckbox.objectValue = true
    }
    if flags.contains("m") {
      flagMCheckbox.objectValue = true
    }
    if flags.contains("w") {
      flagWCheckbox.objectValue = true
    }
  }
  
  @IBAction func restoreDefaultsButtonAction(_ sender: Any) {
    ensureDefaults(true)
  }
  
  override func getOptions() -> RegexTesterOptions {
    return RegexTesterOptions.init(
      autoDetect: readBool("regex-tester-settings-auto-detect"),
      flags: readString("regex-tester-settings-auto-flags")
    )
  }
  
  override func ensureDefaults(_ forceDefaults: Bool = false) {
    AppState.ensureDefault("values.regex-tester-settings-auto-detect", true, forceDefaults)
    AppState.ensureDefault("values.regex-tester-settings-auto-flags", "", forceDefaults)
    if isViewLoaded {
      updateFlagCheckboxes()
      delegate?.onOptionsChanged(options: getOptions())
    }
  }
  
  @IBAction func flagCheckboxesChanged(_ sender: Any) {
    NSUserDefaultsController.shared.setValue(readFlags(), forKeyPath: "values.regex-tester-settings-auto-flags")
    delegate?.onOptionsChanged(options: getOptions())
  }
  
  func readFlags() -> String {
    var flags = ""
    
    if flagICheckbox.objectValue as? Bool == true {
      flags += "i"
    }
    if flagXCheckbox.objectValue as? Bool == true {
      flags += "x"
    }
    if flagSCheckbox.objectValue as? Bool == true {
      flags += "s"
    }
    if flagMCheckbox.objectValue as? Bool == true {
      flags += "m"
    }
    if flagWCheckbox.objectValue as? Bool == true {
      flags += "w"
    }
    
    return flags
  }
  
}
