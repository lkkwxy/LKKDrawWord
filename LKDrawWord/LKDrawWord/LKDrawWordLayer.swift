//
//  LKDrawWordLayer.swift
//  LKDrawWord
//
//  Created by lkk on 15-2-5.
//  Copyright (c) 2015年 lkk. All rights reserved.
//

import UIKit
import CoreFoundation
import Foundation
import CoreText
import CoreFoundation.CFString
class LKDrawWordLayer: CALayer {
    var pathLayer = CAShapeLayer()
    var penLayer = CALayer()
    class func createAnimation(string:String,font:UIFont,rect:CGRect,view:UIView,color:UIColor){
        var drawWordLayer = LKDrawWordLayer()
        var frame = rect
//        frame.origin.y = rect.origin.y - UIScreen.mainScreen().bounds.size.height
//        frame.size.height = rect.size.height
        println(frame)
        drawWordLayer.frame = frame
        drawWordLayer.backgroundColor = UIColor.grayColor().CGColor
        view.layer.addSublayer(drawWordLayer)
        if(drawWordLayer.pathLayer != nil){
           drawWordLayer.pathLayer.removeFromSuperlayer()
           drawWordLayer.penLayer.removeFromSuperlayer()
           drawWordLayer.penLayer = nil
           drawWordLayer.pathLayer = nil
        }
        var paths = CGPathCreateMutable()
        var fontName = __CFStringMakeConstantString(font.fontName)
        var fontSize = font.pointSize
        var fontRef:AnyObject = CTFontCreateWithName(fontName, fontSize, nil)
        var attrString = NSAttributedString(string: string, attributes: [kCTFontAttributeName : fontRef])
        var line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        var runA = CTLineGetGlyphRuns(line)
        println(runA)
       
        for (var runIndex = 0; runIndex < CFArrayGetCount(runA); runIndex++){
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, CTRun.self)
            println(runb)
            let  CTFontName = unsafeBitCast(kCTFontAttributeName, UnsafePointer<Void>.self)
            
            var runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            var runFontS = unsafeBitCast(runFontC, CTFont.self)
            var oldPosition:CGPoint = CGPointZero
            var oldGlyph:CGGlyph = 0
            var width = drawWordLayer.frame.size.width
            var temp = 0
            var offset:CGFloat = 0.0
            for(var i = 0; i < CTRunGetGlyphCount(runb); i++){
                let range = CFRangeMake(i, 1)
                var glyph:UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.alloc(1)
                glyph.initialize(0)
                var position:UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.alloc(1)
                position.initialize(CGPointZero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                println(position)
                var temp3 = CGFloat(position.memory.x)
                var temp2 =
                (Int) (temp3 / width)
                var temp1 = (Int) ((oldPosition.x ) / width)
                if(temp2 > temp1){
                   println(range.location)
                   temp = temp2
                   offset = position.memory.x - (CGFloat(temp) * width)
                }
                var path = CTFontCreatePathForGlyph(runFontS,glyph.memory,nil)
                var x = position.memory.x - (CGFloat(temp) * width) - offset
                var y = position.memory.y - (CGFloat(temp) * 80)
                var transform = CGAffineTransformMakeTranslation(x, y)
                CGPathAddPath(paths, &transform, path)
                if(i > 0){
                    oldGlyph = glyph.memory
                    oldPosition = position.memory
                }
                glyph.destroy()
                glyph.dealloc(1)
                position.destroy()
                position.dealloc(1)
            }
            
            
            
    }
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointZero)
        bezierPath.appendPath(UIBezierPath(CGPath: paths))
        
        
        drawWordLayer.pathLayer = CAShapeLayer()
        drawWordLayer.pathLayer.frame = CGRectMake(0, drawWordLayer.frame.size.height - 50, drawWordLayer.frame.size.width, drawWordLayer.frame.size.height)
        
        drawWordLayer.geometryFlipped = true
        drawWordLayer.pathLayer.path = bezierPath.CGPath
        drawWordLayer.pathLayer.strokeColor = color.CGColor
        drawWordLayer.pathLayer.fillColor = nil
        drawWordLayer.pathLayer.lineWidth = 3.0
        drawWordLayer.pathLayer.lineJoin = kCALineJoinBevel
        
        
        
        let penImage = UIImage(named: "pen.png")!
        var penLayer = CALayer()
        penLayer.contents = penImage.CGImage
        penLayer.anchorPoint = CGPointZero
        penLayer.frame = CGRectMake(0, 0, penImage.size.width, penImage.size.height)
        drawWordLayer.pathLayer.addSublayer(penLayer)
        drawWordLayer.penLayer = penLayer
        
        drawWordLayer.pathLayer.removeAllAnimations()
        drawWordLayer.penLayer.removeAllAnimations()
        drawWordLayer.penLayer.hidden = false
        
        var pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 4.0
        pathAnimation.fromValue = NSNumber(float: 0.0)
        pathAnimation.toValue = NSNumber(float: 1.0)
        drawWordLayer.pathLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        drawWordLayer.addSublayer(drawWordLayer.pathLayer)
        
        var penAnimation = CAKeyframeAnimation(keyPath: "position")
        penAnimation.duration = 4.0
        penAnimation.path = drawWordLayer.pathLayer.path
        penAnimation.calculationMode = kCAAnimationPaced
        penAnimation.delegate = drawWordLayer
        drawWordLayer.penLayer .addAnimation(penAnimation, forKey: "position")
    
}
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        var s :String = "hhhh";
        if(anim.isKindOfClass(CAKeyframeAnimation)){
            var b = anim as CAKeyframeAnimation
         s = b.keyPath
        }
        
        println(s)
       self.penLayer.hidden = true
    }
}// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com