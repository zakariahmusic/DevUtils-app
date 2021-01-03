//
//  AboutWindowViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/13/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class AboutWindowViewController: NSViewController {
  @IBOutlet weak var versionLabel: NSTextField!
  @IBOutlet weak var copyrightLabel: NSTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy"
    let formattedDate = format.string(from: date)
    versionLabel.stringValue = "Version \(AppState.getAppVersion()) via \(AppState.getAppBundleName())"
    copyrightLabel.stringValue = "© \(formattedDate) DevUtils Team"
  }
  
  @IBAction func ackButtonAction(_ sender: Any) {
    (NSApp.delegate as? AppDelegate)?.ackButtonAction(sender)
  }
  @IBAction func releaseNotesButtonAction(_ sender: Any) {
    (NSApp.delegate as? AppDelegate)?.releaseNotesMenuAction(sender)
  }
  @IBAction func sendFeedbackButtonAction(_ sender: Any) {
    (NSApp.delegate as? AppDelegate)?.sendFeedback(sender)
  }
  @IBAction func followOnTwitterButtonAction(_ sender: Any) {
    (NSApp.delegate as? AppDelegate)?.followOnTwitter(sender)
  }
  @IBAction func visitWebsiteButtonAction(_ sender: Any) {
    (NSApp.delegate as? AppDelegate)?.visitWebsite(sender)
  }
}
