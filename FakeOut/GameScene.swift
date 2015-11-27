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
let paddleNameL = "paddleL"
let paddleNameR = "paddleR"
let blockName = "block"
let blockNodeName = "blockNode"
var isFingerOnPaddle = false
var isFingerOnPaddleR = false
var isFingerOnPaddleL = false


class GameScene: SKScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var touch = touches.first as UITouch!
        var touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == paddleName {
                print("Began touch on paddle")
                isFingerOnPaddle = true
            } else if body.node!.name == paddleNameL {
                print("Began touch on paddleL")
                isFingerOnPaddleL = true
            } else if body.node!.name == paddleNameR {
                print("Began touch on paddleR")
                isFingerOnPaddleR = true
            }
                
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1. Check whether user touched the paddle
        if isFingerOnPaddle {
            // 2. Get touch location
            var touch = touches.first as UITouch!
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            // 3. Get node for paddle
            var paddle = childNodeWithName(paddleName) as! SKSpriteNode
            
            // 4. Calculate new position along x for paddle
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // 5. Limit x so that paddle won't leave screen to left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // 6. Update paddle position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
        /*
        else if isFingerOnPaddleL {
            // 2. Get touch location
            var touch = touches.first as UITouch!
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            // 3. Get node for paddle
            var paddle = childNodeWithName(paddleNameL) as! SKSpriteNode
            
            // 4. Calculate new position along x for paddle
            var paddleY = paddle.position.y + (touchLocation.y + previousLocation.y)
            
            // 5. Limit x so that paddle won't leave screen to left or right
            paddleY = max(paddleY, paddle.size.height/2)
            paddleY = min(paddleY, size.height - paddle.size.height/2)
            
            // 6. Update paddle position
            paddle.position = CGPointMake(paddleY, paddle.position.x)
        }
*/
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
        isFingerOnPaddleL = false
        isFingerOnPaddle = false
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //you create a border around the screen, this has no volume or mass and has a friction of 0
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        print("game running")
        border.friction = 0
        self.physicsBody = border
        //Gravity is removed and a force is applied to the ball
        physicsWorld.gravity = CGVectorMake(0, 0)
        let ball = childNodeWithName(ballName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
    }
    
    
    
    
    /*
    func toucheBegan( touches: Set<UITouch>, withEvent event: UIEvent?)  {
        if let touch = touches.first {
            let touchLocation = touch.locationInNode(self)
            if let body = physicsWorld.bodyAtPoint(touchLocation) {
                if body.node!.name == paddleName {
                    print("Began touch on paddle")
                    isFingerOnPaddle = true
                }
            }
        }
    }
    
        override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 1. Check whether user touched the paddle
        if isFingerOnPaddle {
            // 2. Get touch location
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            // 3. Get node for paddle
            var paddle = childNodeWithName(paddleName) as! SKSpriteNode
            
            // 4. Calculate new position along x for paddle
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // 5. Limit x so that paddle won't leave screen to left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // 6. Update paddle position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }*/
}