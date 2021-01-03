//
//  TestViewController.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/6/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class TestViewController: NSViewController {
  @IBOutlet var textView: NSTextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
    textView.enclosingScrollView?.hasVerticalRuler = true
  }
  
  @IBAction func onAction(_ sender: Any) {
    textView.enclosingScrollView?.rulersVisible = true
  }
  @IBAction func offAction(_ sender: Any) {
    textView.enclosingScrollView?.rulersVisible = false
  }
  
  @IBAction func sizeAction(_ sender: Any) {
    log.debug("scroll view content size \(textView.enclosingScrollView?.contentSize)")
    log.debug("textview container size \(textView.textContainer?.containerSize)")
    
    textView.refreshFrame()
    log.debug(textView.frame)
  }
}
