//
//  Tool.swift
//  TINOBHNYWE
//
//  Created by Tony Dinh on 5/16/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Cocoa

class Tool: NSObject, Fuseable {
  let id: String
  dynamic let name: String
  let image: NSImage
  let viewControllerType: ToolViewController.Type
  let implementation: ToolImpl.Type?
  let settingViewControllerType: ToolSettingViewController.Type?
  
  var properties: [FuseProperty] {
      return [
          FuseProperty(name: "name", weight: 1),
      ]
  }
  
  init(
    id: String,
    name: String,
    image: NSImage,
    viewControllerType: ToolViewController.Type,
    implementation: ToolImpl.Type? = nil,
    settingViewControllerType: ToolSettingViewController.Type? = nil
  ) {
    self.id = id
    self.name = name
    self.image = image
    self.viewControllerType = viewControllerType
    self.implementation = implementation
    self.settingViewControllerType = settingViewControllerType
  }
}
