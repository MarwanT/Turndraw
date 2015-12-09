//
//  DrawingArea.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/3/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit

public class DrawingArea: UIView {
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!

  var drawImage: UIImage?

  var samplePoints = [CGPoint]()


  public override func awakeFromNib() {
    super.awakeFromNib()
    // Init here
    mainImageView.hidden = true
    tempImageView.hidden = true
  }

  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.locationInView(self)
      samplePoints.append(location)
    }
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.locationInView(self)
      samplePoints.append(location)
      setNeedsDisplay()
    }
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)

    drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
    drawImage = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    samplePoints.removeAll(keepCapacity: false)
  }


  func getMidPointFromA(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: (a.x+b.x)/2.0, y: (a.y+b.y)/2.0)
  }

  public override func drawRect(rect: CGRect)
  {
    let context = UIGraphicsGetCurrentContext()
    CGContextSetAllowsAntialiasing(context, true)
    CGContextSetShouldAntialias(context, true)

    UIColor.blueColor().setStroke()

    let path = UIBezierPath()
    path.lineJoinStyle = CGLineJoin.Round
    path.lineCapStyle = CGLineCap.Round
    path.lineWidth = 3

    drawImage?.drawInRect(bounds)

    if samplePoints.count > 0 {
      path.moveToPoint(samplePoints.first!)
      path.addLineToPoint(getMidPointFromA(samplePoints.first!, b: samplePoints[1]))

      for idx in 1..<samplePoints.count - 1 {
        let midPoint = getMidPointFromA(samplePoints[idx], b: samplePoints[idx + 1])
        path.addQuadCurveToPoint(midPoint, controlPoint: samplePoints[idx])
      }

      path.addLineToPoint(samplePoints.last!)

      path.stroke()
    }
  }
}
