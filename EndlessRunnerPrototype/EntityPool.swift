import Foundation
import UIKit
import GameplayKit

protocol GKEntityPool {
    var items: [GKEntity] { get set }
    mutating func addElement(_ element: GKEntity)
    mutating func popFirst() -> GKEntity
}

struct EntityPool: GKEntityPool {
    var items = [GKEntity]()
    var entityManager: EntityManager?
    var contentNode: SKNode?
    
    private var spriteCompnentNodeSize: CGSize? {
        let spriteComponent = items.first!.component(ofType: SpriteComponent.self)
        return spriteComponent?.node?.size
    }
    
    init(entityManger: EntityManager, contentNode: SKNode) {
        self.entityManager = entityManger
        self.contentNode = contentNode
    }
    
    /// AddElement is used for adding and returning an element
    ///
    /// - Parameter element: Element of type GKEntity
    mutating func addElement(_ element: GKEntity) {
        entityManager?.remove(element)
        items.append(element)
    }
    
    mutating func popFirst() -> GKEntity {
        let element = items.removeFirst()
        entityManager?.add(element, contentNode: contentNode!)
        return element
    }
    
    mutating func fill<T: GKEntity>(withType type: T.Type, andImageName name: String, andCount count: Int, andRotation rotation: CGFloat) {
        for _ in 0...count {
            let image = Image(imageName: name, position: CGPoint.zero, rotation: rotation)
            items.append(image)
        }
    }
    
}


