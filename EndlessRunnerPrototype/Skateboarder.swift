//
//  Skateboarder.swift
//  skateboard
//
//  Created by André Niet on 31.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import Foundation
import GameplayKit

class Skateboarder: GKEntity {
    
    init(imageName: String, position: CGPoint) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "skater"), position: position)
        spriteComponent.node?.zRotation = GameplayConfiguration.grade.degreesToRadians()
        spriteComponent.node?.zPosition = 10
        addComponent(spriteComponent)

        let movementComponent = PlatformMovementComponent(
                andGravity: GameplayConfiguration.gravity)
        addComponent(movementComponent)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

