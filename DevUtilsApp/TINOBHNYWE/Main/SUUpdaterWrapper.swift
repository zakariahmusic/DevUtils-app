//
//  SUUpdater.swift
//  DevUtils
//
//  Created by Tony Dinh on 11/7/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation
#if NO_SPARKLE
#else
import Sparkle
#endif

#if NO_SPARKLE
// A dummy class that is compatible with SUUpdater.
class SUUpdaterWrapper: NSObject {
  @IBOutlet
  public var automaticallyChecksForUpdates: NSObject?
  @IBOutlet
  public var updateCheckInterval: NSObject?
  @IBAction
  func checkForUpdates(_ sender: Any) {
  }
}
#else
class SUUpdaterWrapper: SUUpdater {
}
#endif
