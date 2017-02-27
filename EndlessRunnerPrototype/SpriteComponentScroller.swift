//
//  ImageScroller.swift
//  skateboard
//
//  Created by André Niet on 08.02.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import UIKit
import GameplayKit

class SpriteComponentScroller {
    private var pool: GKEntityPool?
    private var runningImages = Array<GKEntity>()
    private var nextPosition: CGPoint = CGPoint.zero
    private var unitDirectionVector: CGPoint?

    init(viewPort: CGRect, pool: GKEntityPool, rotation: CGFloat = CGFloat(0)) {
        self.pool = pool
        
        guard pool.items.count > 0 else {
            fatalError("No items in pool")
        }
        
        //  Calculate unit direction vector
        unitDirectionVector = CGPoint(x: cos(rotation), y: sin(rotation))

        // Add initial image
        addInitialImages(withCount: pool.items.count - 1)
    }

    func update(withViewPort viewPort:CGRect) {
        let mostLeft = runningImages.first
        if let spriteComponentOfMostLeft = (mostLeft?.component(ofType: SpriteComponent.self)) {
            if viewPort.minX >= (spriteComponentOfMostLeft.node?.frame.maxX)! {
                removeImage(withImageToRemove: mostLeft!)
            }
        }
        
        let mostRight = runningImages.last
        if let spriteComponentOfMostRight = (mostRight?.component(ofType: SpriteComponent.self)) {
            if viewPort.maxX >= (spriteComponentOfMostRight.node?.frame.maxX)! {
                addImage()
            }
        }
        
    }
    
    private func removeImage(withImageToRemove image: GKEntity) {
        // Return image to pool
        pool?.addElement(image)
        // Remove image from runningImages
        runningImages.remove(object: image)
    }

    private func addImage() {
        let image = pool?.popFirst()
        if let spriteComponent = image!.component(ofType: SpriteComponent.self) {
            spriteComponent.nodePosition = nextPosition
            runningImages.append(image!);
            nextPosition += unitDirectionVector! * (spriteComponent.node?.size.width)!
        }

    }

    private func addInitialImages(withCount count: Int) {
        for _ in 0...count {
            addImage()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
