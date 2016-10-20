//
//  FightScene.swift
//  Monster
//
//  Created by Kevin Nguyen on 10/13/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

protocol FightSceneDelegate {
    var player: Monster? {get}
    var playerIndex: Int? {get}
    var opponent: Monster? {get}
    var opponentIndex: Int? {get}
    
    func gameOver()
}

class FightScene: SKScene, SKPhysicsContactDelegate {
    
    private var player : SKLabelNode?
    private var opponent : SKLabelNode?

    var fightSceneDelegate: FightSceneDelegate?
    
    let backgroundMusic = SKAudioNode(fileNamed: "Super Mario Bros. medley.mp3")
    var isMusicPlaying = false
    
    
    override func didMove(to view: SKView) {
        
        fight(player: (self.fightSceneDelegate?.player)!,
              playerIndex: (self.fightSceneDelegate?.playerIndex)!,
              opponent: (self.fightSceneDelegate?.opponent)!,
              opponentIndex: (self.fightSceneDelegate?.opponentIndex)!)
        
        // Add physics border around screen
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 1
        self.physicsBody = borderBody
        
        // Player Emoji
        self.player = self.childNode(withName: "//player") as? SKLabelNode
        if let player = self.player {
            player.alpha = 0.0
            player.text = self.fightSceneDelegate?.player?.emoji
            player.run(SKAction.fadeIn(withDuration: 2.0))
            player.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))

            player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.allowsRotation = true
            player.physicsBody?.isDynamic = false
        }
        
        // Opponent Emoji
        self.opponent = self.childNode(withName: "//opponent") as? SKLabelNode
        if let opponent = self.opponent {
            opponent.alpha = 0.0
            opponent.text = self.fightSceneDelegate?.opponent?.emoji
            opponent.run(SKAction.fadeIn(withDuration: 2.0))
            opponent.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(-M_PI), duration: 1)))
            
            opponent.physicsBody = SKPhysicsBody(circleOfRadius: opponent.frame.width/2)
            opponent.physicsBody?.affectedByGravity = false
            opponent.physicsBody?.allowsRotation = true
            opponent.physicsBody?.isDynamic = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {

            if !isMusicPlaying {
                addChild(backgroundMusic)
                isMusicPlaying = true
            } else {
                backgroundMusic.run(SKAction.stop())
                self.fightSceneDelegate?.gameOver()
                player?.run(SKAction.move(to: touch.location(in: self), duration: 0.5))
            }
        }
    }
    
    func showWinnerLabel(winner: String?) {
        let winner = SKLabelNode(text: winner! + " " + "Wins!!!")
        winner.position = CGPoint(x: 0, y: 0)
        winner.fontSize = 100
        addChild(winner)
    }
    
    func spawnPlayerWeapon(weapon: String?) {
        let weapon = SKLabelNode(text: weapon)
        weapon.fontSize = 100
        weapon.position = CGPoint(x: -170, y: 70)
        weapon.physicsBody = SKPhysicsBody(circleOfRadius: weapon.frame.width/2)
        weapon.physicsBody?.allowsRotation = true
        weapon.physicsBody?.isDynamic = true
        //weapon.physicsBody?.collisionBitMask = 0
        addChild(weapon)
        weapon.physicsBody?.applyImpulse(CGVector(dx: 200, dy: 200))

    }
    
    func spawnOpponentWeapon(weapon: String?) {
        let weapon = SKLabelNode(text: weapon)
        weapon.fontSize = 100
        weapon.position = CGPoint(x: 170, y: 70)
        weapon.physicsBody = SKPhysicsBody(circleOfRadius: weapon.frame.width/2)
        weapon.physicsBody?.allowsRotation = true
        weapon.physicsBody?.isDynamic = true
        //weapon.physicsBody?.collisionBitMask = 0
        addChild(weapon)
        weapon.physicsBody?.applyImpulse(CGVector(dx: -200, dy: 200))
    }
    
    func fight(player: Monster, playerIndex: Int, opponent: Monster, opponentIndex: Int) {
        var playerHP = 1000.0
        var opponentHP = 1000.0
        let playerAbility = Double(player.abilityPower)
        let playerSpecial = Double(player.specialPower)
        let opponentAbility = Double(opponent.abilityPower)
        let opponentSpecial = Double(opponent.specialPower)
        
        var gameOver = false
        var winner: Monster?
        
        func compareHP(x: Double, y: Double) {
            if (y <= 0 && x > 0) {
                print("Player Won")
                print(player.name)
            }
            else if (x <= 0 && y > 0) {
                print("Opponent Won")
                print(opponent.name)
            }
            else {
                print("Draw")
            }
        }
        
        while (!gameOver) {
            
            var opponentWeapon: String?
            var playerWeapon: String?
            
            // Randomizes the attack move and subtrack it from monster's health
            // Player HP
            if arc4random_uniform(2) == 0 {
                playerHP -= opponentAbility
                opponentWeapon = opponent.ability
            } else {
                playerHP -= opponentSpecial
                opponentWeapon = opponent.special
            }
            print(playerHP)
            
            // Opponent HP
            if arc4random_uniform(2) == 0 {
                opponentHP -= playerAbility
                playerWeapon = player.ability

            } else {
                opponentHP -= playerSpecial
                playerWeapon = player.special
            }
            print(opponentHP)
            
            // Spawn and launches skills or weapons per trade
            let wait = SKAction.wait(forDuration: 1, withRange: 1)
            let spawnPlayerWeapon = SKAction.run {
                self.spawnPlayerWeapon(weapon: playerWeapon)
            }
            let spawnOpponentWeapon = SKAction.run {
                self.spawnOpponentWeapon(weapon: opponentWeapon)
            }
            let sequence = SKAction.sequence([wait, spawnPlayerWeapon, wait, spawnOpponentWeapon])
            self.run(SKAction.repeat(sequence, count: 1))
            
            compareHP(x: playerHP, y: opponentHP)
            
            // If there's a winner, update the winner's Level + 1
            if playerHP <= 0.0 || opponentHP <= 0.0 {
                gameOver = true
                
                if (playerHP >= 0.0 && opponentHP <= 0.0) {
                    winner = player
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    do {
                        let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
                        monsters[playerIndex].level += 1
                    } catch { print("Fetching Monsters Failed") }
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    showWinnerLabel(winner: player.name)
                }
                if (playerHP <= 0.0 && opponentHP >= 0.0) {
                    winner = opponent
                    gameOver = true
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    do {
                        let monsters = try context.fetch(Monster.fetchRequest()) as! [Monster]
                        monsters[opponentIndex].level += 1
                    } catch { print("Fetching Monsters Failed") }
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    showWinnerLabel(winner: opponent.name)
                }
                else {
                    winner = nil
                }
            }
        }
    }
    
    // Particle Effect
    //            let emitterNode = SKEmitterNode(fileNamed: "BokehParticle.sks")
    //            emitterNode?.particlePosition = CGPoint(x: -172, y: 69.526)
    //            addChild(emitterNode!)
    //            // Don't forget to remove the emitter node after the explosion
    //            self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent() })
}
