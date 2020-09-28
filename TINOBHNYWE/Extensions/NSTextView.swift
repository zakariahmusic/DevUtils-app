//
//  NSTextView.swift
//  DevUtils
//
//  Created by Tony Dinh on 5/25/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

extension NSTextView {
  func setMonoFont() {
    if let menlo = NSFont(name: "Menlo", size: 12) {
      self.typingAttributes = [
        NSAttributedString.Key.font: menlo,
        NSAttributedString.Key.foregroundColor: NSColor.textColor
      ]
    }
  }
  
  func nicePadding() {
    self.textContainerInset = .init(width: 3, height: 8)
  }
  
  func setStringRetrainUndo(_ value: String) {
    self.selectAll(self)
    self.insertText(
      value,
      replacementRange: .init(location: 0, length: self.string.count)
    )
  }
}
