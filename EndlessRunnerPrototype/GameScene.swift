//
//  GameScene.swift
//  skateboard
//
//  Created by André Niet on 26.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import SpriteKit
import GameplayKit

fileprivate enum VelocityState {
    case constant
    case increasing
    
    func acceleration() -> CGPoint {
        switch self {
        case .constant:
            return CGPoint.zero
        case .increasing:
            return GameplayConfiguration.unitDirectionVector * GameplayConfiguration.acceleration
        }
    }
}

class GameScene: SKScene {
    private var entityManager: EntityManager?
    private var viewPort = CGRect.zero
    private var groundScroller: SpriteComponentScroller?
    private var houseScroller: SpriteComponentScroller?
    private var streetScroller: SpriteComponentScroller?
    private var skateboarder: Skateboarder?
    private var lastTime: TimeInterval?
    private var velocity: CGPoint = GameplayConfiguration.velocity
    private var velocityState: VelocityState = .increasing
    
    private var cam: SKNode = {
        let cam = SKNode()
        cam.name = NodeName.camera
        return cam
    }()
    private var world: SKNode = {
        let world = SKNode()
        world.name = NodeName.world
        return world
    }()
    private var skateboardNode: SKNode = {() -> SKNode in
        let skateboardNode = SKNode()
        skateboardNode.name = NodeName.skateboarder
        return skateboardNode
    }()
    
    override func didMove(to view: SKView) {
        print("scene size: \(size)")
        
        // Entity Manager
        entityManager = EntityManager()
        
        backgroundColor = UIColor.cyan
        
        // Set viewPort
        viewPort.origin = cam.position
        viewPort.size = size
        
        // Center anchor point. That means everything is positioned relative to the center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Add world and camera node
        addChild(world)
        world.addChild(cam)
        
        // Create content nodes
        let backgroundNode = SKNode()
        backgroundNode.position.y = GameplayConfiguration.backgroundY
        backgroundNode.name = NodeName.background
        let streetNode = SKNode()
        streetNode.zPosition = 10
        streetNode.position.y = GameplayConfiguration.groundY - 100
        streetNode.name = NodeName.ground
        let groundNode = SKNode()
        groundNode.zPosition = 20
        groundNode.position.y = GameplayConfiguration.groundY
        groundNode.name = NodeName.ground
        
        // Add content and camera to the world
        world.addChild(backgroundNode)
        world.addChild(groundNode)
        world.addChild(streetNode)
        
        // Don´t add skateboardNode to the world because its position is static and should not be affected by the camera position
        skateboardNode.position -= CGPoint(x: viewPort.size.width / 2, y: viewPort.size.height / 2)
        skateboardNode.zPosition = 20
        addChild(skateboardNode)
        
        // Create skateboarder
        skateboarder = Skateboarder(imageName: "skater", position: GameplayConfiguration.skateboarderPosition)
        entityManager?.add(skateboarder!, contentNode: skateboardNode)
        
        // Grounds
        var groundPool = EntityPool(entityManger: entityManager!, contentNode: groundNode)
        groundPool.fill(withType: Image.self, andImageName: "sidewalk", andCount: 6, andRotation: GameplayConfiguration.grade.degreesToRadians())
        groundScroller = SpriteComponentScroller(viewPort: viewPort, pool: groundPool, rotation: GameplayConfiguration.grade.degreesToRadians())
        // Houses
        var housesPool = EntityPool(entityManger: entityManager!, contentNode: backgroundNode)
        housesPool.fill(withType: Image.self, andImageName: "houses2", andCount: 6, andRotation: CGFloat(0))
        houseScroller = SpriteComponentScroller(viewPort: viewPort, pool: housesPool, rotation: GameplayConfiguration.grade.degreesToRadians())
        //        // Street
        var streetPool = EntityPool(entityManger: entityManager!, contentNode: streetNode)
        streetPool.fill(withType: Image.self, andImageName: "street", andCount: 6, andRotation: GameplayConfiguration.grade.degreesToRadians())
        streetScroller = SpriteComponentScroller(viewPort: viewPort, pool: streetPool, rotation: GameplayConfiguration.grade.degreesToRadians())
    }
    
    /// Called once per frame if scene is not paused
    override func didFinishUpdate() {
        center(onNode: cam)
    }
    
    func center(onNode node: SKNode) {
        // Set viewport origin equal to camera position
        viewPort.origin = cam.position
        // Update scroller
        groundScroller?.update(withViewPort: viewPort)
        houseScroller?.update(withViewPort: viewPort)
        streetScroller?.update(withViewPort: viewPort)
        
        // Update world position
        let cameraPositionInScene = convert((cam.position), from: world)
        world.position = CGPoint(x: world.position.x - cameraPositionInScene.x, y: world.position.y - cameraPositionInScene.y)
        // Move the origin of the world to bottom left
        world.position -= CGPoint(x: viewPort.size.width / 2, y: viewPort.size.height / 2)
        
    }
    
    /// Update function
    ///
    /// - Parameter currentTime: current time in seconds
    override func update(_ currentTime: TimeInterval) {
        guard lastTime != nil else {
            lastTime = currentTime
            return
        }
        let deltaTime = CGFloat(currentTime.subtracting(lastTime!))
        lastTime = currentTime
        
        // Update entity manager
        entityManager?.update(TimeInterval(deltaTime))
        
        let acceleration = velocityState.acceleration()
        let velocity2 = velocity + acceleration * deltaTime
        
        let posDelta = (velocity + velocity2) / 2 * deltaTime
        // Move camera by velocity
        cam.position += posDelta
        
        // Add force to velocity
        velocity += acceleration * deltaTime
        
        // Check speed limit if you want
        let speedLimitIsReached = velocity.length() >= GameplayConfiguration.maxVelocity
        if speedLimitIsReached {
            velocityState = .constant
        } else {
            velocityState = .increasing
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            _ = touch.location(in: self)
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movementComponent = skateboarder?.component(ofType: PlatformMovementComponent.self) {
            
            // Testing braking and jumping
            for t in touches {
                if (t.location(in: self).x < 0) {
                    if movementComponent.movementState == .onGround {
                        if velocity.length() > 10 {
                            velocity *= CGFloat(0.99)
                        }
                    }
                } else {
                    movementComponent.jump()
                }
            }
        }
    }
    
}
