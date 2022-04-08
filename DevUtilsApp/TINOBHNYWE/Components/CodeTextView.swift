//
//  CodeTextView.swift
//  DevUtils
//
//  Created by Tony Dinh on 10/11/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//
//  TODO: too many weird layout bugs and crashes with line numbers. Just disable it for now

import Cocoa

var wrapLineChangedContext = 0
//var lineNumbersChangedContext = 0

class CodeTextView: NSTextView {
  var loaded = false
  
//  override var string: String {
//    didSet {
//      refreshLineNumberView()
//    }
//  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    UserDefaults.standard.addObserver(self, forKeyPath: "app-settings-text-view-wrap-lines", options: .new, context: &wrapLineChangedContext)
//    UserDefaults.standard.addObserver(self, forKeyPath: "app-settings-text-view-show-line-numbers", options: .new, context: &lineNumbersChangedContext)
  }
  
  deinit {
    UserDefaults.standard.removeObserver(self, forKeyPath: "app-settings-text-view-wrap-lines", context: &wrapLineChangedContext)
//    UserDefaults.standard.removeObserver(self, forKeyPath: "app-settings-text-view-show-line-numbers", context: &lineNumbersChangedContext)
  }

  func setWordWrap(wordwrap: Bool) {
    let scrollView = self.enclosingScrollView!
    self.minSize = CGSize(width: 0, height: 0)
    self.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

    if wordwrap {
      let sz1 = scrollView.contentSize
      self.textContainer!.containerSize = CGSize(width: sz1.width, height: CGFloat.greatestFiniteMagnitude)
      self.textContainer!.widthTracksTextView = true
      // self.frame must be set after self.textContainer!.containerSize, otherwise layout won't be updated sometime
      self.frame = CGRect(x: 0, y: 0, width: sz1.width, height: 0)
      self.isHorizontallyResizable = false
      scrollView.hasHorizontalScroller = false
    } else {
      self.textContainer!.widthTracksTextView = false
      self.textContainer!.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      self.isHorizontallyResizable = true
      scrollView.hasHorizontalScroller = true
    }
  }

  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    if loaded {
      return
    }

    setupStandardTextview()

    if AppState.getSetting("app-settings-text-view-wrap-lines", defaultValue: true) == false {
      setWordWrap(wordwrap: false)
      // The default NSTextView does not have word wrap, so we don't need to call setWordWrap in that case.
    }

//    if AppState.getSetting("app-settings-text-view-show-line-numbers", defaultValue: true) {
//      lnv_setUpLineNumberView()
//    }
    loaded = true
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
  
    if context == &wrapLineChangedContext {
      setWordWrap(wordwrap: AppState.getSetting("app-settings-text-view-wrap-lines", defaultValue: true))
      return
    }
    
//    if context == &lineNumbersChangedContext {
//      if AppState.getSetting("app-settings-text-view-show-line-numbers", defaultValue: true) {
//        lnv_setUpLineNumberView()
//      } else {
//        lnv_removeLineNumberView()
//      }
//      return
//    }
//
    // DON'T FORGET TO CALL super! OR WEIRD THINGS HAPPEN
    super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
  }
}
