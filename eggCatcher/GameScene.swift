//
//  GameScene.swift
//  project1
//
//  Created by user166111 on 4/13/20.
//  Copyright © 2020 unibuc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var level = 1{
        didSet{
            levelLabel.text = "Level: \(level)"
        }
    }
    
    let background = SKSpriteNode(imageNamed: "background")
    let hen1 = SKSpriteNode(imageNamed: "hen")
    let hen2 = SKSpriteNode(imageNamed: "hen")
    let hen3 = SKSpriteNode(imageNamed: "hen")
    let hen4 = SKSpriteNode(imageNamed: "hen")
    let fox = SKSpriteNode(imageNamed: "fox")
    let egg = SKSpriteNode(imageNamed: "egg")
    let poisonedEgg = SKSpriteNode(imageNamed: "poisonedEgg")
    
    let None: UInt32 = 0b0
    let Player: UInt32 = 0b1
    let Egg: UInt32 = 0b10
    let BadEgg: UInt32 = 0b100
    
    var eggSpeed = 2.0
    var spawnDelay = 2.0

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        hen1.size = CGSize(width: 100, height: 100)
        hen2.size = CGSize(width: 100, height: 100)
        hen3.size = CGSize(width: 100, height: 100)
        hen4.size = CGSize(width: 100, height: 100)
        fox.size = CGSize(width: 128, height: 128)
        egg.size = CGSize(width: 50, height: 50)
        poisonedEgg.size = egg.size
        background.size = self.size
        //background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        fox.position = CGPoint(x: 0, y: (-1) * self.size.height * 0.4)
        fox.zPosition = 2
        fox.physicsBody = SKPhysicsBody(rectangleOf: fox.size)
        fox.physicsBody!.affectedByGravity = false
        fox.physicsBody!.categoryBitMask = Player
        fox.physicsBody!.collisionBitMask = None
        fox.physicsBody!.contactTestBitMask = Egg | BadEgg
        self.addChild(fox)
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        scoreLabel.position = CGPoint(x: (-1) * self.size.width * 0.35, y: self.size.height * 0.43)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        levelLabel = SKLabelNode()
        levelLabel.text = "Level: 1"
        levelLabel.fontColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        levelLabel.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.43)
        levelLabel.zPosition = 2
        self.addChild(levelLabel)
        
        hen1.position = CGPoint(x: -1 * self.size.width * 0.35, y: self.size.height * 0.35)
        hen1.zPosition = 2
        self.addChild(hen1)
        
        hen2.position = CGPoint(x: -1 * self.size.width * 0.12, y: self.size.height * 0.35)
        hen2.zPosition = 2
        self.addChild(hen2)
        
        hen3.position = CGPoint(x: self.size.width * 0.12, y: self.size.height * 0.35)
        hen3.zPosition = 2
        self.addChild(hen3)
        
        
        hen4.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.35)
        hen4.zPosition = 2
        self.addChild(hen4)
        
        nextLevel(speed: eggSpeed, timeBetweenSpawn: spawnDelay)
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if (score == 30){
            level += 1
            score = 0
            nextLevel(speed: eggSpeed - Double(level) * 0.05, timeBetweenSpawn: spawnDelay - Double(level) * 0.1)
            
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            fox.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            fox.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    func collisionBetween(eggObject: SKNode, player: SKNode){
        
    }
    func spawnEgg(speed: double_t){
        let randomHen = Int.random(in: 1 ... 4)
        let poisonedEggChance = Float.random(in: 0 ... 1)
        
        var isBad = false
        if poisonedEggChance < 0.2{
            isBad = true
        }
        
        if randomHen == 1 {
            dropEgg(spawnPoint: hen1.position, speed: speed, isBad: isBad)
        }
        else if randomHen == 2{
            dropEgg(spawnPoint: hen2.position, speed: speed, isBad: isBad)
        }
        else if randomHen == 3{
            dropEgg(spawnPoint: hen3.position, speed: speed, isBad: isBad)
        }
        else if randomHen == 4{
            dropEgg(spawnPoint: hen4.position, speed: speed, isBad: isBad)
        }
        
    }
    func dropEgg(spawnPoint: CGPoint, speed: double_t, isBad: Bool){
        var eggClone = SKSpriteNode()
        
        if isBad == true{
            eggClone = SKSpriteNode(imageNamed: "poisonedEgg")
            eggClone.name = "badEgg"
            eggClone.size = CGSize(width: 50, height: 50)
            eggClone.physicsBody = SKPhysicsBody(rectangleOf: eggClone.size)
            eggClone.physicsBody!.categoryBitMask = BadEgg
            eggClone.physicsBody!.collisionBitMask = None
            eggClone.physicsBody!.contactTestBitMask = Player
        }
        else{
            eggClone = SKSpriteNode(imageNamed: "egg")
            eggClone.name = "goodEgg"
            eggClone.size = CGSize(width: 50, height: 50)
            eggClone.physicsBody = SKPhysicsBody(rectangleOf: eggClone.size)
            eggClone.physicsBody!.categoryBitMask = Egg
            eggClone.physicsBody!.collisionBitMask = None
            eggClone.physicsBody!.contactTestBitMask = Player

        }
        
        eggClone.position = spawnPoint
        
        eggClone.physicsBody!.affectedByGravity = false
        eggClone.zPosition = 1
        
        self.addChild(eggClone)
        
        let moveEgg = SKAction.moveTo(y: self.size.height * (-1), duration: speed)
        let deleteEgg = SKAction.removeFromParent()
        let eggSequence = SKAction.sequence([moveEgg, deleteEgg])
        eggClone.run(eggSequence)
        
        
    }
    func nextLevel(speed: double_t, timeBetweenSpawn: double_t){
        let spawn = SKAction.run {
            self.spawnEgg(speed: speed)
        }
        let waitToSpawn = SKAction.wait(forDuration: timeBetweenSpawn)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == Player && contact.bodyB.categoryBitMask == Egg) || (contact.bodyA.categoryBitMask == Egg && contact.bodyB.categoryBitMask == Player){
            score += 10
            if contact.bodyA.categoryBitMask == Egg{
                contact.bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.categoryBitMask == Egg{
                contact.bodyB.node?.removeFromParent()
            }
        }
        else if (contact.bodyA.categoryBitMask == Player && contact.bodyB.categoryBitMask == BadEgg) || (contact.bodyA.categoryBitMask == BadEgg && contact.bodyB.categoryBitMask == Player){
            score -= 30
            if contact.bodyA.categoryBitMask == BadEgg{
                contact.bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.categoryBitMask == BadEgg{
                contact.bodyB.node?.removeFromParent()
            }
            
        }
    }
}
