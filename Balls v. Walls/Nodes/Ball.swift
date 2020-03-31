//
//  Ball.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 3/30/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import Foundation
import SpriteKit


class Ball: SKSpriteNode {
    init() {
        let ballTexture = SKTexture(imageNamed: "Ball_Blue")
        let ballSize = CGSize(width: 125, height: 125)
        super.init(texture: ballTexture, color: UIColor.clear, size: ballSize)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 50)
        physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.wall.rawValue
        physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue
        physicsBody?.restitution = 0.6
        physicsBody?.isDynamic = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
