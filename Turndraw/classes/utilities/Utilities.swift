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

  public static func tryGit() {
//    let fileManager = NSFileManager.defaultManager()
//
//    let appDocumentURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask).first
//    let localDrawingURL: NSURL! = NSURL(string: "history.svg")
//
//    let filePath: String = "\(appDocumentURL.path!)/\(localDrawingURL.path!)"
//
//    let filePathURL = NSURL(string: filePath)
//    print(filePathURL?.path!)
//
//    do {
//      let repo = try GTRepository(URL: appDocumentURL); print("=> REPO")
//      let index = try repo.index(); print("=> INDEX: \(index)")
//
//      let branches = try repo.branches(); print("=> BRANCHES")
//
//      try index.addFile("history.svg"); print("=> ADD FILE")
//
////      for entry in index.entries {
////        print("ENTRY: \(entry)")
////        let indexEntry:GTIndexEntry = entry as! GTIndexEntry
////        print("==> STAGED: \(indexEntry.staged)")
////      }
//
//      let tree = try index.writeTree(); print("=> TREE")
//
////      for entry in index.entries {
////        print("ENTRY: \(entry)")
////        let indexEntry:GTIndexEntry = entry as! GTIndexEntry
////        print("==> STAGED: \(indexEntry.staged)")
////      }
//
//      try index.write()
//
//      //      let commit = try repo.createCommitWithTree(tree, message: "Initial Commit", parents: nil, updatingReferenceNamed: nil); print("=> CREATE COMMIT {\(commit)}")
//
//
//    } catch {
//      print("xxxxxxxxx ERROR xxxxxxxxx")
//    }
  }

  public static func commitChanges(message: String) {
//    let fileManager = NSFileManager.defaultManager()
//
//    let repoURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
//      inDomains: NSSearchPathDomainMask.AllDomainsMask).first
//    do {
//      let repo = try GTRepository(URL: repoURL);
//      let index = try repo.index();
//
////      for entry in index.entries {
////        print("ENTRY: \(entry)")
////        let indexEntry:GTIndexEntry = entry as! GTIndexEntry
////        print("==> STAGED: \(indexEntry.staged)")
////      }
//
//      try index.addFile(fileName);
//
//      try index.write()
//      let tree = try index.writeTree()
////      for entry in tree.entries! {
////        print("=> TREE ENTRY: \(entry)")
////      }
//
//      let commit = try repo.createCommitWithTree(tree, message: message,
//        parents: nil,
//        updatingReferenceNamed: "refs/heads/master");
//      
//    } catch {
//      print("xxxxxxxxx ERROR xxxxxxxxx")
//    }
//    
  }

  public static func initGit() {
    let fileManager = NSFileManager.defaultManager()

    let appDocumentURL: NSURL! = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask).first
    let localDrawingURL: NSURL! = NSURL(string: fileName)

    let filePath: String = "\(appDocumentURL.path!)/\(localDrawingURL.path!)"

    if !fileManager.fileExistsAtPath(filePath) {
      fileManager.createFileAtPath(filePath, contents: nil, attributes: nil)
      do {
        let url = appDocumentURL
        print("Git Repo: \(url.path!)")

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
}