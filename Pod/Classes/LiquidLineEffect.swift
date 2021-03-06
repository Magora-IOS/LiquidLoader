//
//  LiquidLineLoader.swift
//  LiquidLoading
//
//  Created by Takuma Yoshida on 2015/08/21.
//  Copyright (c) 2015年 yoavlt. All rights reserved.
//

import Foundation
import UIKit

class LiquidLineEffect : LiquidLoadEffect {

    var circleInter: CGFloat!

    override func setupShape() -> [LiquittableCircle] {
      
      var result: [LiquittableCircle] = []

      for i in 0..<numberOfCircles {
        let floatI = CGFloat(i)
        let circleInterVar: CGFloat = circleInter
        
        // The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
        let temp = floatI * (circleInter + 2 * circleRadius)
        let x = circleInterVar + circleRadius + temp
        
        let center = CGPoint(x: x, y: loader.frame.height * 0.5)
        
        result.append(LiquittableCircle(center: center,
          radius: circleRadius,
          color: color,
          growColor: growColor)
        )
      }
      
      return result
    }

    override func movePosition(_ key: CGFloat) -> CGPoint {
        if loader != nil {
            return CGPoint(
                x:  (circles.last!.frame.rightBottom.x + circleInter)  * sineTransform(key),
                y: loader.frame.height * 0.5
            )
        } else {
            return CGPoint.zero
        }
    }

    func sineTransform(_ key: CGFloat) -> CGFloat {
        return sin(key * CGFloat(Double.pi)) * 0.5 + 0.5
    }

    override func update() {
        switch key {
        case 0.0...2.0:
            key += 2.0/(duration*60)
        default:
            key = 0.0
        }
    }
    
    override func willSetup() {
        if circleRadius == nil {
            circleRadius = loader.frame.width * 0.05
        }
        self.circleInter = (loader.frame.width - 2 * circleRadius * 5) / 6
        self.engine = SimpleCircleLiquidEngine(radiusThresh: self.circleRadius, angleThresh: 0.2)
        let moveCircleRadius = circleRadius * moveScale
        self.moveCircle = LiquittableCircle(center: CGPoint(x: 0, y: loader.frame.height * 0.5), radius: moveCircleRadius, color: color, growColor: growColor)
    }
    
    override func resize() {
        circles.map { circle in
            return (circle, circle.center.minus(self.moveCircle!.center).length())
        }.each { (circle, distance) in
            let normalized = 1.0 - distance / (self.circleRadius + self.circleInter)
            if normalized > 0.0 {
                circle.radius = self.circleRadius + (self.circleRadius * self.circleScale - self.circleRadius) * normalized
            } else {
                circle.radius = self.circleRadius
            }
        }
    }
    
}
