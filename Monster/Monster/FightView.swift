//
//  FightScene.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/13/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

class FightView: UIViewController, FightSceneDelegate {
    
    var player: Monster?
    var playerIndex: Int?
    var opponent: Monster?
    var opponentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Monsters Fighting:")
        print(player?.name)
        print(playerIndex)
        print(opponent?.name)
        print(opponentIndex)
        
        if let view = self.view as! SKView? {
            if let scene = FightScene(fileNamed: "FightScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                scene.fightSceneDelegate = self
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func gameOver() {
        print("GAME OVER MAN, GAMEOVER")
    }
}
