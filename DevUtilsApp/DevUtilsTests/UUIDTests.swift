//
//  UUIDTests.swift
//  DevUtilsTests
//
//  Created by Tony Dinh on 10/2/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import XCTest

class UUIDTests: XCTestCase {
  
  func testNode() {
    let uuid = UUID(uuidString: "2a4c83d8-045f-11eb-9833-d3e52d6b40ea")
     XCTAssertEqual(uuid?.node, "d3:e5:2d:6b:40:ea")
  }
  
  func testTimestamp() {
    let uuid = UUID(uuidString: "2a4c83d8-045f-11eb-9833-d3e52d6b40ea")
    
    XCTAssertEqual((uuid?.time.timeIntervalSince1970 ?? 0) * 1000, 1601609234299)
  }
  
  func testClockId() {
    let uuid = UUID(uuidString: "30352ff0-0493-11eb-a25f-acde48001122")
    
    XCTAssertEqual(uuid?.clockId, 8799)
  }
  
}
