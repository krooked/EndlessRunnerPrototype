//
//  PlatformMovementComponent.swift
//  skateboard
//
//  Created by André Niet on 06.02.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import UIKit
import GameplayKit

enum MovementState {
    case jumping
    case onGround
    
    func gravity(fromGravity gravity: CGFloat) -> CGFloat {
        switch self {
        case .jumping:
            return gravity
        case .onGround:
            return CGFloat(0)
        }
    }
    
    func canJump() -> Bool {
        switch self {
        case .jumping:
            return false
        case .onGround:
            return true
        }
    }
    
}

class PlatformMovementComponent: GKComponent {
    
    /// The `RenderComponent` for this component's entity.
    var renderComponent: SpriteComponent {
        guard let renderComponent = entity?.component(ofType: SpriteComponent.self) else { fatalError("A MovementComponent's entity must have a SpriteComponent") }
        return renderComponent
    }
    
    // The position of the node
    public private(set) var position: CGPoint {
        set {
            renderComponent.node?.position = newValue
        }
        get  {
            return renderComponent.node!.position
        }
    }
    
    // State
    var movementState: MovementState = .onGround
    
    private var gravity = CGFloat(0)
    private var groundY = CGFloat(0)
    private var velocity = CGPoint.zero
    
    
    init(andGravity gravity: CGFloat) {
        super.init()
        self.gravity = gravity
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.groundY = renderComponent.nodePosition.y
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        let deltaTime = CGFloat(seconds)
        
        let force = CGPoint(x: 0, y: -movementState.gravity(fromGravity: gravity)) * GameplayConfiguration.skateboarderMass
        let velocity2 = velocity + force * deltaTime
        // Add velocity to position
        position += (velocity + velocity2) / 2 * deltaTime
        // Add force to velocity
        velocity += force * deltaTime
        
        // Check if player is on ground
        let isPlayerOnGround = position.y <= groundY + 1
        if isPlayerOnGround {
            // Set position to ground position
            position.y = groundY + CGFloat.random(min: -1, max: 1)
            // Set velocity to zero
            velocity.y = 0
            // Update state
            movementState = .onGround
        } else {
            // Update state
            movementState = .jumping
        }
        
    }
    
    func jump() {
        if movementState.canJump() {
            velocity.y += GameplayConfiguration.jumpForce.y
        }
    }
    


}

