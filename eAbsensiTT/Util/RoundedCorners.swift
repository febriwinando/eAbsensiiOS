//
//  RoundedCorners.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 30/09/24.
//

import SwiftUI

struct RoundedCorners: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        let topLeftRadius = min(min(self.topLeft, height / 2), width / 2)
        let topRightRadius = min(min(self.topRight, height / 2), width / 2)
        let bottomLeftRadius = min(min(self.bottomLeft, height / 2), width / 2)
        let bottomRightRadius = min(min(self.bottomRight, height / 2), width / 2)
        
        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - topRightRadius, y: 0))
        path.addArc(center: CGPoint(x: width - topRightRadius, y: topRightRadius),
                    radius: topRightRadius,
                    startAngle: Angle.degrees(-90),
                    endAngle: Angle.degrees(0),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: height - bottomRightRadius))
        path.addArc(center: CGPoint(x: width - bottomRightRadius, y: height - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: Angle.degrees(0),
                    endAngle: Angle.degrees(90),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: bottomLeftRadius, y: height))
        path.addArc(center: CGPoint(x: bottomLeftRadius, y: height - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: Angle.degrees(90),
                    endAngle: Angle.degrees(180),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: topLeftRadius))
        path.addArc(center: CGPoint(x: topLeftRadius, y: topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: Angle.degrees(180),
                    endAngle: Angle.degrees(270),
                    clockwise: false)
        
        path.closeSubpath()
        
        return path
    }
}
