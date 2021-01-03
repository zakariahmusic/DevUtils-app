//
//  PreferencesViewController.swift
//  TINOBHNYWE
//
//  Created by Tony Dinh on 5/20/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa
import ShortcutRecorder
import SwiftyBeaver

class PreferencesViewController: NSViewController, HotkeyRecorderDelegate {
  @IBOutlet weak var showDockIconCheckbox: NSButton!
  @IBOutlet weak var showStatusIconCheckbox: NSButton!
  @IBOutlet weak var hotkeyRecorder: HotkeyRecorder!
  @IBOutlet weak var launchAtLoginCheckbox: NSButton!
  @IBOutlet weak var automaticClipboardCheckbox: NSButton!
  @IBOutlet weak var writeDebugLogsCheckbox: NSButton!
  @IBOutlet weak var autoUpdateQuestionButton: NSButton!
  @IBOutlet weak var autoUpdateCheckbox: NSButton!
  @IBOutlet weak var autoUpdateIntervalButton: NSPopUpButton!
  @IBOutlet weak var themeOptionView: NSStackView!
  
  struct NotificationNames {
    static let userDefaultsChanged = Notification.Name(rawValue: "userDefaultsChanged")
  }
  
  func hotKeyRecorderDidEndRecording(shortcut: Shortcut) {
    AppState.setGlobalHotkeyPreference(shortcut)
    notifyUserSettingChanged()
  }
  
  @IBAction func writeDebugLogsCheckboxAction(_ sender: Any) {
    AppState.setWriteDebugLog(writeDebugLogsCheckbox.objectValue as? Bool ?? false)
    notifyUserSettingChanged()
  }
  
  @IBAction func openLogsDirButtonAction(_ sender: Any) {
    let file = FileDestination()
    if let url = file.logFileURL {
      NSWorkspace.shared.activateFileViewerSelecting([url])
    }
  }
  
  func hotKeyRecorderValidationFailed(message: String) {
    hotkeyRecorder.setValue(AppState.getGlobalHotkeyPreference())
    let alert = NSAlert()
    alert.messageText = "Conflict global hotkey"
    alert.informativeText = message
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
  }
  
  @IBAction func automaticClipboardCheckboxAction(_ sender: Any) {
    AppState.setAutomaticClipboard(automaticClipboardCheckbox.objectValue as? Bool ?? true)
    notifyUserSettingChanged()
  }
  
  func hotKeyRecorderDidCancelRecording() {
    hotkeyRecorder.setValue(AppState.getGlobalHotkeyPreference())
  }
  
  @IBAction func launchAtLoginAction(_ sender: Any) {
    AppState.setLaunchAtLogin(launchAtLoginCheckbox.objectValue as? Bool ?? false)
    notifyUserSettingChanged()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showDockIconCheckbox.objectValue = AppState.shouldShowDockIcon()
    showStatusIconCheckbox.objectValue = AppState.shouldShowStatusIcon()
    hotkeyRecorder.delegate = self
    hotkeyRecorder.setValue(AppState.getGlobalHotkeyPreference())
    launchAtLoginCheckbox.objectValue = AppState.getLaunchAtLogin()
    automaticClipboardCheckbox.objectValue = AppState.getAutomaticClipboard()
    writeDebugLogsCheckbox.objectValue = AppState.getWriteDebugLog()
    
    #if NO_SPARKLE
    disableSparkleUpdate()
    #endif
    
    if #available(OSX 10.14, *) {
    } else {
      themeOptionView.isHidden = true
    }
  }
  
  func disableSparkleUpdate() {
    autoUpdateQuestionButton.isHidden = false
    autoUpdateCheckbox.isEnabled = false
    autoUpdateIntervalButton.isEnabled = false
  }
  
  @IBAction func autoUpdateQuestionButtonAction(_ sender: Any) {
    let alert = NSAlert()
    alert.messageText = "App installed via \(AppState.getAppBundleName())"
    alert.informativeText = "You are running the app installed and managed by \(AppState.getAppBundleName()). Please check your \(AppState.getAppBundleName()) settings to manage app updates."
    alert.alertStyle = .warning
    alert.addButton(withTitle: "Ok")
    alert.runModal()
  }
  
  @IBAction func showDockIconAction(_ sender: Any) {
    if let value = showDockIconCheckbox.objectValue as? Bool {
      AppState.setDockIconPreference(value)
      notifyUserSettingChanged()
      checkImpossible()
    }
  }
  
  @IBAction func showStatusIconAction(_ sender: Any) {
    if let value = showStatusIconCheckbox.objectValue as? Bool {
      AppState.setStatusIconPreference(value)
      notifyUserSettingChanged()
      checkImpossible()
    }
  }
  
  func checkImpossible() {
    if AppState.shouldShowDockIcon() || AppState.shouldShowStatusIcon() {
      return
    }
    let shortcutString = AppState.getGlobalHotkeyPreference().description
    let alert = NSAlert()
    alert.messageText = "It's difficult!"
    alert.informativeText = "If both Dock Icon and Status Icon are disabled, you can only bring up the app with the hot key \(shortcutString). If you don't remember the hot key, you have to reopen the app in Finder > Applications."
    alert.alertStyle = .warning
    alert.addButton(withTitle: "Understood")
    alert.runModal()
  }
  
  func notifyUserSettingChanged() {
    NotificationCenter.default.post(
      name: PreferencesViewController.NotificationNames.userDefaultsChanged,
      object: nil
    )
  }
  
  @IBAction func serviceHotKeyExplainButtonAction(_ sender: Any) {
    let alert = NSAlert()
    alert.messageText = "Service HotKey"
    alert.informativeText = "Service Hotkey allows you to activate DevUtils with a selected text from anywhere in your macOS. To enable this feature: \n\n" +
      " 1. Open System Preferences > Keyboard > Shortcuts (tab) > Service (on the left sidebar)\n" +
      " 2. Find \"Inspect with DevUtils.app\" item in the list, usually placed under the \"Text\" group.\n" +
      " 3. Check the checkbox to enable it and optionally set your own service hotkey (default is ⌘\\)\n" +
      "\nWith this enabled, you can now select a text from any app and activate DevUtils using the hotkey  ⌘\\ or Right click > Services > Inspect with DevUtils.app."
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Ok")
    alert.runModal()
  }
  
  @IBAction func themeOptionChanged(_ sender: Any) {
    (NSApp.delegate as! AppDelegate).setUserPreferredTheme(force: true)
    NotificationCenter.default.post(
      name: .init(rawValue: "UserPreferenceThemeChangedNotification"),
      object: nil
    )
  }
}
