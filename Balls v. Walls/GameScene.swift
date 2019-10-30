//
//  GameScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 10/12/19.
//  Copyright © 2019 Andrew Lundy. All rights reserved.
//

import SpriteKit
import GameplayKit


enum GameState {
    case playing
    case mainMenu
    case gameOver 
}

enum CollisionTypes: UInt32 {
    case ball = 1
    case wall = 2
    case ground = 4
    case scoreDetect = 8
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKShapeNode!
    var colors = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green]
    var scoreLabel: SKLabelNode!
    var playButton: SKSpriteNode!
    var footer: SKLabelNode!
    var gameTitle: SKLabelNode!
    
    var gameState = GameState.mainMenu
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Points: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createBall()
        createGround()
        createMainMenu()
    }
    
    func createMainMenu() {
        playButton = SKSpriteNode(imageNamed: "Main_Menu_Play")
        playButton.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        playButton.scale(to: CGSize(width: playButton.frame.width / 2, height: playButton.frame.height / 2))
        playButton.name = "playButton"
        addChild(playButton)
        
        footer = SKLabelNode(fontNamed: "AvenirNext-UltraLightItalic")
        footer.position = CGPoint(x: 10, y: 17)
        footer.zPosition = 6
        footer.horizontalAlignmentMode = .left
        footer.text = "Designed and developed by Andrew Lundy"
        footer.fontColor = .black
        addChild(footer)
        
        gameTitle = SKLabelNode(fontNamed: "PressStart2P")
        gameTitle.position = CGPoint(x: frame.width / 2, y: frame.maxY - 250)
        gameTitle.fontSize = 40
        gameTitle.text = "Balls v. Walls"
        addChild(gameTitle)
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
        ball.fillColor = colors.randomElement() ?? UIColor.red
        ball.strokeColor = ball.fillColor
        ball.position = CGPoint(x: frame.width / 8, y: 500)
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.restitution = 0.6
        ball.physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        ball.physicsBody?.contactTestBitMask = CollisionTypes.wall.rawValue
        ball.physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue
        
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
    
    func startWall() {
        let create = SKAction.run { [unowned self] in
            self.createWall()
        }
        
        let wait = SKAction.wait(forDuration: 1.5)
        let moveSequence = SKAction.sequence([wait, create, wait])
        let repeatForever = SKAction.repeatForever(moveSequence)
        run(repeatForever)
    }
    
    func endGame() {
        speed = 0
        ball.removeFromParent()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch gameState {
        case .mainMenu:
            for node in touchedNodes {
                if node.name == "playButton" {
                    gameState = .playing
                    
                    let fadeOut = SKAction.fadeOut(withDuration: 1)
                    let remove = SKAction.removeFromParent()
                    let wait = SKAction.wait(forDuration: 0.5)
                    
                    let sequence = SKAction.sequence([fadeOut, remove, wait])

                    playButton.run(sequence)
                    gameTitle.run(sequence)
                    footer.run(sequence)
                    
                    let activatePlayer = SKAction.run {
                        self.startWall()
                        self.createScore()
                    }
                    
                    run(activatePlayer)
                    
                    print("Play Button tapped")
                }
            }
        case .playing:
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
            print("playing")
        case .gameOver:
            print("Game over")
        }
        
       
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func ballCollided(with node: SKNode) {
        if node.name == "scoreDetect" {
            print("PLAYER SCORED")
            score += 1
            ball.fillColor = colors.randomElement() ?? UIColor.red
        } else if node.name == "wall" {
            print("PLAYER HIT WALL")
            endGame()
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
