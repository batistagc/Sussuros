//
//  NewGameScene.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 16/09/21.
//

import Foundation
import SpriteKit

class NewGameScene: SKScene {
    
    var circle = SKShapeNode(circleOfRadius: 30)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .red
        
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .yellow
        circle.strokeColor = .yellow
        addChild(circle)
        
        print("x: \(circle.position.x), y: \(circle.position.y)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            circle.position.x = location.x
            circle.position.y = location.y
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
    }
    
}
