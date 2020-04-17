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
    var groundRect: CGRect!
    
    var startingXPosition: CGFloat!
    var endingXPosition: CGFloat!
    
    var moveAction: SKAction!
    
    
    init(frame: CGRect) {
        super.init()
        
        startingXPosition = frame.minX
        endingXPosition = frame.minX
        groundRect = CGRect(x: startingXPosition, y: 0, width: frame.width, height: 50)
        moveAction = SKAction.moveTo(x: endingXPosition, duration: 0.8)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func createGround(frame: CGRect) {
        ground = SKShapeNode(rect: groundRect)
        ground.zPosition = 1
        ground.fillColor = UIColor(red: 156/255, green: 157/255, blue: 158/255, alpha: 1)
        ground.strokeColor = UIColor(red: 156/255, green: 157/255, blue: 158/255, alpha: 1)
        
      
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundRect.width * 2, height: groundRect.height * 2))
        ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
        ground.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
        ground.physicsBody?.collisionBitMask = CollisionTypes.ball.rawValue
        ground.physicsBody?.isDynamic = false
        ground.name = "ground"
        addChild(ground)
    }
}
