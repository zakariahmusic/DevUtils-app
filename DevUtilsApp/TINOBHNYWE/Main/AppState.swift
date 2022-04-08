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
  static let TEXTVIEW_MONO_FONT = "Menlo"
  
  static var UnixTimeTool = Tool.init(
    id: "unixtime",
    name: "Unix Time Converter",
    image: NSImage(named: "clock.fill")!,
    viewControllerType: UnixTimeViewController.self
  )
  static var JSONFormatterTool = Tool.init(
    id: "jsonformatter",
    name: "JSON Format/Validate",
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
    name: "Query String to JSON",
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
  
  static var UUIDTool = Tool.init(
    id: "uuidtool",
    name: "UUID Generate/Decode",
    image: NSImage(named: "uuid")!,
    viewControllerType: UUIDToolViewController.self
  )
  
  static var HTMLPreviewTool = Tool.init(
    id: "htmlpreview",
    name: "HTML Preview",
    image: NSImage(named: "htmltag")!,
    viewControllerType: HTMLPreviewViewController.self
  )
  
  static var TextDiffTool = Tool.init(
    id: "textdiff",
    name: "Text Diff Checker",
    image: NSImage(named: "textdiff")!,
    viewControllerType: TextDiffViewController.self
  )
  
  static var HTMLBeautifierTool = Tool.init(
    id: "htmlformatter",
    name: "HTML Beautify/Minify",
    image: NSImage(named: "magic")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: HTMLFormatterTool.self
  )
  
  static var CSSBeautifierTool = Tool.init(
    id: "cssformatter",
    name: "CSS Beautify/Minify",
    image: NSImage(named: "magic")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: CSSFormatterTool.self
  )
  
//  static var LESSBeautifierTool = Tool.init(
//    id: "lessformatter",
//    name: "LESS Beautifier/Minifier",
//    image: NSImage(named: "magic")!,
//    viewControllerType: SharedFormatterViewController.self,
//    implementation: LESSFormatterTool.self
//  )
//
//  static var SCSSBeautifierTool = Tool.init(
//    id: "scssformatter",
//    name: "SCSS Beautifier/Minifier",
//    image: NSImage(named: "magic")!,
//    viewControllerType: SharedFormatterViewController.self,
//    implementation: SCSSFormatterTool.self
//  )
  
  static var JSBeautifierTool = Tool.init(
    id: "jsformatter",
    name: "JS Beautify/Minify",
    image: NSImage(named: "magic")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: JSFormatterTool.self
  )
  
  static var XMLBeautifierTool = Tool.init(
    id: "xmlformatter",
    name: "XML Beautify/Minify",
    image: NSImage(named: "magic")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: XMLFormatterTool.self
  )
  
//  static var ERBBeautifierTool = Tool.init(
//    id: "erbformatter",
//    name: "ERB (Ruby) Beautifier/Minifier",
//    image: NSImage(named: "magic")!,
//    viewControllerType: SharedFormatterViewController.self,
//    implementation: ERBFormatterTool.self
//  )
  
  static var RegexTesterTool = Tool.init(
    id: "regextester",
    name: "RegExp Tester",
    image: NSImage(named: "regex")!,
    viewControllerType: RegexTesterViewController.self
  )
  
  static var YAML2JSONTool = Tool.init(
    id: "yaml2json",
    name: "YAML to JSON",
    image: NSImage(named: "convert")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: YAML2JSONConverterTool.self
  )
  
  static var JSON2YAMLTool = Tool.init(
    id: "json2yaml",
    name: "JSON to YAML",
    image: NSImage(named: "convert")!,
    viewControllerType: SharedFormatterViewController.self,
    implementation: JSON2YAMLConverterTool.self
  )
  
  static var NumberBaseTool = Tool.init(
    id: "numberbase",
    name: "Number Base Converter",
    image: NSImage(named: "binary")!,
    viewControllerType: NumberBaseViewController.self
  )
  
  static var tools: [Tool] = [
    UnixTimeTool,
    JSONFormatterTool,
    JWTTool,
    RegexTesterTool,
    URLEncodeTool,
    Base64EncodeTool,
    QueryStringParserTool,
    HTMLEncodeTool,
    BackslashTool,
    UUIDTool,
    HTMLPreviewTool,
    TextDiffTool,
    YAML2JSONTool,
    JSON2YAMLTool,
    NumberBaseTool,
    HTMLBeautifierTool,
    CSSBeautifierTool,
    JSBeautifierTool,
    //    ERBBeautifierTool,
    //    LESSBeautifierTool,
    //    SCSSBeautifierTool
    XMLBeautifierTool
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
  
  static func getToolsSortOrder() -> String {
    return UserDefaults.standard.value(forKey: "tools-sort-order") as? String ?? "default"
  }
  
  static func setToolsSortOrder(_ value: String) {
    UserDefaults.standard.set(value, forKey: "tools-sort-order")
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
  
  static func getSetting(_ keyPath: String, defaultValue: Bool = false) -> Bool {
    return UserDefaults.standard.value(forKey: keyPath) as? Bool ?? defaultValue
  }
  
  static func getSetting(_ keyPath: String, defaultValue: String = "") -> String {
    return UserDefaults.standard.value(forKey: keyPath) as? String ?? defaultValue
  }
  
  static func getSetting(_ keyPath: String, defaultValue: Int = 0) -> Int {
    return UserDefaults.standard.value(forKey: keyPath) as? Int ?? defaultValue
  }
  
  static func getAppVersion() -> String {
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    return "\(versionNumber) (\(buildNumber)\(getAppBundleCode()))"
  }
  
  static func ensureAppDefaults() {
    ensureDefault("values.auto-use-clipboard-content-when-activate", true, false)
    ensureDefault("values.auto-clipboard-global-hotkey", true, false)
    ensureDefault("values.auto-clipboard-status-bar-icon", true, false)
    ensureDefault("values.app-settings-theme", "System", false)
    ensureDefault("values.app-settings-text-view-show-line-numbers", true, false)
    ensureDefault("values.app-settings-text-view-wrap-lines", true, false)
  }
  
  static func getAutoClipboardGlobalHotKey() -> Bool {
    return NSUserDefaultsController.shared.value(
      forKeyPath: "values.auto-clipboard-global-hotkey") as? Bool ?? true
  }
  
  static func getUserPreferredTheme() -> String {
    return NSUserDefaultsController.shared.value(
      forKeyPath: "values.app-settings-theme") as? String ?? "System"
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
  
  static func isSandboxed() -> Bool {
      let environ = ProcessInfo.processInfo.environment
      return (nil != environ["APP_SANDBOX_CONTAINER_ID"])
  }
  
  static func getOrderedNames() -> [String]? {
    return UserDefaults.standard.value(forKey: "custom-tools-ordered-names") as? [String]
  }
  
  static func setOrderedNames(_ value: [String]) {
    UserDefaults.standard.set(value, forKey: "custom-tools-ordered-names")
  }
  
  static func getAppBundleName() -> String {
    var bundleName = "devutils.app"
    #if BUNDLE_APPSTORE
    bundleName = "App Store"
    #elseif BUNDLE_SETAPP
    bundleName = "Setapp"
    #endif
    
    return bundleName
  }
  static func getAppBundleCode() -> String {
    var bundleName = "D"
    #if BUNDLE_APPSTORE
    bundleName = "A"
    #elseif BUNDLE_SETAPP
    bundleName = "S"
    #endif
    
    return bundleName
  }
}
