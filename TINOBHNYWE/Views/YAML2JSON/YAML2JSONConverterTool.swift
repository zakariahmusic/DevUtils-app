//
//  YAML2JSONConverterTool.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/4/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation
import JavaScriptCore

class YAML2JSONConverterTool: FormatterTool {
  var c: JSContext
  
  required init(tool: Tool) {
    c = JSContext()
    c.evaluateScript(JSHelpers.readJsYaml())
    super.init(tool: tool)
  }
  
  override func useFormatterOptions() -> Bool {
    return false
  }
  
  override func getSampleString() -> String? {
    return """
    ---
    # Products purchased
    - item    : Super Hoop
      quantity: 1
    - item    : Basketball
      quantity: 4
    - item    : Big Shoes
      quantity: 1
    """
  }
  
  override func getHighlighterLanguage() -> String? {
    return "json"
  }
  
  override func format(input: String, options: FormatToolOptions) throws -> String {
    if input.count == 0 {
       return ""
    }
    
    c.setObject(input, forKeyedSubscript: "input" as NSString)
    
    let result = c.evaluateScript(
      """
      (function(){
        try {
          var doc = jsyaml.safeLoad(input);
          return JSON.stringify(doc, null, 2);
        } catch (e) {
          return "Error: " + e.message;
        }
      })()
      """
    )?.toString()

    return result ?? ""
  }
}
