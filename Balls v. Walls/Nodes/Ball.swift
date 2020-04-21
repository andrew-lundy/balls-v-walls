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
    
    var ballTextureNames: [String]!
    var currentTextureName: String!
    var ballTexture: SKTexture!
   
    
    init() {
        ballTextureNames = ["Ball_Blue", "Ball_Green", "Ball_Yellow", "Ball_Red"]
        currentTextureName = ballTextureNames.randomElement()
        ballTexture = SKTexture(imageNamed: "\(currentTextureName!)")
        let ballSize = CGSize(width: 125, height: 125)
        
        super.init(texture: ballTexture, color: UIColor.clear, size: ballSize)
        
        name = "BALL"
    
        switch currentTextureName {
        case "Ball_Blue":
            color = UIColor.blue
        case "Ball_Green":
            color = UIColor.green
        case "Ball_Yellow":
            color = UIColor.yellow
        case "Ball_Red":
            color = UIColor.red
        default:
            color = UIColor.red
        }
        
        physicsBody = SKPhysicsBody(circleOfRadius: 50)
        physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.wall.rawValue
        physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue
        physicsBody?.restitution = 0.6
        physicsBody?.isDynamic = true
    }
    
    
    func changeBallTexture() {
        ballTextureNames = ["Ball_Blue", "Ball_Green", "Ball_Yellow", "Ball_Red"]
        currentTextureName = ballTextureNames.randomElement()
        ballTexture = SKTexture(imageNamed: "\(currentTextureName!)")
        
        self.run(SKAction.setTexture(ballTexture))
        
        switch currentTextureName {
        case "Ball_Blue":
            color = UIColor.blue
        case "Ball_Green":
            color = UIColor.green
        case "Ball_Yellow":
            color = UIColor.yellow
        case "Ball_Red":
            color = UIColor.red
        default:
            color = UIColor.red
        }
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
