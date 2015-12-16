//
//  Utilities.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/16/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import Foundation

public class Utilies {

}

extension Utilies {
  public static func writeToDocument(text: String) {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/history";

      //writing
      do {
        try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      }
      catch {/* error handling here */}
    }
  }

  public static func readFromDocument() -> String? {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/history";

      //reading
      do {
        let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return text as String
      }
      catch { /* error handling here */ }
    }

    return nil
  }
}