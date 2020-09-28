//
//  JSONFormatterViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 5/23/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa
import JavaScriptCore

class JSONFormatterViewController: ToolViewController, NSTextViewDelegate {
  @IBOutlet weak var optionPopUpButton: NSPopUpButton!
  @IBOutlet var inputTextView: NSTextView!
  @IBOutlet var outputTextView: JSONTextView!
  
  var settingViewController: JSONFormatterSettingViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
    inputTextView.setMonoFont()
    inputTextView.nicePadding()
    inputTextView.usesFindBar = true
    outputTextView.nicePadding()
    outputTextView.setMonoFont()
    outputTextView.usesFindBar = true
    JSONFormatterViewController.ensureDefaults()
    if pendingInput != nil {
      activate(input: pendingInput!)
      pendingInput = nil
    }
  }
  
  override func activate(input: ActivationValue) {
    super.activate(input: input)
    if !isViewLoaded {
      pendingInput = input
      return
    }
    
    log.debug("JSON tool activated: \(input)")
    inputTextView.string = input.value
    refresh()
  }
  
  override func matchInput(input: String) -> Bool {
    guard let autoActivate = NSUserDefaultsController.shared.value(
      forKeyPath: "values.json-formatter-auto-activate-valid-json") as? Bool else {
        log.debug("JSONFormatter auto activate setting not set!")
        return false
    }
    
    if !autoActivate {
      log.debug("JSONFormatter auto activate disabled")
      return false
    }
    
    guard let jsonData = input.data(using: .utf8) else {
      log.debug("JSONFormatter decode the input string")
      return false
    }
    
    do {
      try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments])
    } catch {
      log.debug("JSONFormatter cannot json deserialize the string: \(error)")
      return false
    }
    
    log.debug("JSONFormatter auto activated")
    return true
  }
  
  override func ensureDefault(_ forceDefaults: Bool = false) {
    JSONFormatterViewController.ensureDefaults(forceDefaults)
  }
  
  static func ensureDefaults(_ forceDefaults: Bool = false) {
    AppState.ensureDefault("values.json-formatter-auto-activate-valid-json", true, forceDefaults)
  }
  
  @IBAction func settingButtonAction(_ sender: NSButton) {
    if settingViewController == nil {
      settingViewController = JSONFormatterSettingViewController(
        nibName: "JSONFormatterSettingViewController"
      )
    }
    
    let popover = NSPopover.init()
    popover.contentSize = .init(width: 300, height: 200)
    popover.behavior = .transient
    popover.animates = true
    popover.contentViewController = settingViewController
    popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
  }
  
  @IBAction func clipboardButtonAction(_ sender: Any) {
    inputTextView.setStringRetrainUndo(NSPasteboard.general.string(forType: .string) ?? "")
    refresh()
  }
  
  @IBAction func loadFileButtonAction(_ sender: Any) {
    let dialog = NSOpenPanel();
    
    dialog.title                   = "Select a JSON file"
    dialog.showsResizeIndicator    = true
    dialog.showsHiddenFiles        = true
    dialog.canChooseDirectories    = true
    dialog.canCreateDirectories    = false
    dialog.allowsMultipleSelection = false
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      if let url = dialog.url {
        do {
          inputTextView.string = try String(contentsOf: url, encoding: .utf8)
          refresh()
        } catch {
          let alert = NSAlert()
          alert.messageText = "Cannot read the file."
          alert.informativeText = "The file cannot be read because of this reason: " + error.localizedDescription
          alert.alertStyle = .warning
          alert.addButton(withTitle: "OK")
          alert.runModal()
        }
      }
    } else {
      // User clicked on "Cancel"
      return
    }
  }
  
  @IBAction func copyButtonAction(_ sender: Any) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(outputTextView.string, forType: .string)
  }
  
  func textDidChange(_ notification: Notification) {
    refresh()
  }
  
  func refresh() {
    if inputTextView.string == "" {
      outputTextView.string = ""
      return
    }
    var format: Any! = nil
    if optionPopUpButton.titleOfSelectedItem == "4 spaces" {
      format = 4
    } else if optionPopUpButton.titleOfSelectedItem == "2 spaces" {
      format = 2
    } else if optionPopUpButton.titleOfSelectedItem == "1 tab" {
      format = "\t"
    }
    
    outputTextView.setJSONString(inputTextView.string, format)
  }
  
  @IBAction func optionPopUpButtonAction(_ sender: Any) {
    refresh()
  }
  
  @IBAction func sampleButtonAction(_ sender: Any) {
    inputTextView.setStringRetrainUndo("""
    {"store":{"book":[{"category":"reference", "sold": false,"author":"Nigel Rees","title":"Sayings of the Century","price":8.95},{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":12.99},{"category":"fiction","author":"J. R. R. Tolkien","title":"The Lord of the Rings","act": null, "isbn":"0-395-19395-8","price":22.99}],"bicycle":{"color":"red","price":19.95}}}
    """)
    refresh()
  }
  
  @IBAction func clearButtonAction(_ sender: Any) {
    inputTextView.setStringRetrainUndo("")
    refresh()
  }
  
}
