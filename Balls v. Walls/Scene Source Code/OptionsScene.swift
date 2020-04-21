//
//  OptionsScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 4/20/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import SpriteKit

class OptionsScene: SKScene {
    
    var testButton: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        testButton = SKSpriteNode(imageNamed: "menu_AUDIO")
        testButton.position = CGPoint(x: 150, y: 150)
    }
    
    
}
