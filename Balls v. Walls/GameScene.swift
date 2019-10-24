//
//  GameScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 10/12/19.
//  Copyright © 2019 Andrew Lundy. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case ball = 1
    case wall = 2
    case ground = 4
    case scoreDetect = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKShapeNode!
    var colors: [UIColor] = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green]
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Points: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createBall()
        createGround()
        startWall()
        createScore()
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
        scoreLabel.text = "Points: 0"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 32
        scoreLabel.zPosition = 30
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 50)
        addChild(scoreLabel)
    }
    
    func createBall() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, radius: 50, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        ball = SKShapeNode(path: path)
        ball.zPosition = -50
        ball.fillColor = .red
        ball.strokeColor = .red
        ball.position = CGPoint(x: frame.width / 8, y: 500)
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.restitution = 0.6
        ball.physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        ball.physicsBody?.contactTestBitMask = CollisionTypes.wall.rawValue
        ball.physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue
        
        ball.physicsBody?.isDynamic = true
    }
   
    
    func createGround() {
        let groundRect = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        let ground = SKShapeNode(rect: groundRect)
        ground.zPosition = 5
        ground.fillColor = .white
        ground.strokeColor = .white
        addChild(ground)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundRect.width * 2, height: groundRect.height * 2))
        ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
        ground.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
        ground.physicsBody?.collisionBitMask = 0
        ground.physicsBody?.isDynamic = false
    }
    
    func createWall() {
        let xPosition = frame.maxX + 15
        let sectionRect = CGRect(x: 0, y: 0, width: 25, height: frame.height / 4)
        let endPosition = frame.width + (sectionRect.width * 2)
        let moveAction = SKAction.moveTo(x: -endPosition, duration: 5)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
      
        colors.shuffle()
        for i in 0...3 {
            let section = SKShapeNode(rect: sectionRect)
            
            section.position = CGPoint(x: xPosition, y: sectionRect.size.height * CGFloat(i) + 51)
            section.strokeColor = colors[i]
            section.fillColor = section.strokeColor

            section.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            section.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
          
            
            if section.fillColor == ball.fillColor {
                section.name = "scoreDetect"
                section.physicsBody?.collisionBitMask = 0
            } else if section.fillColor != ball.fillColor {
                section.name = "wall"
                section.physicsBody?.collisionBitMask = CollisionTypes.ball.rawValue
            }
            
            // Move the physics body to match up with the wall section
            section.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sectionRect.width, height: sectionRect.height * 2), center: CGPoint(x: sectionRect.width / 2, y: sectionRect.height))
            section.physicsBody?.isDynamic = false
            
            addChild(section)
            section.run(moveSequence)
        }
    }
    
    func startWall() {
        let create = SKAction.run { [unowned self] in
            self.createWall()
        }
        
        let wait = SKAction.wait(forDuration: 1.5)
        let moveSequence = SKAction.sequence([wait, create, wait])
        let repeatForever = SKAction.repeatForever(moveSequence)
        run(repeatForever)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func ballCollided(with node: SKNode) {
        if node.name == "scoreDetect" {
            print("PLAYER SCORED")
            score += 1
        } else if node.name == "wall" {
            print("PLAYER HIT WALL")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == ball {
            ballCollided(with: nodeB)
        } else if nodeB == ball {
            ballCollided(with: nodeA)
        }
    }
    
}
