//
//  GameScene.swift
//  FakeOut
//
//  Created by 20063577 on 20/11/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import SpriteKit

let ballName = "ball"
let paddleName = "paddle"
let blockName = "block"
let blockNodeName = "blockNode"
var isFingerOnPaddle = false


let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BlockCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

/*
*   @Notes - There are mulitple problems in the game which inhibit me from further improving the overall quality of the game, the ball gradulally slows down to a stop
*         after a certain amount of collions have occured making it hard to even test my win conditions, also the runtime error still persists after you click game
*         over screen. In terms of resources used Some of the basic design and game logic came from ray weinderlichs tutorial, game assets came from a tutorial youtube video referenced here https://www.youtube.com/watch?v=Cgo7LCLy0mg , and the icon came from this link http://surfingbird.ru/surf/cFIMb16b6
*/

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        var touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == paddleName {
                isFingerOnPaddle = true
            }
        }
    }

    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        if isFingerOnPaddle {
            
            let touch = touches.first as UITouch!
            let touchLocation = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            //Cretes reference to the color sprite creted on sks file
            let paddle = childNodeWithName(paddleName) as! SKSpriteNode
            
            
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            //Clamping the paddle to the screeen
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            //updates the position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //you create a border around the screen, this has no volume or mass and has a friction of 0
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        self.physicsBody = border
        //Gravity is removed and a force is applied to the ball
        physicsWorld.gravity = CGVectorMake(0, 0.0)
        //This is where I have the runtime error, still no closer to an answer.
        //Origionally I had this implemented on the sks file but was too inconsistent so hard coded instead
        let ball = childNodeWithName(ballName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(-10, -10))
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
    
        
        //Draws a boundary rectangle at the bottom used for killing the player.
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(paddleName) as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory
        
        physicsWorld.contactDelegate = self
        
        //draws the bricks using a for loop and switch statement for adding extra rows
        let numberOfRows = 2
        let numberOfBricks = 6
        let brickWidth = SKSpriteNode(imageNamed: "brick").size.width
        let padding:Float = 20
        
        let offset:Float = (Float(self.frame.size.width) - (Float(brickWidth) * Float(numberOfBricks) + padding * (Float(numberOfBricks) - 1) ) ) / 2
        
        for index in 1 ... numberOfRows{
            
            var yOffset:CGFloat{
                switch index {
                case 1:
                    return self.frame.size.height * 0.8
                case 2:
                    return self.frame.size.height * 0.6
                case 3:
                    return self.frame.size.height * 0.4
                default:
                    return 0
                }
            }
            
            
            for index in 1 ... numberOfBricks {
                let brick = SKSpriteNode(imageNamed: "brick")
                
                let calc1:Float = Float(index) - 0.5
                let calc2:Float = Float(index) - 1
                
                brick.position = CGPointMake(CGFloat(calc1 * Float(brick.frame.size.width) + calc2 * padding + offset), yOffset)
                
                brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                brick.name = blockName
                brick.physicsBody?.categoryBitMask = BlockCategory
                ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
                self.addChild(brick)
                
                
            }
        }

    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //create 2 bodies, the first body will always be the ball as it has the lowest bitmask value
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            secondBody.node!.removeFromParent()
            if isGameWon() {
                let gameOverScene = GameOverScene(size: self.frame.size, playerWon: true)
                self.view?.presentScene(gameOverScene)

            }
        }
        //This is a small bit buggy as it takes a few seconds to change the scene
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("lose")
            let gameOverScene = GameOverScene(size: self.frame.size, playerWon: false)
            self.removeAllChildren()
            self.removeAllActions()
            self.view?.presentScene(gameOverScene)
            }
        }
   
    // function to see win conditions

    func isGameWon() ->Bool {
        var numberOfBricks = 0
    
        for nodeObject in self.children {
        let node = nodeObject as SKNode
            if node.name == blockName {
                numberOfBricks += 1
            }
    }
        return numberOfBricks <= 0
}

}