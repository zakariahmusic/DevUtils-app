//
//  InputOutputTextField.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/11/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa


public protocol InputOutputTextFieldDelegate {
  func textUpdatedByAction(_ sender: NSTextField)
}

class InputOutputTextField: CustomView {
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var label: NSTextField!
  
  @IBInspectable var labelString: String?
  @IBInspectable var placeholderString: String?
  
  var inputOutputTextFieldDelegate: InputOutputTextFieldDelegate?
  
  override func layout() {
    super.layout()
    label.stringValue = labelString ?? "Input:"
    textField.placeholderString = placeholderString ?? ""
  }
  
  @IBAction func copyButtonAction(_ sender: Any) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(textField.stringValue, forType: .string)
  }
  
  @IBAction func clearButtonAction(_ sender: Any) {
    textField.stringValue = ""
    inputOutputTextFieldDelegate?.textUpdatedByAction(textField)
    textField.becomeFirstResponder()
  }
  
  @IBAction func clipboardButtonAction(_ sender: Any) {
    textField.stringValue = NSPasteboard.general.string(forType: .string) ?? ""
    inputOutputTextFieldDelegate?.textUpdatedByAction(textField)
    textField.becomeFirstResponder()
  }
}
