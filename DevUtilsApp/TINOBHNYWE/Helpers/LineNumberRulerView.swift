//
//  LineNumberRulerView.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/5/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//
//  Modifications:
//  - Make it work in 10.11
//  - Fix ruler allignment when the textview has padding
//  - Added dynamic ruler width for large line numbers
//  - Handle more type of newline chars
//  - Fix crashes in some cases

/*
 
 line number / ruler view bugs:
 - when on -> off: resize -> wrap stop working
 - mystery padding on the right
 - when off -> on: overlapping text

 */

//
//  LineNumberRulerView.swift
//  LineNumber
//
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
import AppKit
import Foundation
import ObjectiveC

var LineNumberViewAssocObjKey: UInt8 = 0

extension NSTextView {
  var lineNumberView:LineNumberRulerView? {
    get {
      return objc_getAssociatedObject(self, &LineNumberViewAssocObjKey) as? LineNumberRulerView
    }
    set {
      objc_setAssociatedObject(self, &LineNumberViewAssocObjKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func lnv_setUpLineNumberView() {
    NotificationCenter.default.addObserver(self, selector: #selector(lnv_framDidChange), name: NSView.frameDidChangeNotification, object: self)
    NotificationCenter.default.addObserver(self, selector: #selector(lnv_textDidChange), name: NSText.didChangeNotification, object: self)
    
    if enclosingScrollView?.verticalRulerView != nil {
      // Only show the inited ruler
      enclosingScrollView?.rulersVisible = true
      refreshFrame()
      return
    }
    
    // Init the line number view once
    postsFrameChangedNotifications = true
    if let scrollView = enclosingScrollView {
      lineNumberView = LineNumberRulerView(textView: self)
      scrollView.verticalRulerView = lineNumberView
      scrollView.hasVerticalRuler = true
      scrollView.rulersVisible = true
    }
  }
  
  func lnv_removeLineNumberView() {
    NotificationCenter.default.removeObserver(self, name: NSView.frameDidChangeNotification, object: self)
    NotificationCenter.default.removeObserver(self, name: NSText.didChangeNotification, object: self)
    
    if let scrollView = enclosingScrollView {
      scrollView.rulersVisible = false
    }
    
    refreshFrame()
  }
  
  @objc func lnv_framDidChange(notification: NSNotification) {
    refreshLineNumberView()
  }
  
  @objc func lnv_textDidChange(notification: NSNotification) {
    refreshLineNumberView()
  }
  
  func refreshLineNumberView() {
    lineNumberView?.needsDisplay = true
  }
}

class LineNumberRulerView: NSRulerView {
  
  var font: NSFont! {
    didSet {
      self.needsDisplay = true
    }
  }
  
  var rulePaddingRight = CGFloat(5)
  
  init(textView: NSTextView) {
    super.init(scrollView: textView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
    self.font = textView.font ?? NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
    self.clientView = textView
    
    self.ruleThickness = 40
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawHashMarksAndLabels(in rect: NSRect) {
    if let textView = self.clientView as? NSTextView {
      if let layoutManager = textView.layoutManager {
        var maxLength = CGFloat(0)
        var relativePoint = self.convert(NSZeroPoint, from: textView)
        relativePoint.y += textView.textContainerInset.height - CGFloat(4) // not sure why it is a bit off on my screen. Need to test on multiple screens
        let lineNumberAttributes = [NSAttributedString.Key.font: textView.font!, NSAttributedString.Key.foregroundColor: NSColor.gray] as [NSAttributedString.Key : Any]
        
        let drawLineNumber = { (lineNumberString:String, y:CGFloat) -> Void in
          let attString = NSAttributedString(string: lineNumberString, attributes: lineNumberAttributes)
          let x = self.rulePaddingRight
          if maxLength < attString.size().width {
            maxLength = attString.size().width
            self.ruleThickness = maxLength + 2 * self.rulePaddingRight
          }
          attString.draw(at: NSPoint(x: x, y: relativePoint.y + y))
        }
        
        let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textView.textContainer!)
        let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
        let newLineRegex = try! NSRegularExpression(pattern: "\n|\r|\r\n|\u{0085}|\u{2028}|\u{2029}", options: [])
        // The line number for the first visible line
        var lineNumber = newLineRegex.numberOfMatches(in: textView.string, options: [], range: NSMakeRange(0, firstVisibleGlyphCharacterIndex)) + 1
        
        var glyphIndexForStringLine = visibleGlyphRange.location
        
        // Go through each line in the string.
        while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
          
          // Range of current line in the string.
          let characterRangeForStringLine = (textView.string as NSString).lineRange(
            for: NSMakeRange( layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), 0 )
          )
          let glyphRangeForStringLine = layoutManager.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
          
          var glyphIndexForGlyphLine = glyphIndexForStringLine
          var glyphLineCount = 0
          
          while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
            
            // See if the current line in the string spread across
            // several lines of glyphs
            var effectiveRange = NSMakeRange(0, 0)
            
            // Range of current "line of glyphs". If a line is wrapped,
            // then it will have more than one "line of glyphs"
            let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
            
            if glyphLineCount > 0 {
              drawLineNumber("-", lineRect.minY)
            } else {
              drawLineNumber("\(lineNumber)", lineRect.minY)
            }
            
            // Move to next glyph line
            glyphLineCount += 1
            glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
          }
          
          glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
          lineNumber += 1
        }
        
        // Draw line number for the extra line at the end of the text
        if layoutManager.extraLineFragmentTextContainer != nil {
          drawLineNumber("\(lineNumber)", layoutManager.extraLineFragmentRect.minY)
        }
      }
    }
  }
}
