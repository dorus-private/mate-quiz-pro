//
//  Triangle.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 23.03.24.
//
import SwiftUI

import SwiftUI

struct TriangleView: View {
    let angleA: Double
    let angleB: Double
    let angleC: Double

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let sideLength = min(geometry.size.width, geometry.size.height) / 2
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let xOffset = geometry.size.width / 2 - sideLength / 2
                let yOffset = geometry.size.height / 2 - sideLength / 2
                
                let pointA = CGPoint(x: center.x - xOffset + sideLength * cos(degreesToRadians(angleA)), y: center.y - yOffset + sideLength * sin(degreesToRadians(angleA)))
                let pointB = CGPoint(x: center.x - xOffset + sideLength * cos(degreesToRadians(angleB)), y: center.y - yOffset + sideLength * sin(degreesToRadians(angleB)))
                let pointC = CGPoint(x: center.x - xOffset + sideLength * cos(degreesToRadians(angleC)), y: center.y - yOffset + sideLength * sin(degreesToRadians(angleC)))

                path.move(to: pointA)
                path.addLine(to: pointB)
                path.addLine(to: pointC)
                path.addLine(to: pointA)
            }
            .stroke(Color.white, lineWidth: 2)
        }
    }

    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * Double.pi / 180)
    }
}
