//
//  WindowController.swift
//  TINOBHNYWE
//
//  Created by Tony Dinh on 5/15/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
  override func windowDidLoad() {
    super.windowDidLoad()
    self.windowFrameAutosaveName = "DevUtils.app"
  }
  func windowDidBecomeMain(_ notification: Notification) {
    self.window?.title = "https://DevUtils.app - Developer Utilities for MacOS \(AppState.getAppVersion())"
  }
}
