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
    
    var highScoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var retryButton: UIButton!
    var scoreLabel: SKLabelNode!
    var levelUpLabel: SKLabelNode!
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var highScore = UserDefaults().integer(forKey: "highscore")
    
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
    let bomb = SKSpriteNode(imageNamed: "bomb")
    
    var health1 = SKSpriteNode(imageNamed: "health")
    var health2 = SKSpriteNode(imageNamed: "health")
    var health3 = SKSpriteNode(imageNamed: "health")
    
    let None: UInt32 = 0b0
    let Player: UInt32 = 0b1
    let Egg: UInt32 = 0b10
    let BadEgg: UInt32 = 0b100
    let Bomb: UInt32 = 0b1000
    
    var eggSpeed = 2.0
    var spawnDelay = 2.0
    var scoreForNextLevel = 30
    
    var lives = 3
    var levelMultiplierForEggTarget = 0.0
    var levelMultiplierForHenMovement = 0.0
    
    var hen1Destination = 0.0
    var hen2Destination = 0.0
    var hen3Destination = 0.0
    var hen4Destination =  0.0
    
    var henSpeed = 3.0

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        health1.size = CGSize(width: 90, height: 90)
        health1.position = CGPoint(x: self.size.width * (-0.1), y: self.size.height * 0.43)
        health1.zPosition = 3
        self.addChild(health1)
        
        health2.size = CGSize(width: 90, height: 90)
        health2.position = CGPoint(x: 0, y: self.size.height * 0.43)
        health2.zPosition = 3
        self.addChild(health2)
        
        health3.size = CGSize(width: 90, height: 90)
        health3.position = CGPoint(x: self.size.width * (0.1), y: self.size.height * 0.43)
        health3.zPosition = 3
        self.addChild(health3)
        
        hen1.size = CGSize(width: 100, height: 100)
        hen2.size = CGSize(width: 100, height: 100)
        hen3.size = CGSize(width: 100, height: 100)
        hen4.size = CGSize(width: 100, height: 100)
        fox.size = CGSize(width: 180, height: 180)
        egg.size = CGSize(width: 80, height: 80)
        poisonedEgg.size = egg.size
        background.size = self.size
        
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        fox.position = CGPoint(x: 0, y: (-1) * self.size.height * 0.4)
        fox.zPosition = 2
        fox.physicsBody = SKPhysicsBody(rectangleOf: fox.size)
        fox.physicsBody!.affectedByGravity = false
        fox.physicsBody!.categoryBitMask = Player
        fox.physicsBody!.collisionBitMask = None
        fox.physicsBody!.contactTestBitMask = Egg | BadEgg | Bomb
        self.addChild(fox)
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 45
        scoreLabel.fontColor =  .black
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.position = CGPoint(x: (-1) * self.size.width * 0.32, y: self.size.height * 0.43)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        levelLabel = SKLabelNode()
        levelLabel.text = "Level: 1"
        levelLabel.fontSize = 45
        levelLabel.fontColor = .black
        levelLabel.fontName = "AvenirNext-Bold"
        levelLabel.position = CGPoint(x: self.size.width * 0.32, y: self.size.height * 0.43)
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
        
        if (score >= scoreForNextLevel){
            level += 1
            scoreForNextLevel *= 2
            nextLevel(speed: eggSpeed - Double(level) * 0.05, timeBetweenSpawn: spawnDelay - Double(level) * 0.1)
            levelMultiplierForEggTarget += 0.2
            levelMultiplierForHenMovement += 0.2
            
        }
        
        if(score < 0){
            gameOver()
        }
        
        if(lives <= 0){
            gameOver()
        }
        moveHens()
        if lives < 3{
            health3.isHidden = true
        }
        if lives < 2{
            health2.isHidden = true
        }
        if lives < 1{
            health1.isHidden = true
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if fox.position.x < location.x{
                fox.xScale = 1
            }
            else{
                fox.xScale = -1
            }
            fox.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if fox.position.x < location.x{
                fox.xScale = 1
            }
            else{
                fox.xScale = -1
            }
            fox.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    
    
    func  generateRandPosition(position: CGPoint) -> CGFloat{
        let maxX = self.size.width/2
        let minX = maxX * (-1)
        
        let randX = CGFloat.random(in: minX ... maxX)
        
        return randX
    }
    
    
    func moveHens(){
        if abs(hen1.position.x - CGFloat(hen1Destination)) > 2{
            if hen1.position.x - CGFloat(hen1Destination) > 0 {
                hen1.position.x -= CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
            else{
                hen1.position.x += CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
            
        }
        else{
            hen1Destination = Double(generateRandPosition(position: hen1.position))
        }
        
        if abs(hen2.position.x - CGFloat(hen2Destination)) > 2{
            if hen2.position.x - CGFloat(hen2Destination) > 0{
                hen2.position.x -= CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
            else{
                hen2.position.x += CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
        }
        else{
            hen2Destination = Double(generateRandPosition(position: hen2.position))
        }
        
        if abs(hen3.position.x - CGFloat(hen3Destination)) > 2{
            if hen3.position.x - CGFloat(hen3Destination) > 0{
                hen3.position.x -= CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
            else{
                hen3.position.x += CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)
            }
        }
            
        else{
            hen3Destination = Double(generateRandPosition(position: hen3.position))
        }
        
        if abs(hen4.position.x - CGFloat(hen4Destination)) > 2{
            if hen4.position.x - CGFloat(hen4Destination) > 0{
                hen4.position.x -= CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
            else{
                hen4.position.x += CGFloat(henSpeed) * CGFloat(levelMultiplierForHenMovement)

            }
        }
        else{
            hen4Destination = Double(generateRandPosition(position: hen4.position))
        }
        
        
        
    }
    func spawnEgg(speed: double_t){
        let randomHen = Int.random(in: 1 ... 4)
        let poisonedEggChance = Float.random(in: 0 ... 1)
        let bombChance = Float.random(in: 0 ... 1)
        var isBad = 0
        if poisonedEggChance < 0.25{
            isBad = 1
        }
        if bombChance < 0.1{
            isBad = 2
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
    func dropEgg(spawnPoint: CGPoint, speed: double_t, isBad: Int){
        var eggClone = SKSpriteNode()
        
        if isBad == 1 {
            eggClone = SKSpriteNode(imageNamed: "poisonedEgg")
            eggClone.name = "badEgg"
            eggClone.size = CGSize(width: 50, height: 50)
            eggClone.physicsBody = SKPhysicsBody(rectangleOf: eggClone.size)
            eggClone.physicsBody!.categoryBitMask = BadEgg
            eggClone.physicsBody!.collisionBitMask = None
            eggClone.physicsBody!.contactTestBitMask = Player
        }
        else if isBad == 0 {
            eggClone = SKSpriteNode(imageNamed: "egg")
            eggClone.name = "goodEgg"
            eggClone.size = CGSize(width: 50, height: 50)
            eggClone.physicsBody = SKPhysicsBody(rectangleOf: eggClone.size)
            eggClone.physicsBody!.categoryBitMask = Egg
            eggClone.physicsBody!.collisionBitMask = None
            eggClone.physicsBody!.contactTestBitMask = Player

        }
        else if isBad == 2 {
            eggClone = SKSpriteNode(imageNamed: "bomb")
            eggClone.name = "bomb"
            eggClone.size = CGSize(width: 50, height: 50)
            eggClone.physicsBody = SKPhysicsBody(rectangleOf: eggClone.size)
            eggClone.physicsBody!.categoryBitMask = Bomb
            eggClone.physicsBody!.collisionBitMask = None
            eggClone.physicsBody!.contactTestBitMask = Player

        }
        
        eggClone.position = spawnPoint
        
        eggClone.physicsBody!.affectedByGravity = false
        eggClone.zPosition = 1
        
        self.addChild(eggClone)
        let moveToX = CGFloat.random(in: self.size.width * (-1) * CGFloat(levelMultiplierForEggTarget) ... self.size.width * CGFloat(levelMultiplierForEggTarget))
        let moveEgg = SKAction.moveBy(x:CGFloat(moveToX), y: self.size.height * (-1), duration: speed)
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
            
        }else if (contact.bodyA.categoryBitMask == Player && contact.bodyB.categoryBitMask == Bomb) || (contact.bodyA.categoryBitMask == Bomb && contact.bodyB.categoryBitMask == Player){
            lives -= 1
            if contact.bodyA.categoryBitMask == Bomb{
                contact.bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.categoryBitMask == Bomb{
                contact.bodyB.node?.removeFromParent()
            }
            
        }

    }
    
    func saveHighScore(){
        UserDefaults.standard.set(score, forKey: "highscore")
    }
    
    func gameOver(){
        if score > highScore{
            saveHighScore()
            highScore = score
        }
        self.isPaused = true
        
        gameOverUI()
        
        
    }
    func gameOverUI(){
        gameOverLabel = SKLabelNode()
        gameOverLabel.text = "GAME OVER!!!"
        gameOverLabel.fontSize = 50
        gameOverLabel.position = CGPoint(x: 0, y: self.size.height * 0.1)
        gameOverLabel.fontColor = .black
        gameOverLabel.zPosition = 3
        gameOverLabel.fontName = "AvenirNext-Bold"
        self.addChild(gameOverLabel)
        
        highScoreLabel = SKLabelNode()
        highScoreLabel.text = "Highscore: \(highScore)"
        highScoreLabel.fontSize = 40
        highScoreLabel.position = CGPoint(x: 0, y: 0)
        highScoreLabel.fontColor = .black
        highScoreLabel.zPosition = 3
        highScoreLabel.fontName = "AvenirNext-Bold"
        self.addChild(highScoreLabel)
        
        retryButton = UIButton()
        retryButton.frame = CGRect(x: self.size.width * 0.16, y: self.size.height * 0.30, width: 160, height: 60)
        retryButton.setTitle("Play again!", for: .normal)
        retryButton.backgroundColor = .black
        retryButton.setTitleColor(UIColor.white, for: .normal)
        retryButton.addTarget(self, action: #selector(reloadScene), for: .touchUpInside)
        self.view?.addSubview(retryButton)
        
        
        
    }
    
    @objc func reloadScene(){
        retryButton.isHidden = true
        if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    
}
