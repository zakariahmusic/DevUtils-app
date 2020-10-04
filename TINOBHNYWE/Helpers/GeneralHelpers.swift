//
//  GeneralHelpers.swift
//  DevUtils
//
//  Created by Tony Dinh on 9/29/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class GeneralHelpers {
  static func confirm(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == .alertFirstButtonReturn
  }
  
  static func alert(title: String, text: String) {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
  }
}
