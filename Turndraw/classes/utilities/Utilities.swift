//
//  Utilities.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/16/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveGit

public class Utilies {

}

extension Utilies {
  enum SavingError: ErrorType {
    case CouldNotExtractSVGFile
  }
}

extension Utilies {
  static var fileName: String {
    return "history.svg"
  }

  public static func writeToDocument(text: String) {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/\(fileName)";
      print(path)

      //writing
      do {
        try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      }
      catch {/* error handling here */}
    }
  }

  public static func writeToSVGFile(bounds: CGRect, svgPath: String) {
    let svgTemplate = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"> <svg  xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" viewport-fill=\"none\" viewBox=\"%lf, %lf, %lf, %lf\" version=\"1.1\" height=\"%lf\" width=\"%lf\" ><path fill=\"none\" stroke=\"n\" d=\"%@\" /> </svg>\n"

    let fileContent = String(format:svgTemplate, bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height, bounds.size.height, bounds.size.width, svgPath)

    print(fileContent)

    writeToDocument(fileContent)
  }

  public static func readPathFromSVGFile() -> String? {
    if let svgString = Utilies.readFromDocument() {
      do {
        let svgPath = try svgPathFromSVGString(svgString)
        return svgPath
      } catch SavingError.CouldNotExtractSVGFile {
        print("CouldNotExtractSVGFile")
      } catch {
        print("CouldNotExtractSVGFile")
      }
    }

    return nil
  }

  public static func readFromDocument() -> String? {
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
      let path = "\(dir)/\(fileName)";

      //reading
      do {
        let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return text as String
      }
      catch { /* error handling here */ }
    }

    return nil
  }

  public static func svgPathFromSVGString(svgString: String?) throws -> String {
    if let svgString = svgString,
    let startSVGPathIndex = svgString.rangeOfString("d=\"")?.endIndex,
    let endSVGPathIndex = svgString.rangeOfString("\" /> </svg>")?.startIndex {
      return svgString.substringWithRange(Range.init(start: startSVGPathIndex, end: endSVGPathIndex))
    }

    throw SavingError.CouldNotExtractSVGFile
  }

  public static func initGit() {
    let fileManager = NSFileManager.defaultManager()

    let appDocumentURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask).first
    let localDrawingURL: NSURL! = NSURL(string: fileName)

    let filePath: String = "\(appDocumentURL.path!)/\(localDrawingURL.path!)"
    print("File Path = \(filePath)")

    if !fileManager.fileExistsAtPath(filePath) {
      fileManager.createFileAtPath(filePath, contents: nil, attributes: nil)
      do {
        let url = appDocumentURL

        // 1. Init repository
        let repo = try GTRepository.initializeEmptyRepositoryAtFileURL(url, options: nil)

        // 2. Get index
        let index = try repo.index();

        // 3. Add File
        try index.addFile(fileName);

        // 4. Write changes to current index
        try index.write()

        // 5. Get the current tree
        let tree = try index.writeTree()

        // 6. Commit
        try repo.createCommitWithTree(tree, message: "Initial Commit",
          parents: nil,
          updatingReferenceNamed: "refs/heads/master");
      } catch {
        print("XX - Not Initialized")
      }
    }
  }

  public static func commitModifications() {
    let fileManager = NSFileManager.defaultManager()
    let appDocumentURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
      inDomains: NSSearchPathDomainMask.AllDomainsMask).first

    do {
      let repo = try GTRepository(URL: appDocumentURL);

      // 2. Get index
      let index = try repo.index();

      // 3. Add File
      try index.addFile(fileName);

      // 4. Write changes to current indexx
      try index.write()

      // 5. Get the current tree
      let tree = try index.writeTree()

      let head = try repo.headReference()
      let parentCommit = try repo.lookUpObjectByOID(head.targetOID) as! GTCommit

      // 6. Commit
      try repo.createCommitWithTree(tree, message: "Bezier Path Drawn",
        parents: [parentCommit],
        updatingReferenceNamed: "refs/heads/master");
    } catch {
      print("Error Committing")
    }
  }

  public static func resetHardLastCommit() {
    let fileManager = NSFileManager.defaultManager()
    let appDocumentURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
      inDomains: NSSearchPathDomainMask.AllDomainsMask).first

    do {
      let repo = try GTRepository(URL: appDocumentURL);
      let head = try repo.headReference()
      let lastCommit = try repo.lookUpObjectByOID(head.targetOID) as! GTCommit
      if let parentCommit = lastCommit.parents.last as? GTCommit {
        try repo.resetToCommit(parentCommit, resetType: GTRepositoryResetType.Hard)
      }
    } catch {
      print("Error Resetting")
    }
  }

}