//
//  ScannerCornerOverlay.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//
import SwiftUI

struct ScannerCornerOverlay: View {
    let size: CGFloat = 250
    let cornerLength: CGFloat = 45
    let cornerRadius: CGFloat = 35
    let lineWidth: CGFloat = 7
    
    var body: some View {
        ZStack {
            CornerOverlayShape(corner: .topLeft, cornerLength: cornerLength, cornerRadius: cornerRadius)
                .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            CornerOverlayShape(corner: .topRight, cornerLength: cornerLength, cornerRadius: cornerRadius)
                .stroke(Color.white,  style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            CornerOverlayShape(corner: .bottomLeft, cornerLength: cornerLength, cornerRadius: cornerRadius)
                .stroke(Color.white,  style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            CornerOverlayShape(corner: .bottomRight, cornerLength: cornerLength, cornerRadius: cornerRadius)
                .stroke(Color.white,  style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct CornerOverlayShape: Shape {
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    var corner: Corner
    var cornerLength: CGFloat = 30
    var cornerRadius: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch corner {
        case .topLeft:
            // Horizontal line
            path.move(to: CGPoint(x: cornerRadius, y: 0))
            path.addLine(to: CGPoint(x: cornerLength, y: 0))
            
            // Vertical line
            path.move(to: CGPoint(x: 0, y: cornerRadius))
            path.addLine(to: CGPoint(x: 0, y: cornerLength))
            
            // Arc
            path.move(to: CGPoint(x: 0, y: cornerRadius))
            path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(270),
                        clockwise: false)
            
        case .topRight:
            path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: 0))
            
            path.move(to: CGPoint(x: rect.maxX, y: cornerRadius))
            path.addLine(to: CGPoint(x: rect.maxX, y: cornerLength))
            
            path.move(to: CGPoint(x: rect.maxX, y: cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(270),
                        clockwise: true)
            
        case .bottomLeft:
            path.move(to: CGPoint(x: cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: cornerLength, y: rect.maxY))
            
            path.move(to: CGPoint(x: 0, y: rect.maxY - cornerRadius))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY - cornerLength))
            
            path.move(to: CGPoint(x: 0, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(90),
                        clockwise: true)
            
        case .bottomRight:
            path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))
            
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
            
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(90),
                        clockwise: false)
        }
        
        return path
    }
}
