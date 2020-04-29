//
//  PlaygroundFile.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 4/18/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import SpriteKit

class PlaygroundClass: SKScene {

    override func didMove(to view: SKView) {
        
        
        
        
        
        let texture = SKTexture(imageNamed: "textureImageName")
        let newNode = SKSpriteNode(texture: texture)
        newNode.physicsBody = SKPhysicsBody(texture: texture, size: newNode.size)
        
        
        
        
        
        
    }
    
    
}
