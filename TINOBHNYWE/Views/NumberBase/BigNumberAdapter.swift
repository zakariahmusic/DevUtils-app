//
//  BigNumberAdapter.swift
//  DevUtils
//
//  Created by Tony Dinh on 12/19/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation
import BigInt

class BigNumberAdapter {
  var value: BigInt?
  
  init?(_ string: String, radix: Int) {
    if let v = BigInt.init(string, radix: radix) {
      self.value = v
    } else {
      return nil
    }
  }
  
  func asString(radix: Int) -> String {
    if radix < 2 || radix > 36 {
      return ""
    }
    
    if let value = self.value {
      return String.init(value, radix: radix, uppercase: false)
    }
    
    return ""
  }
}
