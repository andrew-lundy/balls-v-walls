//
//  GlobalVariables.swift
//  Balls v. Walls
//
//  Created by Andrew Lundy on 2/13/20.
//  Copyright © 2020 Andrew Lundy. All rights reserved.
//

import Foundation


enum GameState {
    case playing
    case mainMenu
    case gameOver
    case paused
}

enum CollisionTypes: UInt32 {
    case ball = 1
    case wall = 2
    case ground = 4
    case scoreDetect = 8
}


struct GlobalVariables {
    static var shared = GlobalVariables()
    
    var highScore: Int?
    var gameState: GameState?
    
    private init() {}
}



