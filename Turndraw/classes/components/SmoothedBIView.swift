//
//  SmoothedBIView.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/10/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit

class SmoothedBIView: UIView {

  var path: UIBezierPath = UIBezierPath()
  var incrementalImage: UIImage?
  var pts = [CGPoint](count: 5, repeatedValue: CGPointZero)
  var ctr = 0

  override func awakeFromNib() {
    super.awakeFromNib()

    self.multipleTouchEnabled = false
    self.backgroundColor = UIColor.whiteColor()
    path.lineWidth = 2.0

  }

  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    incrementalImage?.drawInRect(rect)
    path.stroke()
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    ctr = 0
    if let touch = touches.first {
      let point = touch.locationInView(self)
      pts[0] = point
    }
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let point = touch.locationInView(self)
      ctr++
      pts[ctr] = point
      if (ctr == 4) {

        pts[3] = CGPoint(x: (pts[2].x + pts[4].x)/2, y: (pts[2].y + pts[4].y)/2)

        path.moveToPoint(pts[0])
        path.addCurveToPoint(pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
        self.setNeedsDisplay()
        pts[0] = pts[3]
        pts[1] = pts[4]
        ctr = 1
      }
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.drawBitmap()
    self.setNeedsDisplay()
    path.removeAllPoints()
    ctr = 0
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    if let touches = touches {
      self.touchesEnded(touches, withEvent: event)
    }
  }


  func drawBitmap() {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
    UIColor.blackColor().setStroke()
    if incrementalImage == nil {
      let rectPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0)
      UIColor.whiteColor().setFill()
      rectPath.fill()
    }
    incrementalImage?.drawAtPoint(CGPointZero)
    path.stroke()
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }

}
