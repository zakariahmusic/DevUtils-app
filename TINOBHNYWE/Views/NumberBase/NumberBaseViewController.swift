//
//  NumberBaseViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/8/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class NumberBaseViewController: ToolViewController, NSTextFieldDelegate, InputOutputTextFieldDelegate {
  @IBOutlet weak var selectBaseMenu: NSMenu!
  @IBOutlet weak var base2TextField: InputOutputTextField!
  @IBOutlet weak var base8TextField: InputOutputTextField!
  @IBOutlet weak var base10TextField: InputOutputTextField!
  @IBOutlet weak var base16TextField: InputOutputTextField!
  @IBOutlet weak var baseAnyTextField: NSTextField!
  @IBOutlet weak var selectBasePopUpButton: NSPopUpButton!
  
  var lastUsedBase: Int?
  var lastSender: NSTextField?
  var IAmSure = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    base2TextField.textField.delegate = self
    base8TextField.textField.delegate = self
    base10TextField.textField.delegate = self
    base16TextField.textField.delegate = self
    base2TextField.inputOutputTextFieldDelegate = self
    base8TextField.inputOutputTextFieldDelegate = self
    base10TextField.inputOutputTextFieldDelegate = self
    base16TextField.inputOutputTextFieldDelegate = self
    
    baseAnyTextField.delegate = self
    
    for i in 2...36 {
      let editMenuItem = NSMenuItem()
      editMenuItem.title = "\(i)"
      selectBaseMenu.addItem(editMenuItem)
    }
    
    let savedSelectionIndex = AppState.getSetting("number-base-settings-selected-base-index", defaultValue: 0)
    selectBasePopUpButton.selectItem(at: savedSelectionIndex)
  }
  
  func textUpdatedByAction(_ sender: NSTextField) {
    handleTextChange(sender)
  }
  
  func controlTextDidChange(_ obj: Notification) {
    guard let sender = obj.object as? NSTextField else {
      log.error("unknown sender")
      return
    }
    handleTextChange(sender)
  }
  
  func handleTextChange(_ sender: NSTextField) {
    var base: Int?

    if sender == base2TextField.textField {
      base = 2
    } else if sender == base8TextField.textField {
      base = 8
    } else if sender == base10TextField.textField {
      base = 10
    } else if sender == base16TextField.textField {
      base = 16
    } else if sender == baseAnyTextField {
      base = getSelectedBase()
    } else {
      log.error("malformed notification!")
    }
    
    if base == nil {
      return
    }
    
    refresh(base!, sender: sender)
  }
  
  func getSelectedBase() -> Int {
    return Int(selectBasePopUpButton.selectedItem?.title ?? "0") ?? 0
  }
  
  // If no parameter provided, we reuse the lastUsedBase and lastSender (useful for when user change "Select base")
  // If base and sender are set, we set that as the lastUsedBase and lastSender
  func refresh(_ base: Int? = nil, sender: NSTextField? = nil) {
    
    if base != nil {
      lastUsedBase = base
    }
    
    if sender != nil {
      lastSender = sender
    }
    
    guard let base = lastUsedBase else {
      return
    }
    
    guard let sender = lastSender else {
      return
    }
    
    if base >= 10 && sender.stringValue.count > 3000 && !IAmSure { // just an arbitary choice
      IAmSure = GeneralHelpers.confirm(question: "That's a big number!", text: """
      Compute big numbers may take a long time, depends on how good your machine is.

      Are you sure?
      """)
      
      if !IAmSure {
        return
      }
    }
    
    base2TextField.textField.backgroundColor = .textBackgroundColor
    base8TextField.textField.backgroundColor = .textBackgroundColor
    base10TextField.textField.backgroundColor = .textBackgroundColor
    base16TextField.textField.backgroundColor = .textBackgroundColor
    baseAnyTextField.backgroundColor = .textBackgroundColor

    if sender.stringValue == "" {
      clearAll()
      return
    }
    
    var stringValue = sender.stringValue
    
    if base == 16 && stringValue.starts(with: "0x") {
      stringValue = String(stringValue.dropFirst(2))
    }
    if base == 2 && stringValue.starts(with: "0b") {
      stringValue = String(stringValue.dropFirst(2))
    }
    
    guard let value = BigNumberAdapter.init(stringValue, radix: base) else {
      sender.backgroundColor = .systemRed
      return
    }
    
    base2TextField.textField.stringValue = value.asString(radix: 2)
    base8TextField.textField.stringValue = value.asString(radix: 8)
    base10TextField.textField.stringValue = value.asString(radix: 10)
    base16TextField.textField.stringValue = value.asString(radix: 16)
    baseAnyTextField.stringValue = value.asString(radix: getSelectedBase())
  }
  
  func clearAll() {
    base2TextField.textField.stringValue = ""
    base8TextField.textField.stringValue = ""
    base10TextField.textField.stringValue = ""
    base16TextField.textField.stringValue = ""
    baseAnyTextField.stringValue = ""
  }
  
  @IBAction func selectBasePopUpButtonAction(_ sender: Any) {
    /** This is to ensure user can change the number base without changing the input previously entered.
     Expected behavior:
     - User change any other text field -> change between bases in the popup button: the baseAnyTextField's value changed.
     - User change the baseAnyTextField's value -> change between bases in the popup button: keep the baseAnyTextField's value and change other values
    **/
    if lastSender == baseAnyTextField {
      refresh(getSelectedBase(), sender: baseAnyTextField)
    } else {
      refresh()
    }
  }
  
  @IBAction func clearButtonAction(_ sender: Any) {
    baseAnyTextField.stringValue = ""
    refresh()
  }
  
  @IBAction func clipboardButtonAction(_ sender: Any) {
    baseAnyTextField.stringValue = NSPasteboard.general.string(forType: .string) ?? ""
    refresh(getSelectedBase(), sender: baseAnyTextField)
  }
  
  @IBAction func copyButtonAction(_ sender: Any) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(baseAnyTextField.stringValue, forType: .string)
  }
}
