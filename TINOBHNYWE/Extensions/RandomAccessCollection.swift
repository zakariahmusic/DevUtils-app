//
//  RandomAccessCollection.swift
//  DevUtils
//
//  Created by Tony Dinh on 11/8/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation

extension RandomAccessCollection {
  /// https://stackoverflow.com/a/33674192/1420186
  /// Finds such index N that predicate is true for all elements up to
  /// but not including the index N, and is false for all elements
  /// starting with index N.
  /// Behavior is undefined if there is no such N.
  func binarySearch(predicate: (Element) -> Bool) -> Index {
    var low = startIndex
    var high = endIndex
    while low != high {
      let mid = index(low, offsetBy: distance(from: low, to: high)/2)
      if predicate(self[mid]) {
        low = index(after: mid)
      } else {
        high = mid
      }
    }
    return low
  }
}
