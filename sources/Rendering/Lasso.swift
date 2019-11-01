//
//  Lasso.swift
//  mindworms-2
//
//  Created by Alexander Bollbach on 10/4/19.
//  Copyright © 2019 Alexander Bollbach. All rights reserved.
//

import Foundation
import CoreGraphics
//
//func renderLasso(_ lasso: Lasso, re: RenderingEnvironment) {
//    guard lasso.points.count >= 1 else { return }
//    
//    
//    re.context.setLineWidth(2.0)
//    re.context.setStrokeColor(UIColor.orange.cgColor)
//    re.context.setLineCap(.round)
//    re.context.setLineJoin(.bevel)
//    
//    re.context.strokePath()
//    
//    let sides = lasso.debug.sides
//    
//    if sides.count > 1 {
//        
//        for i in 0..<sides.count {
//            if i == 0 {
//                re.context.move(
//                    to: re.transform.applyTo(sides[0].begin).cgPoint(in: re.rect)
//                )
//                re.context.addLine(
//                    to: re.transform.applyTo(sides[0].end).cgPoint(in: re.rect)
//                )
//                continue
//            }
//            
//            re.context.addLine(
//                to: re.transform.applyTo(sides[i].begin).cgPoint(in: re.rect)
//            )
//            
//            re.context.addLine(
//                to: re.transform.applyTo(sides[i].end).cgPoint(in: re.rect)
//            )
//        }
//    }
//    
//    re.context.strokePath()
//    
//    re.context.setStrokeColor(UIColor.purple.withAlphaComponent(0.4).cgColor)
//    re.context.setLineWidth(1)
//    
//    for ray in lasso.debug.rays {
//        re.context.move(to: re.transform.applyTo(ray).cgPoint(in: re.rect))
//        re.context.addLine(to: re.transform.applyTo(RenderProps.Point(x: ray.x + 2000, y: ray.y)).cgPoint(in: re.rect))
//    }
//    
//    re.context.strokePath()
//    
//    re.context.setFillColor(UIColor.green.cgColor)
//    
//    for point in lasso.debug.intersections {
//        re.context.addArc(
//            center: re.transform.applyTo(point).cgPoint(in: re.rect),
//            radius: 2,
//            startAngle: 0,
//            endAngle: CGFloat.pi * 2,
//            clockwise: true
//        )
//        re.context.fillPath()
//    }
//    
//    re.context.setLineWidth(CGFloat(2))
//    re.context.setStrokeColor(UIColor.black.withAlphaComponent(0.6).cgColor)
//    re.context.setLineCap(.round)
//    re.context.setLineJoin(.bevel)
//    
//    for point in lasso.points.enumerated() {
//        
//        if point.offset == 0 {
//            re.context.move(
//                to: re.transform.applyTo(point.element).cgPoint(in: re.rect)
//            )
//        } else {
//            re.context.addLine(
//                to: re.transform.applyTo(point.element).cgPoint(in: re.rect)
//            )
//        }
//    }
//    
//    re.context.strokePath()
//}
