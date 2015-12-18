//
//  ViewController.swift
//  Turndraw
//
//  Created by Elie Soueidy on 11/6/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var drawLeftButton: UIButton!
  @IBOutlet weak var drawRightButton: UIButton!

  @IBOutlet weak var drawDownwordsButton: UIButton!
  @IBOutlet weak var drawUpwordsButton: UIButton!

  @IBOutlet weak var drawingArea: DrawingArea!

  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var tempDrawImage: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func drawLeftAction(sender: AnyObject) {
  }
  @IBAction func drawRightAction(sender: AnyObject) {
  }
  @IBAction func drawUpwordsAction(sender: AnyObject) {
    drawingArea.changeWidth()
  }
  @IBAction func drawDownwordsAction(sender: AnyObject) {
  }

  @IBAction func resetButtonAction(sender: AnyObject) {
    drawingArea.reset()
  }
  
}

