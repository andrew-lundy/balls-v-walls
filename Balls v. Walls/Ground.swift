//
//  Ground.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 2/18/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Ground: SKNode {
    var ground: SKShapeNode!
    
    func createGround(frame: CGRect) {
          let groundRect = CGRect(x: frame.maxX + 50, y: 0, width: frame.width, height: 50)
          ground = SKShapeNode(rect: groundRect)
          ground.zPosition = 1
          ground.fillColor = UIColor(red: 156/255, green: 157/255, blue: 158/255, alpha: 1)
          ground.strokeColor = UIColor(red: 156/255, green: 157/255, blue: 158/255, alpha: 1)
          addChild(ground)
          
          ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundRect.width * 2, height: groundRect.height * 2))
          ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
          ground.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
          ground.physicsBody?.collisionBitMask = 0
          ground.physicsBody?.isDynamic = false
    }
    
    func moveGround(frame: CGRect) {
        let moveAction = SKAction.moveTo(x: frame.minX, duration: 0.5)
        
        ground.run(moveAction)
    }
    
}
