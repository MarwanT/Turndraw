//
//  LinearInterpView.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/10/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit

class LinearInterpView: UIView {

  var path: UIBezierPath = UIBezierPath()

  override func awakeFromNib() {
    super.awakeFromNib()

    self.multipleTouchEnabled = false
    self.backgroundColor = UIColor.whiteColor()
    path.lineWidth = 2.0

  }

  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    UIColor.blackColor().setStroke()
    path.stroke()
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let point = touch.locationInView(self)
      path.moveToPoint(point)
    }
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let point = touch.locationInView(self)
      path.addLineToPoint(point)
      self.setNeedsDisplay()
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.touchesMoved(touches, withEvent: event)
  }

  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    if let touches = touches {
      self.touchesEnded(touches, withEvent: event)
    }
  }

}
