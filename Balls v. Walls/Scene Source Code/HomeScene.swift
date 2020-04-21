//
//  HomeScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 2/13/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import SpriteKit
import GameplayKit


class HomeScene: SKScene {
    var playButton: SKSpriteNode!
    var optionsButton: SKSpriteNode!
    var highScoreLabel: SKLabelNode!

    var bounce: SKAction!
    
    var footer: SKLabelNode!
    var gameTitle: SKLabelNode!
    
    override func didMove(to view: SKView) {
        GlobalVariables.shared.gameState = .mainMenu
        if let highscore = defaults.object(forKey: "HighScore") as? Int {
            GlobalVariables.shared.highScore = highscore
            print("HIGH SCORE: \(GlobalVariables.shared.highScore!)")
        } else {
            defaults.set(0, forKey: "HighScore")
            GlobalVariables.shared.highScore = 0
            print("HIGHSCORE NOT FOUND")
        }
        createMainMenu()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
    
        guard GlobalVariables.shared.gameState == GameState.mainMenu else { return }
        
        for node in touchedNodes {
            if node.name == "playButton" {
                GlobalVariables.shared.gameState = .playing
                
                let fadeOut = SKAction.fadeOut(withDuration: 0.8)
                let remove = SKAction.removeFromParent()
                let wait = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([fadeOut, remove, wait])
                
                playButton.run(sequence)
                gameTitle.run(sequence)
                highScoreLabel.run(sequence)
                
                
                guard let playScene = SKScene(fileNamed: "GameScene") else { return }
                playScene.scaleMode = .aspectFill
                view?.presentScene(playScene, transition: .crossFade(withDuration: 0.7 ))
                
                print("PRESENT NEW SCENE")
                
            }
        }
    }
    
    
}

// - MARK: Custom Methods
extension HomeScene {
    func createMainMenu() {
        playButton = SKSpriteNode(imageNamed: "Main_Menu_Play")
        playButton.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        playButton.scale(to: CGSize(width: playButton.frame.width / 2, height: playButton.frame.height / 2))
        playButton.name = "playButton"
        GlobalVariables.shared.bounce(node: playButton)
        addChild(playButton)
        
        optionsButton = SKSpriteNode(imageNamed: "Options_Button")
        optionsButton.position.x = playButton.position.x
        optionsButton.position.y = playButton.position.y - 175
        optionsButton.scale(to: CGSize(width: playButton.frame.width / 2, height: playButton.frame.height / 2))
        optionsButton.name = "optionsButton"
        GlobalVariables.shared.bounce(node: optionsButton)
        addChild(optionsButton)
        
        highScoreLabel = SKLabelNode(fontNamed: mainFont)
        highScoreLabel.fontSize = 19
        highScoreLabel.text = "Score to Beat: \(GlobalVariables.shared.highScore!)"
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.position = CGPoint(x: frame.midX, y: playButton.position.y + 150)
        addChild(highScoreLabel)
      
//        footer = SKLabelNode(fontNamed: mainFont)
//        footer.fontSize = 17
//        footer.horizontalAlignmentMode = .center
//        footer.position = CGPoint(x: frame.width / 2, y: frame.minY + 40)
//        footer.zPosition = 2
//        footer.text = "Brought to you by Rusty Nail Games"
//        footer.fontColor = .white
//        addChild(footer)
        
        gameTitle = SKLabelNode(fontNamed: mainFont)
        gameTitle.position = CGPoint(x: frame.width / 2, y: frame.maxY - 250)
        gameTitle.fontSize = 40
        gameTitle.text = "Balls v. Walls"
        addChild(gameTitle)
    }
}


