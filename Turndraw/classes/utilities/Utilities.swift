//
//  Utilities.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/16/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import Foundation
import UIKit

public class Utilies {

}

extension Utilies {
  public static func writeToDocument(text: String) {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/history.svg";
      print(path)

      //writing
      do {
        try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      }
      catch {/* error handling here */}
    }
  }

  public static func writeToSVGFile(bounds: CGRect, svgPath: String) {
    let svgTemplate = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"> <svg  xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" viewport-fill=\"none\" viewBox=\"%lf, %lf, %lf, %lf\" version=\"1.1\" height=\"%lf\" width=\"%lf\" ><path fill=\"none\" stroke=\"n\" d=\"%@\" /> </svg>"

    let fileContent = String(format:svgTemplate, bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height, bounds.size.height, bounds.size.width, svgPath)

    print(fileContent)

    writeToDocument(fileContent)
  }

  public static func readFromDocument() -> String? {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/history.svg";

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