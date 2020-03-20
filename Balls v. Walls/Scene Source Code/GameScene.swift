//
//  GameScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 10/12/19.
//  Copyright © 2019 Andrew Lundy. All rights reserved.
//

import SpriteKit
import GameplayKit

// GAME DESIGN NOTES:
// zPosition must stay between -10 and 10. Unless the node MUST be above/below all else, 11/-11 can be used respectively



let mainFont = "PressStart2P"
let defaults = UserDefaults.standard


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKShapeNode!
    var ground: SKShapeNode!
    var mainGround: Ground!
    
    
    var colors = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green]
    var scoreLabel: SKLabelNode!
    var gamePausedLabel: SKLabelNode!
  
    var pauseButton: SKSpriteNode!
    var resumePlayingButton: SKSpriteNode!
    var touchArea: SKSpriteNode!
    
    var gameOverTitle: SKLabelNode!
    
    var wall: Wall!
    var bounce: SKAction!
    
    var highScore: Int!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Points: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        highScore = defaults.object(forKey: "HighScore") as? Int ?? 0
        
        
        GlobalVariables.shared.gameState = .playing
        createBall()
//        createGround()
        createMainGround()
        
    }
    
    
    func createPlayingHUD() {
        scoreLabel = SKLabelNode(fontNamed: mainFont)
        scoreLabel.text = "Points: 0"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 32
        scoreLabel.zPosition = 11
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 125)
        scoreLabel.alpha = 0
        scoreLabel.run(SKAction.fadeIn(withDuration: 1))
        addChild(scoreLabel)
        
        pauseButton = SKSpriteNode(imageNamed: "Pause_Button")
        pauseButton.position = CGPoint(x: frame.maxX - 125, y: frame.minY + 110)
        pauseButton.size = CGSize(width: pauseButton.size.width * 0.08, height: pauseButton.size.height * 0.08)
        pauseButton.zPosition = 11
        pauseButton.alpha = 0
        pauseButton.name = "pauseButton"
        pauseButton.run(SKAction.fadeIn(withDuration: 1))
        addChild(pauseButton)
        
        touchArea = SKSpriteNode(color: .clear, size: CGSize(width: frame.width * 2, height: frame.height * 2))
        touchArea.position = CGPoint(x: 0, y: 0)
        touchArea.alpha = 0.1
        
        touchArea.name = "touchArea"
        touchArea.zPosition = 10
        addChild(touchArea)
    }
    
    func createBall() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, radius: 50, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        ball = SKShapeNode(path: path)
        ball.zPosition = -10
        ball.fillColor = colors.randomElement() ?? UIColor.red
        ball.strokeColor = ball.fillColor
        ball.position = CGPoint(x: frame.width / 6, y: frame.height + 50)
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        ball.physicsBody?.contactTestBitMask = CollisionTypes.wall.rawValue
        ball.physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue
        ball.physicsBody?.restitution = 0.6
        ball.physicsBody?.isDynamic = true
        
        let activatePlayer = SKAction.run {
            self.startWall()
            self.createPlayingHUD()
        }
        
        run(activatePlayer)
    }
   
    func createMainGround() {
        mainGround = Ground(frame: frame)
        mainGround.createGround(frame: frame)
        addChild(mainGround)
    }
    
  
    func createMainWall() {
        wall = Wall(frame: frame)
        wall.createWall(with: ball, frame: frame)
        addChild(wall)
    }
    
    func startWall() {
        let create = SKAction.run { [unowned self] in
            self.createMainWall()
        }
        
        let wait = SKAction.wait(forDuration: 2)
        let moveSequence = SKAction.sequence([wait, create, wait])
        let repeatForever = SKAction.repeatForever(moveSequence)
        run(repeatForever)
    }
    
    func endGame() {
        if score > highScore {
            highScore = score
            defaults.set(highScore, forKey: "HighScore")
        }
        print(score)
        
        scene?.removeAllActions()
        wall.isPaused = true
        wall.removeAllActions()
        
        
        let gameOver = SKLabelNode(fontNamed: mainFont)
        gameOver.fontSize = 50
        gameOver.text = "GAME OVER"
        gameOver.zPosition = 11
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY + 125)
        addChild(gameOver)
        
        let playAgain = SKSpriteNode(imageNamed: "Play_Again")
        playAgain.zPosition = 11
        playAgain.size = CGSize(width: frame.width / 2, height: 150)
        playAgain.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        playAgain.name = "playAgainButton"
        GlobalVariables.shared.bounce(node: playAgain)
        addChild(playAgain)
        
        let dimmer = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width * 2, height: frame.height * 2))
        dimmer.position = CGPoint(x: 0, y: 0)
        dimmer.alpha = 0.6
        dimmer.zPosition = 9
        addChild(dimmer)
        
        pauseButton.removeFromParent()
        
        GlobalVariables.shared.gameState = .gameOver
        ball.removeFromParent()
    }
    
    func pauseGame() {
        scene?.isPaused = true
        GlobalVariables.shared.gameState = .paused
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch GlobalVariables.shared.gameState {
        case .mainMenu:
            fatalError("MAIN MENU PRESSED ON GAMESCENE.SWIFT FILE - NOT SUPPOSED TO BE ABLE TO DO THIS HERE!")

        case .playing:
            for node in touchedNodes {
                if node.name == "touchArea" {
                    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
                    
                } else if node.name == "pauseButton" {
                    print("PAUSE BUTTON PRESSED")
                    print("STATE: PAUSED")
                    
                    pauseGame()
                    ball.physicsBody?.isDynamic = false
    
                    pauseButton.alpha = 0
   
                    resumePlayingButton = SKSpriteNode(imageNamed: "Play_Button")
                    resumePlayingButton.position = pauseButton.position
                    resumePlayingButton.size = CGSize(width: resumePlayingButton.size.width * 0.08, height: resumePlayingButton.size.height * 0.08)
                    
                    resumePlayingButton.name = "resumePlayButton"
                    addChild(resumePlayingButton)
                    
                    gamePausedLabel = SKLabelNode(fontNamed: mainFont)
                    gamePausedLabel.fontSize = 50
                    gamePausedLabel.text = "PAUSED"
                    gamePausedLabel.alpha = 1
                    gamePausedLabel.zPosition = 10
                    gamePausedLabel.position = CGPoint(x: frame.midX, y: frame.midY + 125)
                    addChild(gamePausedLabel)
                    
                    let mainMenuBtn = SKSpriteNode(imageNamed: "Main_Menu")
                    mainMenuBtn.zPosition = 11
                    mainMenuBtn.size = CGSize(width: frame.width / 2, height: 150)
                    mainMenuBtn.position = CGPoint(x: frame.midX, y: frame.midY)
                    mainMenuBtn.name = "mainMenuButton"
                    addChild(mainMenuBtn)
                    
                    
                }
            }

        case .gameOver:
            for node in touchedNodes {
                if node.name == "playAgainButton" {
                    guard let playScene = SKScene(fileNamed: "GameScene") else { return }
                    playScene.scaleMode = .aspectFill
                    view?.presentScene(playScene, transition: .crossFade(withDuration: 0.7))
                    
                }
            }
            
        case .paused:
            for node in touchedNodes {
                if node.name == "resumePlayButton" {
                    print("RESUME PLAYING TAPPED")
                    scene?.isPaused = false
                    GlobalVariables.shared.gameState = .playing
                    
                    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
                    
//                    let wait = SKAction.wait(forDuration: 3)
                    let fade = SKAction.fadeOut(withDuration: 1)
                
                    let engageBall = SKAction.run {
                        self.ball.physicsBody?.isDynamic = true
                    }

                    resumePlayingButton.run(SKAction.fadeOut(withDuration: 0))
                    pauseButton.run(SKAction.fadeIn(withDuration: 0))
                    
                    let engageBallSequence = SKAction.sequence([engageBall])
                    wall.pauseAndResumeWall(with: ball, frame: frame)
                    ball.run(engageBallSequence)
                    gamePausedLabel.run(fade)
                }
            }
            
        case .none:
            return
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
