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

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //you create a border around the screen, this has no volume or mass and has a friction of 0
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        self.physicsBody = border
        //Gravity is removed and a force is applied to the ball
        physicsWorld.gravity = CGVectorMake(0, 0)
        let ball = childNodeWithName(ballName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
    }
}
