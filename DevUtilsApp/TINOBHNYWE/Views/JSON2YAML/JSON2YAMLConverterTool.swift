//
//  JSON2YAMLConverterTool.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/4/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSON2YAMLConverterTool: FormatterTool {
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
    {"store":{"book":[{"category":"reference", "sold": false,"author":"Nigel Rees","title":"Sayings of the Century","price":8.95},{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":12.99},{"category":"fiction","author":"J. R. R. Tolkien","title":"The Lord of the Rings","act": null, "isbn":"0-395-19395-8","price":22.99}],"bicycle":{"color":"red","price":19.95}}}
    """
  }
  
  override func getHighlighterLanguage() -> String? {
    return "yaml"
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
          return jsyaml.dump(JSON.parse(input));
        } catch (e) {
          return "Error: " + e.message;
        }
      })()
      """
    )?.toString()

    return result ?? ""
  }
}
