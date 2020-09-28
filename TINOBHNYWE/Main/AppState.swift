//
//  AppState.swift
//  TINOBHNYWE
//
//  Created by Tony Dinh on 5/16/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa
import ShortcutRecorder

let DEFAULT_GLOBAL_HOTKEY = Shortcut.init(keyEquivalent: "⌃⌥⌘Space")! // Ctrl + Option + Command + Space

class ActivationValue: CustomStringConvertible {
  enum Source {
    case clipboard
    case service
    case manual
  }
  
  let value: String
  let source: Source
  var description: String {
    return "(\(source)): \(value)"
  }
  
  init(value: String, source: Source) {
    self.value = value
    self.source = source
  }
}

class AppState {
  static var UnixTimeTool = Tool.init(
    id: "unixtime",
    name: "Unix Time Converter",
    image: NSImage(named: "clock.fill")!,
    viewControllerType: UnixTimeViewController.self
  )
//  static var URLEncodeTool = Tool.init(
//    id: "urlencode",
//    name: "URL Encode/Decode",
//    image: NSImage(named: "percent")!,
//    viewControllerType: URLEncodeViewController.self
//  )
  static var JSONFormatterTool = Tool.init(
    id: "jsonformatter",
    name: "JSON Formatter/Validator",
    image: NSImage(named: "jsonformatter")!,
    viewControllerType: JSONFormatterViewController.self
  )
  static var JWTTool = Tool.init(
    id: "jwt",
    name: "JWT Debugger",
    image: NSImage(named: "jwt")!,
    viewControllerType: JWTViewController.self
  )
  static var QueryStringParserTool = Tool.init(
    id: "querystringparser",
    name: "Query String Parser",
    image: NSImage(named: "querystring")!,
    viewControllerType: QueryStringParserViewController.self
  )
  static var HTMLEncodeTool = Tool.init(
    id: "htmlencode",
    name: "HTML Entity Encode/Decode",
    image: NSImage(named: "htmlentities")!,
    viewControllerType: SharedEndecodeViewController.self,
    implementation: HTMLEntityEndecodeTool.self,
    settingViewControllerType: HTMLEntitySettingViewController.self
  )
  static var Base64EncodeTool = Tool.init(
    id: "base64encode",
    name: "Base64 Encode/Decode",
    image: NSImage(named: "base64")!,
    viewControllerType: SharedEndecodeViewController.self,
    implementation: Base64EndecodeTool.self,
    settingViewControllerType: Base64SettingViewController.self
  )
  static var URLEncodeTool = Tool.init(
    id: "urlencode",
    name: "URL Encode/Decode",
    image: NSImage(named: "percent")!,
    viewControllerType: SharedEndecodeViewController.self,
    implementation: URLEndecodeTool.self,
    settingViewControllerType: URLEncodeSettingViewController.self
  )
  static var BackslashTool = Tool.init(
    id: "backslash",
    name: "Backslash Escape/Unescape",
    image: NSImage(named: "backslash")!,
    viewControllerType: SharedEndecodeViewController.self,
    implementation: BackslashEscapeTool.self,
    settingViewControllerType: BackslashEscapeSettingViewController.self
  )
  
  static var tools: [Tool] = [
    UnixTimeTool,
    URLEncodeTool,
    JSONFormatterTool,
    JWTTool,
    Base64EncodeTool,
    QueryStringParserTool,
    HTMLEncodeTool,
    BackslashTool
  ]

  static func shouldShowDockIcon() -> Bool {
    return UserDefaults.standard.value(forKey: "show-dock-icon") as? Bool ?? true
  }
  
  static func shouldShowStatusIcon() -> Bool {
    return UserDefaults.standard.value(forKey: "show-status-icon") as? Bool ?? true
  }

  static func setLaunchAtLogin(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "launch-at-login")
  }
  
  static func getLaunchAtLogin() -> Bool {
     return UserDefaults.standard.value(forKey: "launch-at-login") as? Bool ?? false
  }
  
  static func setDockIconPreference(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "show-dock-icon")
  }
  
  static func setStatusIconPreference(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "show-status-icon")
  }
  
  static func getWriteDebugLog() -> Bool {
    return UserDefaults.standard.value(forKey: "write-debug-logs") as? Bool ?? false
  }
  
  static func setWriteDebugLog(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "write-debug-logs")
  }
  
  static func getGlobalHotkeyPreference() -> Shortcut {
    if let dictionary = UserDefaults.standard.value(forKey: "global-hotkey") as? [AnyHashable : Any] {
      return Shortcut.init(dictionary: dictionary) ?? DEFAULT_GLOBAL_HOTKEY
    }
    return DEFAULT_GLOBAL_HOTKEY
  }
  
  static func setGlobalHotkeyPreference(_ shortcut: Shortcut) {
    UserDefaults.standard.set(shortcut.dictionaryRepresentation, forKey: "global-hotkey")
  }
  
  static func getAppVersion() -> String {
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    if let versionNumber = versionNumber, let buildNumber = buildNumber {
      return "\(versionNumber) (\(buildNumber))"
    } else if let versionNumber = versionNumber {
      return versionNumber
    } else if let buildNumber = buildNumber {
      return buildNumber
    } else {
      return ""
    }
  }
  
  static func ensureDefaultsForAutoDetect() {
    ensureDefault("values.auto-use-clipboard-content-when-activate", true, false)
    ensureDefault("values.auto-clipboard-global-hotkey", true, false)
    ensureDefault("values.auto-clipboard-status-bar-icon", true, false)
  }
  
  static func getAutoClipboardGlobalHotKey() -> Bool {
    return NSUserDefaultsController.shared.value(
      forKeyPath: "values.auto-clipboard-global-hotkey") as? Bool ?? true
  }
  
  static func getAutoClipboardStatusBarIcon() -> Bool {
    return NSUserDefaultsController.shared.value(
      forKeyPath: "values.auto-clipboard-status-bar-icon") as? Bool ?? true
  }
  
  static func setAutomaticClipboard(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "automatic-clipboard")
  }
  
  static func getAutomaticClipboard() -> Bool {
    return UserDefaults.standard.value(forKey: "automatic-clipboard") as? Bool ?? true
  }
  
  static func ensureDefault(_ keyPath: String, _ defaultValue: Bool, _ force: Bool) {
    let value = NSUserDefaultsController.shared.value(
      forKeyPath: keyPath) as? Bool
    
    if value == nil || force {
      NSUserDefaultsController.shared.setValue(
        defaultValue, forKeyPath: keyPath)
    }
  }
  
  static func ensureDefault(_ keyPath: String, _ defaultValue: Int, _ force: Bool) {
    let value = NSUserDefaultsController.shared.value(
      forKeyPath: keyPath) as? Int
    
    if value == nil || force {
      NSUserDefaultsController.shared.setValue(
        defaultValue, forKeyPath: keyPath)
    }
  }
  
  static func ensureDefault(_ keyPath: String, _ defaultValue: String, _ force: Bool) {
    let value = NSUserDefaultsController.shared.value(
      forKeyPath: keyPath) as? String
    
    if value == nil || force {
      NSUserDefaultsController.shared.setValue(
        defaultValue, forKeyPath: keyPath)
    }
  }
}
