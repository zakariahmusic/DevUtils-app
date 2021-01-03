//
//  EndecodeTool.swift
//  DevUtils
//
//  Created by Tony Dinh on 6/13/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation

class EndecodeTool: ToolImpl {
  required init(tool: Tool) {
    super.init(tool: tool)
  }
  
  func hasSetting() -> Bool {
    return true
  }
  
  // Whether the sample input need to be encoded or decoded
  func isSampleNeedEncode() -> Bool {
    return true
  }
  
  func getEncodeLabel() -> String {
    return "Encode"
  }
  
  func getDecodeLabel() -> String {
    return "Decode"
  }
  
  func matchInput(input: String, options: ToolOptions) -> Bool {
    do {
      return try decode(input, options) != input
    } catch {
      log.debug("matchInput failed: \(error)")
      return false
    }
  }
  
  /*
   Encode an input.
   Expected to be lightweight and can be run multiple times on tool activated
   */
  func encode(_ input: String, _ toolOptions: ToolOptions) throws -> String {
    return input
  }
  
  /*
   Decode an input.
   Expected to be lightweight and can be run multiple times on tool activated
   */
  func decode(_ input: String, _ toolOptions: ToolOptions) throws -> String {
    return input
  }
  
  func getSampleString() -> String? {
    return nil
  }
}
