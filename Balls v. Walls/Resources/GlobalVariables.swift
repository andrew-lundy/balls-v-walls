//
//  GlobalVariables.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 2/13/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState {
    case playing
    case mainMenu
    case gameOver
    case paused
}

enum CollisionTypes: UInt32 {
    case ball = 1
    case wall = 2
    case ground = 4
    case scoreDetect = 8
}


struct GlobalVariables {
    static var shared = GlobalVariables()
    
    var highScore: Int?
    var gameState: GameState?
    var ballTexture = SKTexture(imageNamed: "Ball_Blue")
    
    func bounce(node: SKSpriteNode) {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.3)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.3)
        let scaleActionSequence = SKAction.sequence([moveUp, moveDown])
        let repeatAction = SKAction.repeatForever(scaleActionSequence)
        node.run(repeatAction)
    }
    
   
    
    
    private init() {}
}



