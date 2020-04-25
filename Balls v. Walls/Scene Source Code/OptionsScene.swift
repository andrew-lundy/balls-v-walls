//
//  OptionsScene.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 4/20/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import SpriteKit


class OptionsScene: SKScene {
    
    var optionsTitle: SKSpriteNode!
    
    var audioTitle: SKSpriteNode!
    var audioOnButton: SKSpriteNode!
    var audioOffButton: SKSpriteNode!
    var modesTitle: SKSpriteNode!
    var modeReverseGravityButton: SKSpriteNode!
    var modeSpeedButton: SKSpriteNode!
    
    var themesTitle: SKSpriteNode!
    var themeBluesButton: SKSpriteNode!
    var themeElementsButton: SKSpriteNode!
    var themeGreensButton: SKSpriteNode!
    var themeIceCreamButton: SKSpriteNode!
    var themeMetalsButton: SKSpriteNode!
    var themeOrangesButton: SKSpriteNode!
    var themeOuterSpace: SKSpriteNode!
    
    
    
    var buttonSize: CGSize!
    var titleSize: CGSize!
    var leftSideMargin: CGFloat!
    
    var titles: [SKSpriteNode]!
    
    override func didMove(to view: SKView) {
        
        
        
        createMenu()
    }
    
    
    
    func createMenu() {
        leftSideMargin = frame.minX + 30
        titleSize = CGSize(width: 275, height: 200)
        
        
        optionsTitle = SKSpriteNode(imageNamed: "Menu_OPTIONS")
        audioTitle = SKSpriteNode(imageNamed: "Menu_AUDIO")
        audioOffButton = SKSpriteNode(imageNamed: "Menu_OFF")
        audioOnButton = SKSpriteNode(imageNamed: "Menu_ON")
        modesTitle = SKSpriteNode(imageNamed: "Menu_MODES")
        modeReverseGravityButton = SKSpriteNode(imageNamed: "Menu_REVERSE_GRAVITY")
        modeSpeedButton = SKSpriteNode(imageNamed: "Menu_SPEED")
        themesTitle = SKSpriteNode(imageNamed: "Menu_THEMES")

        
        titles = [audioTitle, modesTitle, themesTitle]
        
        for title in titles {
            title.anchorPoint = CGPoint(x: 0, y: 0)
        }
        
        optionsTitle.position = CGPoint(x: frame.width / 2, y: frame.maxY - 175)
        addChild(optionsTitle)
        
        audioTitle.size = titleSize
        audioTitle.position = CGPoint(x: leftSideMargin - 5, y: optionsTitle.position.y - 300)
        addChild(audioTitle)
        
        audioOffButton.size = CGSize(width: 275, height: 170)
        audioOffButton.anchorPoint = CGPoint(x: 1, y: 0)
        audioOffButton.position = CGPoint(x: frame.maxX - 10, y: audioTitle.position.y + 15)
        addChild(audioOffButton)
        
        audioOnButton.size = CGSize(width: 275, height: 170)
        audioOnButton.anchorPoint = CGPoint(x: 1, y: 0)
        audioOnButton.position = CGPoint(x: audioOffButton.position.x - 125, y: audioOffButton.position.y)
        addChild(audioOnButton)
                
        modesTitle.size = titleSize
        modesTitle.position = CGPoint(x: leftSideMargin, y: audioTitle.position.y - 175)
        addChild(modesTitle)
        
        modeReverseGravityButton.size = CGSize(width: 355, height: 350)
        modeReverseGravityButton.anchorPoint = CGPoint(x: 1, y: 0)
        modeReverseGravityButton.position = CGPoint(x: frame.maxX - 60, y: modesTitle.position.y - 75)
        addChild(modeReverseGravityButton)
        
        modeSpeedButton.size = CGSize(width: 335, height: 300)
        modeSpeedButton.anchorPoint = CGPoint(x: 1, y: 0)
        modeSpeedButton.position = CGPoint(x: frame.maxX + 10, y: modeReverseGravityButton.position.y - 60)
        addChild(modeSpeedButton)
        
        themesTitle.size = titleSize
        themesTitle.position = CGPoint(x: leftSideMargin + 5, y: modeSpeedButton.position.y - 75)
        addChild(themesTitle)
        
        addThemeImages()
        
    }
    
    func addThemeImage(at position: CGPoint, themeName: String) {
        var themeNameSprite: SKSpriteNode!
        themeNameSprite = SKSpriteNode(imageNamed: themeName)
        themeNameSprite.position = position
        themeNameSprite.size = CGSize(width: 350, height: 200)
        themeNameSprite.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        addChild(themeNameSprite)
    }
    
    
    func addThemeImages() {
        
        var imageNames = ["Blues", "Elements", "Reds", "Greens", "Metals", "OuterSpace", "Oranges", "Purples", "Pinks", "IceCream"]
        
        let midPoint = imageNames.count / 2
        let firstThird = imageNames[0...3]
        let secondThird = imageNames[4...6]
        let thirdThird = imageNames[7...9]
        
        
        var indexOfImage = 0
        for imageName in firstThird {
            addThemeImage(at: CGPoint(x: Int(leftSideMargin - 70) + (indexOfImage * 160), y: Int(themesTitle.position.y)), themeName: "Theme_\(imageName)")
            
            if indexOfImage == 3 {
                indexOfImage = 0
                break
            }
            indexOfImage += 1
        }
        
        for imageName in secondThird {
            addThemeImage(at: CGPoint(x: Int(leftSideMargin - 60) + (indexOfImage * 230), y: Int(themesTitle.position.y - 75)), themeName: "Theme_\(imageName)")
            
            if indexOfImage == 3 {
                indexOfImage = 0
                break
            }
            indexOfImage += 1
        }
        
                 
        addThemeImage(at: CGPoint(x: leftSideMargin - 50, y: themesTitle.position.y - 150), themeName: "Theme_Purples")
        addThemeImage(at: CGPoint(x: leftSideMargin + 175, y: themesTitle.position.y - 150), themeName: "Theme_IceCream")
        addThemeImage(at: CGPoint(x: leftSideMargin + 415, y: themesTitle.position.y - 150), themeName: "Theme_Pinks")
        
        
    }
}
