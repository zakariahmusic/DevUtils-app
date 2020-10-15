//
//  HTMLPreviewSettingViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 10/4/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class HTMLPreviewOptions: ToolOptions {
  var enableJavaScript: Bool
  var enableNavigation: Bool

  init(enableJavaScript: Bool, enableNavigation: Bool) {
    self.enableJavaScript = enableJavaScript
    self.enableNavigation = enableNavigation
    super.init(autoDetect: false)
  }
}

class HTMLPreviewSettingViewController: ToolSettingViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
  
  override func getOptions() -> ToolOptions {
    return HTMLPreviewOptions.init(
      enableJavaScript: readBool("html-preview-enable-javascript"),
      enableNavigation: readBool("html-preview-enable-navigation")
    )
  }
  
  @IBAction func checkboxAction(_ sender: Any) {
    delegate?.onOptionsChanged(options: getOptions())
  }
  
  @IBAction func resetToDefaultButton(_ sender: Any) {
    ensureDefaults(true)
  }
  
  override func ensureDefaults(_ forceDefaults: Bool = false) {
    AppState.ensureDefault("values.html-preview-enable-javascript", false, forceDefaults)
    AppState.ensureDefault("values.html-preview-enable-navigation", false, forceDefaults)
  }
}
