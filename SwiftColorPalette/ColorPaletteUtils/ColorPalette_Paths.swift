//
//  ColorPalette_Paths.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

enum Paths {
    static let cornerRadius: CGFloat = 8.0
    
    static func drawSpeechBubbleWithArrowAtTop(path: UIBezierPath,
                                               lineWidth: CGFloat,
                                               radius: CGFloat,
                                               rectSize: CGSize,
                                               arrowCenterX: CGFloat,
                                               arrowSize: CGSize) {
        let LT = CGPoint(x: 0.0, y: 0.0)
        let RT = CGPoint(x: rectSize.width, y: 0.0)
        let RB = CGPoint(x: rectSize.width, y: rectSize.height)
        let LB = CGPoint(x: 0.0, y: rectSize.height)
        
        let offset = cornerRadius + lineWidth * 0.5
        
        let ltCenterPoint = CGPoint(x: LT.x + offset, y: LT.y + offset + arrowSize.height)
        let rtCenterPoint = CGPoint(x: RT.x - offset, y: RT.y + offset + arrowSize.height)
        let rbCenterPoint = CGPoint(x: RB.x - offset, y: RB.y - offset)
        let lbCenterPoint = CGPoint(x: LB.x + offset, y: LB.y - offset)
        
        let arrowX = max(LT.x + offset + arrowSize.width * 0.5, min(arrowCenterX, RT.x - offset - arrowSize.width * 0.5))
        let arrowLeft = CGPoint(x: arrowX - arrowSize.width * 0.5, y: LT.y + lineWidth * 0.5 + arrowSize.height)
        let arrowCenter = CGPoint(x: arrowX, y: lineWidth * 0.5)
        let arrowRight = CGPoint(x: arrowX + arrowSize.width * 0.5, y: LT.y + lineWidth * 0.5 + arrowSize.height)
        
        path.lineWidth = lineWidth
        
        path.move(to: CGPoint(x: LT.x + offset, y: LT.y + lineWidth * 0.5 + arrowSize.height))
        
        path.addLine(to: arrowLeft)
        path.addLine(to: arrowCenter)
        path.addLine(to: arrowRight)
        
        path.addArc(withCenter: rtCenterPoint, radius: cornerRadius, startAngle: 270.toRadian, endAngle: 0, clockwise: true)
        path.addArc(withCenter: rbCenterPoint, radius: cornerRadius, startAngle: 0, endAngle: 90.toRadian, clockwise: true)
        path.addArc(withCenter: lbCenterPoint, radius: cornerRadius, startAngle: 90.toRadian, endAngle: 180.toRadian, clockwise: true)
        path.addArc(withCenter: ltCenterPoint, radius: cornerRadius, startAngle: 180.toRadian, endAngle: 270.toRadian, clockwise: true)
        
        path.close()
    }
    static func drawPathBubbleWithBottomArrow(path: UIBezierPath,
                                              lineWidth: CGFloat,
                                              radius: CGFloat,
                                              rect: CGRect,
                                              arrowCenterX: CGFloat,
                                              arrowSize: CGSize) {
        let halfLineWidth: CGFloat = lineWidth * 0.5
        
        let leftTop: CGPoint = CGPoint(x: rect.origin.x, y: rect.origin.y)
        let rightTop: CGPoint = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)
        let rightBottom: CGPoint = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - (halfLineWidth + arrowSize.height))
        let leftBottom: CGPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height - (halfLineWidth + arrowSize.height))
        
        let arrowRightX: CGFloat = arrowCenterX + arrowSize.width * 0.5
        let arrowLeftX: CGFloat = arrowCenterX - arrowSize.width * 0.5
        let arrowY: CGFloat = rect.origin.y + rect.size.height - arrowSize.height - halfLineWidth
        let arrowCenterY: CGFloat = rect.origin.y + rect.size.height - halfLineWidth
        
        let startingPoint = CGPoint(x: leftTop.x + (radius + halfLineWidth), y: leftTop.y + halfLineWidth)
        let rtCenter = CGPoint(x: rightTop.x - (radius + halfLineWidth), y: rightTop.y + (radius + halfLineWidth))
        let rbCenter = CGPoint(x: rightBottom.x - (radius + halfLineWidth), y: rightBottom.y - (radius + halfLineWidth))
        let bottomArrowRightCenter = CGPoint(x: arrowRightX, y: arrowY)
        let bottomArrowCenterCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        let bottomArrowLeftCenter = CGPoint(x: arrowLeftX, y: arrowY)
        let lbCenter = CGPoint(x: leftBottom.x + (radius + halfLineWidth), y: leftBottom.y - (radius + halfLineWidth))
        let ltCenter = CGPoint(x: leftTop.x + (radius + halfLineWidth), y: leftTop.y + (radius + halfLineWidth))
        
        path.lineWidth = lineWidth
        
        path.move(to: startingPoint)
        
        path.addArc(withCenter: rtCenter, radius: radius, startAngle: 270.toRadian, endAngle: 0, clockwise: true)
        path.addArc(withCenter: rbCenter, radius: radius, startAngle: 0, endAngle: 90.toRadian, clockwise: true)
        path.addLine(to: bottomArrowRightCenter)
        path.addLine(to: bottomArrowCenterCenter)
        path.addLine(to: bottomArrowLeftCenter)
        path.addArc(withCenter: lbCenter, radius: radius, startAngle: 90.toRadian, endAngle: 180.toRadian, clockwise: true)
        path.addArc(withCenter: ltCenter, radius: radius, startAngle: 180.toRadian, endAngle: 270.toRadian, clockwise: true)
        
        path.close()
    }
}

private extension Int {
    var toRadian: CGFloat {
        return CGFloat(self) * 3.14 / 180.0
    }
}
