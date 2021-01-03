//
//  RegexTesterViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 10/28/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class RegexTesterViewController: ToolViewController, NSTextFieldDelegate, NSTextViewDelegate, ToolSettingDelegate {
  @IBOutlet weak var inputTextField: NSTextField!
  @IBOutlet var matchesTextView: CodeTextView!
  @IBOutlet var testTextView: CodeTextView!
  @IBOutlet weak var matchesCountLabel: NSTextField!
  @IBOutlet weak var navBackButton: NSButton!
  @IBOutlet weak var navForwardButton: NSButton!
  @IBOutlet weak var flagsLabel: NSTextField!
  
  var settingViewController: RegexTesterSettingViewController!
  var options: RegexTesterOptions!
  
  var currentRegex: NSRegularExpression?
  var results: [NSTextCheckingResult] = []
  var currentMatchIndex = -1
  var nextMatchMarked = false // indicate that the nearest greater match index is already selected by clicking in the textview
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadOptions()
    if let menlo = NSFont(name: AppState.TEXTVIEW_MONO_FONT, size: 12) {
      inputTextField.font = menlo
      flagsLabel.font = menlo
    }
    matchesTextView.isEditable = false
    updateFlagsLabel()
    updateNavigationState()
    
    if pendingInput != nil {
      activate(input: pendingInput!)
      pendingInput = nil
    }
  }
  
  func textViewDidChangeSelection(_ notification: Notification) {
    log.debug("selection change: \(testTextView.selectedRange())")
    let cursorPosition = testTextView.selectedRange().location
    if results.count == 0 {
      return
    }
    
    currentMatchIndex = results.binarySearch { $0.range.location < cursorPosition }
    nextMatchMarked = true
    log.debug("currentMatchIndex: \(currentMatchIndex)")
  }
  
  @IBAction func settingButtonAction(_ sender: NSButton) {
    loadOptions()
    let popover = NSPopover.init()
    popover.contentSize = .init(width: 300, height: 200)
    popover.behavior = .transient
    popover.animates = true
    popover.contentViewController = settingViewController
    popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
  }
  
  override func activate(input: ActivationValue) {
    super.activate(input: input)
    if !isViewLoaded {
      pendingInput = input
      return
    }
    inputTextField.stringValue = input.value
    refresh()
  }
  
  func onOptionsChanged(options: ToolOptions) {
    self.options = options as? RegexTesterOptions
    refresh()
  }
  
  func loadOptions() {
    if self.settingViewController == nil {
      self.settingViewController = RegexTesterSettingViewController(
        nibName: "RegexTesterSettingViewController"
      )
      self.settingViewController.delegate = self
      self.settingViewController.ensureDefaults()
    }
    self.options = self.settingViewController.getOptions()
  }
  
  @IBAction func clipboardTestDataButtonAction(_ sender: Any) {
    testTextView.setStringRetrainUndo(NSPasteboard.general.string(forType: .string) ?? "")
    refresh()
  }
  
  @IBAction func clearButtonAction(_ sender: Any) {
    inputTextField.stringValue = ""
    testTextView.setStringRetrainUndo("")
  }
  
  @IBAction func clipboardButtonAction(_ sender: Any) {
    inputTextField.stringValue = NSPasteboard.general.string(forType: .string) ?? ""
    refresh()
  }
  
  @IBAction func loadFileButtonAction(_ sender: Any) {
    if let fileContent = GeneralHelpers.loadFileAsUTF8(title: "Select a file") {
      testTextView.string = fileContent
      refresh()
    }
  }
  
  @IBAction func sampleButtonAction(_ sender: Any) {
    inputTextField.stringValue = "([A-Z])\\w+"
    testTextView.setStringRetrainUndo("""
    DevUtils helps you with your tiny daily tasks with just a single click. It works entirely offline and is open source!

    ✈️ Work Offline
    Stop pasting your JSON strings, JWT tokens, or any potentially sensitive data to random websites online. DevUtils.app helps you quickly do your tiny tasks entirely offline! Everything you paste into the app never leaves your machine.
    """)
  }
  
  func controlTextDidChange(_ obj: Notification) {
    refresh()
  }
  
  func refresh() {
    loadOptions()
    currentRegex = nil
    results = []
    currentMatchIndex = -1
    nextMatchMarked = false
    
    updateResults()
    highlightMatches()
    updateMatchesAsText()
    updateNavigationState()
    updateFlagsLabel()
  }
  
  func updateFlagsLabel() {
    flagsLabel.stringValue = options.getFlags()
  }
  
  func updateResults() {
    if inputTextField.stringValue == "" {
      return
    }
    
    let pattern = options.getFlags() + inputTextField.stringValue
    
    do {
      currentRegex = try NSRegularExpression.init(pattern: pattern)
      inputTextField.textColor = .textColor
    } catch {
      log.error("Failed to complie regex: \(error)")
      inputTextField.textColor = .systemRed
      return
    }
    
    guard let r = currentRegex else {
      return
    }
    
    let testString = testTextView.string
    
    results = r.matches(
      in: testString,
      options: [],
      range: testString.fullRange
    )
  }
  
  func updateNavigationState() {
    if results.count == 0 {
      navBackButton.isEnabled = false
      navForwardButton.isEnabled = false
    } else {
      navBackButton.isEnabled = true
      navForwardButton.isEnabled = true
    }
  }
  
  func clearHighlights() {
    let allOfIt = testTextView.string.fullRange
    testTextView.textStorage?.removeAttribute(.backgroundColor, range: allOfIt)
    testTextView.textStorage?.addAttributes(
      [
        NSAttributedString.Key.foregroundColor: NSColor.textColor
      ],
      range: allOfIt
    )
  }
  
  func highlightMatches() {
    clearHighlights()
    matchesCountLabel.stringValue = "\(results.count) match\(results.count == 1 ? "" : "es")"
    
    for result in results {
      testTextView.textStorage?.addAttributes(
        [
          NSAttributedString.Key.backgroundColor: NSColor.systemGreen,
          NSAttributedString.Key.foregroundColor: NSColor.black,
        ],
        range: result.range
      )
    }
  }
  
  func updateMatchesAsText() {
    matchesTextView.string = ""
    var string: [String] = []
    for result in results {
      string.append((testTextView.string as NSString).substring(with: result.range))
    }
    matchesTextView.string = string.joined(separator: "\n")
  }
  
  func textDidChange(_ notification: Notification) {
    refresh()
  }
  
  @IBAction func navBackButtonAction(_ sender: Any) {
    if currentMatchIndex > 0 {
      currentMatchIndex -= 1
    }
    focusCurrentMatch()
  }
  
  @IBAction func navForwardButtonAction(_ sender: Any) {
    if !nextMatchMarked && currentMatchIndex < results.count - 1{
      currentMatchIndex += 1
    }
    focusCurrentMatch()
  }
  
  func focusCurrentMatch() {
    guard let result = results[safe: currentMatchIndex] else {
      return
    }
    testTextView.scrollRangeToVisible(result.range)
    testTextView.showFindIndicator(for: result.range)
    nextMatchMarked = false
  }
  
  @IBAction func copyButtonAction(_ sender: Any) {
    matchesTextView.copyToClipboard()
  }
}
