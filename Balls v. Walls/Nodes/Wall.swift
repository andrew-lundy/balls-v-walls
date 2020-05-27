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
    
    var section: SKShapeNode!
    var xPosition: CGFloat!
    var sectionRect: CGRect!
    var endPosition: CGFloat!
    var moveAction: SKAction!
    var moveSequence: SKAction!
  
    var wallSections = [SKShapeNode]()
    
    
    init(frame: CGRect) {
        super.init()
      
        xPosition = frame.maxX + 15
        sectionRect = CGRect(x: 0, y: 0, width: 25, height: frame.height / 4)
        endPosition = frame.width + (sectionRect.width * 2)
        moveAction = SKAction.moveTo(x: -endPosition, duration: 3.5)
        moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createWall(with ball: SKSpriteNode, frame: CGRect) {
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
            
            if section.fillColor == ball.color {
                section.name = "scoreDetect"
                section.physicsBody?.collisionBitMask = 0
                section.physicsBody?.categoryBitMask = 0
            } else if section.fillColor != ball.color {
                section.name = "wall"
                section.physicsBody?.collisionBitMask = CollisionTypes.ball.rawValue
                section.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            }
            
            addChild(section)
            section.run(moveSequence)
        }
    }
    
    
    func stopWall(with ball: SKSpriteNode, frame: CGRect) {
        for child in children {
            if child.name == "wall" || child.name == "scoreDetect" {
                child.removeAllActions()
            }
        }
    }
    
    func pauseAndResumeWall(with ball: SKSpriteNode, frame: CGRect) {
        for child in children {
            if child.name == "wall" || child.name == "scoreDetect" {
                child.removeAllActions()
                let wait = SKAction.wait(forDuration: 3)
                
                let resume = SKAction.run {
                    child.isPaused = false
                }
     
                let remove = SKAction.removeFromParent()
                let resumeWall = SKAction.sequence([ moveAction, remove])
                child.run(resumeWall)
                
                
            }
        }
        print("PAUSE WALL")
    }
    
//    func resetWall(with ball: SKShapeNode, frame: CGRect) {
//        let wait = SKAction.wait(forDuration: 6)
//        let createWall = SKAction.run {
//            self.createWall(with: ball, frame: frame)
//        }
//
//        let resetSequence = SKAction.sequence([wait, createWall])
//        self.run(resetSequence)
//    }
}


