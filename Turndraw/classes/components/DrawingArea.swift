//
//  DrawingArea.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/3/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit
import SVGgh

public class DrawingArea: UIView {
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!

  var drawImage: UIImage?

  var samplePoints = [CGPoint]()

  let shapeLayer = CAShapeLayer()

  var lastBezierPath: UIBezierPath?


  public override func awakeFromNib() {
    super.awakeFromNib()
    // Init here
    mainImageView.hidden = true
    tempImageView.hidden = true

    shapeLayer.fillColor = UIColor.clearColor().CGColor;
    shapeLayer.shouldRasterize = true
    shapeLayer.rasterizationScale = UIScreen.mainScreen().scale
    shapeLayer.contentsScale = UIScreen.mainScreen().scale
    shapeLayer.lineWidth = 3
    shapeLayer.strokeColor = UIColor.redColor().CGColor
    shapeLayer.borderWidth = 3
    shapeLayer.borderColor = UIColor.blackColor().CGColor
    shapeLayer.drawsAsynchronously = true

    self.layer.insertSublayer(shapeLayer, atIndex: 0)

    preloadDrawing()
  }

  private func preloadDrawing() {
    if let svgString = Utilies.readFromDocument() {
      let xxxx = SVGPathGenerator.newCGPathFromSVGPath(svgString, whileApplyingTransform: CGAffineTransformMakeScale(1, 1))
      shapeLayer.path = xxxx!.takeRetainedValue()
    }
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
//    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
//
//    drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
//    drawImage = UIGraphicsGetImageFromCurrentImageContext()
//
//    UIGraphicsEndImageContext()


    if let drawnPath = shapeLayer.path,
    let lastBezierPath = lastBezierPath {
      let tempBezierPath = UIBezierPath(CGPath: drawnPath)
      tempBezierPath.appendPath(lastBezierPath)
      shapeLayer.path = tempBezierPath.CGPath
      shapeLayer.lineWidth = tempBezierPath.lineWidth
      shapeLayer.lineWidth = 3
      shapeLayer.borderWidth = 3
      shapeLayer.borderColor = UIColor.blackColor().CGColor
    } else {
      shapeLayer.path = lastBezierPath?.CGPath
    }

    samplePoints.removeAll(keepCapacity: false)


    if let path = shapeLayer.path {
      let zzzz = SVGPathGenerator.svgPathFromCGPath(path)
      print(zzzz)
      Utilies.writeToDocument(zzzz!)
      let xxxx = SVGPathGenerator.newCGPathFromSVGPath(zzzz!, whileApplyingTransform: CGAffineTransformMakeScale(1, 1))
      shapeLayer.path = xxxx!.takeRetainedValue()

    }
  }

  public func reset() {
    shapeLayer.path = nil
    Utilies.writeToDocument("")
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

//    drawImage?.drawInRect(bounds)

    if samplePoints.count > 0 {
      path.moveToPoint(samplePoints.first!)
      path.addLineToPoint(getMidPointFromA(samplePoints.first!, b: samplePoints[1]))

      for idx in 1..<samplePoints.count - 1 {
        let midPoint = getMidPointFromA(samplePoints[idx], b: samplePoints[idx + 1])
        path.addQuadCurveToPoint(midPoint, controlPoint: samplePoints[idx])
      }

      path.addLineToPoint(samplePoints.last!)

      path.stroke()

      lastBezierPath = path
    }
  }

  public func changeWidth() {
    shapeLayer.lineWidth += 2
  }
}
