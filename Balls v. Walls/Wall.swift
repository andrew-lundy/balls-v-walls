//
//  Wall.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 11/14/19.
//  Copyright © 2019 Andrew Lundy. All rights reserved.
//

import GameplayKit
import SpriteKit

class Wall: SKNode {

    var colors = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green]
    var currentSections = [SKShapeNode]()
    
    var section: SKShapeNode!
    var xPosition: CGFloat!
    var sectionRect: CGRect!
    var endPosition: CGFloat!
    var moveAction: SKAction!
    var moveSequence: SKAction!
        
    override init() {
        super.init()
        xPosition = frame.maxX + 15
        sectionRect = CGRect(x: 0, y: 0, width: 25, height: frame.height / 4)
        endPosition = frame.width + (sectionRect.width * 2)
        moveAction = SKAction.moveTo(x: -endPosition, duration: 5)
        moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createWall(with ball: SKShapeNode, frame: CGRect) {
        
        colors.shuffle()
        
        for i in 0...3 {
            section = SKShapeNode(rect: sectionRect)
           
            section.isPaused = false
            section.position = CGPoint(x: xPosition, y: sectionRect.size.height * CGFloat(i) + 51)
            section.strokeColor = colors[i]
            section.fillColor = section.strokeColor

            // Move the physics body to match up with the wall section
            section.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sectionRect.width, height: sectionRect.height), center: CGPoint(x: sectionRect.width / 2, y: sectionRect.height / 2))
            section.physicsBody?.isDynamic = false
            
            section.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
            
            if section.fillColor == ball.fillColor {
                section.name = "scoreDetect"
                section.physicsBody?.collisionBitMask = 0
                section.physicsBody?.categoryBitMask = 0
            } else if section.fillColor != ball.fillColor {
                section.name = "wall"
                section.physicsBody?.collisionBitMask = CollisionTypes.ball.rawValue
                section.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            }
            
            addChild(section)
            section.run(moveSequence)
        }
    }
    
    func stopWall(frame: CGRect) {
        let stop = SKAction.stop()
        let wait = SKAction.wait(forDuration: 3)
        let engageWallSpeed = SKAction.run {
            self.section.speed = 1
        }
        
        let waitSequence = SKAction.sequence([stop, wait, engageWallSpeed])
        section.run(waitSequence)
    }
}


