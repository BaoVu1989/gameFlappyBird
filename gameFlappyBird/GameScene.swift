//
//  GameScene.swift
//  FlappyBird
//
//  Created by Bao Vu on 2/18/20.
//  Copyright © 2020 Bao Vu. All rights reserved.
//

import SpriteKit
import GameplayKit

//struct PhysicsCatagory {
//    static let Bird : UInt32 = 0x1 << 1
//    static let Ground: UInt32 = 0x1 << 2
//    static let Pipe: UInt32 = 0x1 << 3
//    static let Score: UInt32 = 0x1 << 4
//}

enum PhysicsCatagory:UInt32{
    case Bird = 1
    case Pipe = 2
    case Ground = 3
    case Score = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Ground = SKSpriteNode()
    var Bird = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score = 0
    var scoreNode = SKSpriteNode()
    let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let livesLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    var died = Bool()
    var restartBTN = SKSpriteNode()
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let Background = SKSpriteNode(imageNamed: "background")
        Background.size = self.size
        Background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        Background.zPosition = 1
        self.addChild(Background)
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.size = CGSize(width: self.frame.width, height: 200)
        Ground.position = CGPoint(x: self.frame.width / 2, y:0 )
        Ground.zPosition = 3
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground.rawValue
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Bird.rawValue
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird.rawValue
        
        Ground.physicsBody?.isDynamic = false
        Ground.physicsBody?.affectedByGravity = false
        self.addChild(Ground)
        
        Bird = SKSpriteNode(imageNamed: "flappybird")
        Bird.size = CGSize(width: 150, height: 150)
        Bird.position = CGPoint(x: self.frame.width / 2 - Bird.frame.width, y: self.frame.height / 2)
        Bird.zPosition = 2
        Bird.physicsBody = SKPhysicsBody(circleOfRadius: Bird.frame.height / 2)
        Bird.physicsBody?.isDynamic = true
        Bird.physicsBody?.affectedByGravity = false
        Bird.physicsBody?.categoryBitMask = PhysicsCatagory.Bird.rawValue
        Bird.physicsBody?.collisionBitMask =  PhysicsCatagory.Ground.rawValue | PhysicsCatagory.Pipe.rawValue
        Bird.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground.rawValue | PhysicsCatagory.Pipe.rawValue | PhysicsCatagory.Score.rawValue
        
        
        self.addChild(Bird)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontSize = 80
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.frame.width / 2 - 400, y: self.frame.height - 300 )
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 80
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.frame.width / 2 + 400, y: self.frame.height - 300)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        var body1 = SKPhysicsBody()
//        var body2 = SKPhysicsBody()
//        if contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask{
//            body1 = contact.bodyA
//            body2 = contact.bodyB
//        }else{
//            body2 = contact.bodyA
//            body1 = contact.bodyB
//        }
//        if body1.categoryBitMask == PhysicsCatagory.Bird.rawValue && body2.contactTestBitMask == PhysicsCatagory.Score.rawValue{
//            score += 1
//            print(score)
//        }
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == PhysicsCatagory.Score.rawValue && secondBody.categoryBitMask == PhysicsCatagory.Bird.rawValue || firstBody.categoryBitMask == PhysicsCatagory.Bird.rawValue && secondBody.categoryBitMask == PhysicsCatagory.Score.rawValue{
            
            firstBody.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Scores: \(score)"
        }
        if firstBody.categoryBitMask == PhysicsCatagory.Pipe.rawValue && secondBody.categoryBitMask == PhysicsCatagory.Bird.rawValue || firstBody.categoryBitMask == PhysicsCatagory.Bird.rawValue && secondBody.categoryBitMask == PhysicsCatagory.Pipe.rawValue{
            died = true
        }
    }
    
    func createBTN() {
        restartBTN = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 200, height: 100))
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
        restartBTN.zPosition = 6
        self.addChild(restartBTN)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
           gameStarted = true
            Bird.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run {

                self.createWalls()
            }

            let delay = SKAction.wait(forDuration: 3.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])

            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
    
            Bird.physicsBody?.velocity = CGVector(dx:0 ,dy:0)
            Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        }
        else{
            if died == true{
                
            }else{
                Bird.physicsBody?.velocity = CGVector(dx:0 ,dy:0)
                Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            }
            

        }
            }
    
    func createWalls() {
        wallPair = SKNode()
        scoreNode = SKSpriteNode(imageNamed: "coin")
        scoreNode.size = CGSize(width: 100, height: 100)
        scoreNode.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 )
        scoreNode.zPosition = 2
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = true
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score.rawValue
        scoreNode.physicsBody?.collisionBitMask = PhysicsCatagory.Bird.rawValue
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird.rawValue
        wallPair.addChild(scoreNode)
        
        
        let topWall = SKSpriteNode(imageNamed: "pipe")
        topWall.size = CGSize(width: 120, height: 1000)
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 700)
        topWall.zPosition = 2
        topWall.zRotation = CGFloat(M_PI)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Pipe.rawValue
        topWall.physicsBody?.collisionBitMask =  PhysicsCatagory.Bird.rawValue
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird.rawValue
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        
        let bottomWall = SKSpriteNode(imageNamed: "pipe")
        bottomWall.size = CGSize(width: 120, height: 1000)
        bottomWall.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 - 700)
        bottomWall.zPosition = 2
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCatagory.Pipe.rawValue
        bottomWall.physicsBody?.collisionBitMask = PhysicsCatagory.Bird.rawValue
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird.rawValue
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        var randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        self.addChild(wallPair)
        let delay = SKAction.wait(forDuration: 0.8)
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.005 * distance))
        let removePipes = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePipes, removePipes])
        wallPair.run(moveAndRemove)
    }
      
}
