//
//  LaunchScreen.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 4/17/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import SpriteKit
import GameplayKit

class LaunchScreen: SKScene {
    
    override func didMove(to view: SKView) {
        transitionScene(scene: "HomeScene")
    }
    
    func transitionScene(scene: String) {
        guard let homeScene = SKScene(fileNamed: scene) else { return }
        homeScene.scaleMode = .aspectFill
        
      
        
        let wait = SKAction.wait(forDuration: 1.8)

        
        view?.scene?.run(wait, completion: {
            self.view?.presentScene(homeScene, transition: .crossFade(withDuration: 2))
        })

        
    }
}
