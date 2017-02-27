//
//  GameViewController.swift
//  skateboard
//
//  Created by André Niet on 26.01.17.
//  Copyright © 2017 André Niet. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var stateMachine: GKStateMachine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view.counds.size: \(view.bounds.size)")
        
        let aspectRatio = view.bounds.size.width / view.bounds.size.height
        
        // Create root SKVIEW
        view = SKView(frame: view.bounds)
        
        // Same with for all devices. For an endless runner its best to have a constant width
        let scene = GameScene(size:CGSize(width: 1136, height: 1136 / aspectRatio))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
