//
//  DrawingArea.swift
//  Turndraw
//
//  Created by Marwan Toutounji on 12/3/15.
//  Copyright © 2015 Keeward. All rights reserved.
//

import UIKit
import SVGgh
import Cartography

public protocol CanvasViewDelegate {
  func canvasViewDidEndDrawing(bezierPath: UIBezierPath)
}

public class CanvasView: UIView {
  var samplePoints = [CGPoint]()

  var delegate: CanvasViewDelegate?

  var lastBezierPath: UIBezierPath?

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
    self.samplePoints.removeAll(keepCapacity: false)
    delegate?.canvasViewDidEndDrawing(lastBezierPath!)
    setNeedsDisplay()
  }

  public override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSetAllowsAntialiasing(context, true)
    CGContextSetShouldAntialias(context, true)

    UIColor.blueColor().setStroke()

    let path = UIBezierPath()
    path.lineJoinStyle = CGLineJoin.Round
    path.lineCapStyle = CGLineCap.Round
    path.lineWidth = 3

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

  func getMidPointFromA(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: (a.x+b.x)/2.0, y: (a.y+b.y)/2.0)
  }
}












public class DrawingArea: UIView, CanvasViewDelegate {

  let mainShapeLayer = CAShapeLayer()
  let drawingView = CanvasView(frame: CGRectZero)

  public override func awakeFromNib() {
    super.awakeFromNib()

    drawingView.delegate = self
    drawingView.backgroundColor = UIColor.clearColor()
    self.addSubview(drawingView)

    constrain(self, drawingView) { (parent, drawingView) -> () in
      drawingView.top == parent.top
      drawingView.left == parent.left
      drawingView.right == parent.right
      drawingView.bottom == parent.bottom
    }

    mainShapeLayer.fillColor = UIColor.clearColor().CGColor;
    mainShapeLayer.shouldRasterize = true
    mainShapeLayer.rasterizationScale = UIScreen.mainScreen().scale
    mainShapeLayer.contentsScale = UIScreen.mainScreen().scale
    mainShapeLayer.lineWidth = 3
    mainShapeLayer.strokeColor = UIColor.redColor().CGColor
    mainShapeLayer.borderWidth = 3
    mainShapeLayer.borderColor = UIColor.blackColor().CGColor
    mainShapeLayer.drawsAsynchronously = true
    mainShapeLayer.opaque = true

    self.layer.insertSublayer(mainShapeLayer, atIndex: 0)

    loadSVGFile()

    self.clipsToBounds = true
  }

  public func canvasViewDidEndDrawing(bezierPath: UIBezierPath) {
    let saveChanges = { (path: CGPath?) -> Void in
      if let path = path {
        let svgPath = SVGPathGenerator.svgPathFromCGPath(path)
        Utilies.writeToSVGFile(self.frame, svgPath: svgPath!)
        self.saveSSVGFileModifications()
      }
    }

    if let mainCGPath = mainShapeLayer.path {
      let mainCGBezierPath = UIBezierPath(CGPath: mainCGPath)
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
        mainCGBezierPath.appendPath(bezierPath)

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.mainShapeLayer.path = mainCGBezierPath.CGPath
          self.mainShapeLayer.lineWidth = bezierPath.lineWidth
          self.mainShapeLayer.lineWidth = 3
          self.mainShapeLayer.borderWidth = 3
          self.mainShapeLayer.borderColor = UIColor.blackColor().CGColor
        })

        print("BEZIER PATH ELEMENTS NUMBER = \(mainCGBezierPath.count())")

        saveChanges(mainCGBezierPath.CGPath)
      })
    } else {
      mainShapeLayer.path = bezierPath.CGPath
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        { () -> Void in
          saveChanges(self.mainShapeLayer.path)
      })
    }
  }

  public func reset() {
    //    shapeLayer.path = nil
    Utilies.writeToDocument("")
  }

  public func changeWidth() {
    mainShapeLayer.lineWidth += 2
  }

  public func undo() {
    Utilies.resetHardLastCommit()
    loadSVGFile()
  }

  public func loadSVGFile() {
    if let svgPathString = Utilies.readPathFromSVGFile() {
      let svgSGPath = SVGPathGenerator.newCGPathFromSVGPath(svgPathString,
        whileApplyingTransform: CGAffineTransformMakeScale(1, 1))
      mainShapeLayer.path = svgSGPath!.takeRetainedValue()
    } else {
      mainShapeLayer.path = nil
    }
  }

  public func saveSSVGFileModifications() {
    Utilies.commitModifications()
  }
}
