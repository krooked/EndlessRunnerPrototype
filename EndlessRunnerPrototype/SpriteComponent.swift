//
//  SpriteComponent.swift
//  skateboard
//
//  Created by André Niet on 30.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {
    var node: SKSpriteNode?
    var nodePosition: CGPoint {
        set {
            node?.position = newValue
        }
        get {
            return node!.position
        }
    }

    init(texture: SKTexture, position: CGPoint) {
        super.init()

        node = SKSpriteNode(texture: texture, color: SKColor.white, size: texture.size())
        // Set position
        nodePosition = position
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}



