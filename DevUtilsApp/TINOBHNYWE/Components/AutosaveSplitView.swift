//
//  AutosaveSplitView.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/4/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class AutosaveSplitView: NSSplitView {
  override func viewDidMoveToWindow() {
    if (self.identifier?.rawValue ?? "").count == 0 {
      log.warning("AutosaveSplitView with no identifier!")
    }
    self.autosaveName = self.identifier?.rawValue
  }
}
