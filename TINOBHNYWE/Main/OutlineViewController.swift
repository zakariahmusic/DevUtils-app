//
//  OutlineViewController.swift
//  TINOBHNYWE
//
//  Created by Tony Dinh on 5/16/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class OutlineViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
  
  class State {
    var selectedTool: Tool?
    var matchedTools: [Tool]
    
    init(selectedTool: Tool?, matchedTools: [Tool]) {
      self.selectedTool = selectedTool
      self.matchedTools = matchedTools
    }
    
    static func emptyState() -> State {
      return State.init(selectedTool: nil, matchedTools: [])
    }
  }
  
  @IBOutlet weak var outlineView: NSOutlineView!
  @IBOutlet weak var outlineScrollView: NSScrollView!
  @IBOutlet weak var versionLabel: NSTextField!
  
  var enableNotificationOnChange: Bool = true
  var state = State.emptyState()
  
  struct NotificationNames {
    static let selectionChanged = "selectionChangedNotification"
    static let stateChanged = "stateChangedNotification"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    outlineScrollView.backgroundColor = NSColor.clear
    outlineView.backgroundColor = NSColor.clear
    versionLabel.stringValue = """
    Developer Utilities for macOS \(AppState.getAppVersion())
    https://DevUtils.app
    """

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleStateChanged(_:)),
      name: Notification.Name(OutlineViewController.NotificationNames.stateChanged),
      object: nil)
  }
  
  @objc
  func handleStateChanged(_ notification: Notification) {
    // Assuming selectRowIndexes triggers the delegate synchronously
    enableNotificationOnChange = false
    defer {
      enableNotificationOnChange = true
    }
    
    guard let newState = notification.object as? State else {
      log.debug("stateChanged event sent without a state object!")
      return
    }
    
    self.state = newState
    
    for tool in state.matchedTools {
      log.debug("showing matched icon for \(tool.id)")
    }
    
    guard
      let selectedTool = self.state.selectedTool,
      let index = AppState.tools.firstIndex(of: selectedTool) else {
        outlineView.deselectAll(self)
        return
    }
    
    outlineView.reloadData()
    
    // Select row index must come after reload data!
    outlineView.selectRowIndexes(.init(integer: index), byExtendingSelection: false)
  }
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return AppState.tools.count
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return AppState.tools[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    return 24
  }
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: ToolOutlineTableCellView?
    view = outlineView.makeView(
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"),
      owner: self
    ) as? ToolOutlineTableCellView
    
    guard let tool = item as? Tool else {
      log.debug("outlineView called without an item")
      return nil
    }
    
    if let textField = view?.textField {
      textField.stringValue = tool.name
    }
    
    if let imageView = view?.imageView {
      imageView.image = tool.image
      imageView.imageScaling = .scaleProportionallyUpOrDown
    }
    
    if let statusImageView = view?.statusImageView {
      if self.state.matchedTools.firstIndex(of: tool) != nil {
        statusImageView.isHidden = false
      } else {
        statusImageView.isHidden = true
      }
    }
    return view
  }
  
  func outlineViewSelectionDidChange(_ notification: Notification) {
    if !enableNotificationOnChange {
      return
    }
    
    guard let outlineView = notification.object as? NSOutlineView else {
      return
    }
    let selectedIndex = outlineView.selectedRow
    NotificationCenter.default.post(
      name: Notification.Name(
        OutlineViewController.NotificationNames.selectionChanged
      ),
      object: outlineView.item(atRow: selectedIndex)
    )
  }
  
  @IBAction func sendFeedbackButtonAction(_ sender: Any) {
    let emailUrl = URL(string: "mailto:feedback@devutils.app?subject=Feedback%20for%20DevUtils.app")!
    
    if NSWorkspace.shared.open(emailUrl) {
      log.debug("Email client opened")
    } else {
      log.debug("Email client cannot be opened")
    }
  }
}
