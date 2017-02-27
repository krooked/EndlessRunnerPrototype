//
//  Skateboarder.swift
//  skateboard
//
//  Created by André Niet on 31.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import Foundation
import GameplayKit
import UIKit

class Image: GKEntity {
    init(imageName: String, position: CGPoint, rotation: CGFloat) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), position: position)
        spriteComponent.node?.zRotation = rotation
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

