//
//  Constants.swift
//  skateboard
//
//  Created by André Niet on 31.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameplayConfiguration {
    static let numGrounds = 6
    static let groundY = CGFloat(240)
    static let backgroundY = CGFloat(460)
    static let skateboarderPosition = CGPoint(x: 200, y: 290)
    static let maxVelocity = CGFloat(9000)
    static let grade = CGFloat(-8.0)
    static let skateboarderMass = CGFloat(120)

    // Unit is points per second
    static let velocity = CGPoint(x: 0, y: 0)
    static let acceleration: CGFloat = {
        let result = GameplayConfiguration.gravity * sin(GameplayConfiguration.grade.degreesToRadians()) * GameplayConfiguration.skateboarderMass
        // Mulitply with -1 because of negative given grad
        print("acceleration: \(result * -1)")
        return result * -1
    }()
    static let unitDirectionVector: CGPoint = {
        return CGPoint(x: cos(GameplayConfiguration.grade.degreesToRadians()), y: sin(GameplayConfiguration.grade.degreesToRadians()))
    }()
    static let gravity = CGFloat(9.81)
    static let jumpForce = CGPoint(x: 0, y: 400)
}

struct NodeName {
    static let ground = "ground"
    static let background = "background"
    static let skateboarder = "skateboarder"
    static let camera = "camera"
    static let world = "world"
}
