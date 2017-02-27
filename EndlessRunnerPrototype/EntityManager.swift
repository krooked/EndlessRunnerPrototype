
//  EntityManager.swift
//  skateboard
//
//  Created by André Niet on 30.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let spriteSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let moveSystem = GKComponentSystem(componentClass: PlatformMovementComponent.self)
        return [spriteSystem, moveSystem]
    }()
    
    func add(_ entity: GKEntity, contentNode: SKNode) {
        entities.insert(entity)
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            contentNode.addChild(spriteComponent.node!)
        }
    }
    
    func remove(_ entity: GKEntity) {
        entities.remove(entity)
        toRemove.insert(entity)
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node?.removeFromParent()
        }
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: curRemove)
            }
        }
        toRemove.removeAll()
    }
    
}
