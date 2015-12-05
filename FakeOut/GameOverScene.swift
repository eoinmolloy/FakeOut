//
//  GameOverScene.swift
//  FakeOut
//
//  Created by 20063577 on 03/12/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import SpriteKit


class GameOverScene : SKScene {
    init(size: CGSize, playerWon: Bool) {
        super.init(size: size)
    
        
        let gameOverLabel = SKLabelNode(fontNamed: "Anenir-Black")
        gameOverLabel.fontSize = 46
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        if playerWon {
            gameOverLabel.text = "You WIN!"
        }else{
            gameOverLabel.text = "Game Over"
        }
        
        self.addChild(gameOverLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let breakoutGameScene = GameScene(size: self.size)
        self.view?.presentScene(breakoutGameScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
