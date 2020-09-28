//
//  String.swift
//  DevUtils
//
//  Created by Tony Dinh on 5/23/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation
import JavaScriptCore

extension String {
  func encodeUrl() -> String? {
    return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlUserAllowed)
  }
  
  func decodeUrl() -> String? {
    return self.removingPercentEncoding?.replacingOccurrences(of: "+", with: " ")
  }
  /**
   Returns a new string made from the receiver by replacing characters which are
   reserved in a URI query with percent encoded characters.
   
   The following characters are not considered reserved in a URI query
   by RFC 3986:
   
   - Alpha "a...z" "A...Z"
   - Numberic "0...9"
   - Unreserved "-._~"
   
   In addition the reserved characters "/" and "?" have no reserved purpose in the
   query component of a URI so do not need to be percent escaped.
   
   - Returns: The encoded string, or nil if the transformation is not possible.
   */
  
  public func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "-._~/?"
    let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
    allowedCharacterSet.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
  }
  
  
  /**
   Returns a new string made from the receiver by replacing characters which are
   reserved in HTML forms (media type application/x-www-form-urlencoded) with
   percent encoded characters.
   
   The W3C HTML5 specification, section 4.10.22.5 URL-encoded form
   data percent encodes all characters except the following:
   
   - Space (0x20) is replaced by a "+" (0x2B)
   - Bytes in the range 0x2A, 0x2D, 0x2E, 0x30-0x39, 0x41-0x5A, 0x5F, 0x61-0x7A
     (alphanumeric + "*-._")
   - Parameter plusForSpace: Boolean, when true replaces space with a '+'
   otherwise uses percent encoding (%20). Default is false.
   
   - Returns: The encoded string, or nil if the transformation is not possible.
   */

  public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
    let unreserved = "*-._"
    let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
    allowedCharacterSet.addCharacters(in: unreserved)
    
    if plusForSpace {
        allowedCharacterSet.addCharacters(in: " ")
    }
    
    var encoded = addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
    if plusForSpace {
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
    }
    return encoded
  }
  
  public func pretifyJSON(format: Any? = nil) -> String? {
    let context = JSContext()!
    context.setObject(format, forKeyedSubscript: "format" as NSString)
    context.setObject(self, forKeyedSubscript: "json" as NSString)
    let result = context.evaluateScript("JSON.stringify(JSON.parse(json), null, format)")
    return result?.toString()
  }
  
  var unescaped: String {
    let entities = ["\0", "\t", "\n", "\r", "\"", "\'"]
    
    let parts = self.components(separatedBy: "\\".debugDescription.dropFirst().dropLast()).map { (part) -> String in
      var current = part
      for entity in entities {
        let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
        let description = String(descriptionCharacters)
        current = current.replacingOccurrences(of: description, with: entity)
      }
      return current
    }
    
    return parts.joined(separator: "\\")
  }

  func fromBase64(_ encoding: String.Encoding = .utf8) -> String? {
    // The ==== part is to make the decoding process easier by providing fake padding
    // Remove all newlines and spaces
    let string = "\(self)====".replacingOccurrences(of: "\\s*", with: "", options: .regularExpression)
    guard let data = Data(base64Encoded: string) else {
      return nil
    }
    
    return String(data: data, encoding: encoding)
  }
  
  func toBase64(_ encoding: String.Encoding = .utf8) -> String? {
    return self.data(using: encoding)?.base64EncodedString()
  }
  
  init?(htmlEncodedString: String) {
    
    guard let data = htmlEncodedString.data(using: .utf8) else {
      return nil
    }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    
    self.init(attributedString.string)
    
  }
}
