//
//  NewGameScene.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 16/09/21.
//

import Foundation
import SpriteKit
import AVFoundation

class NewGameScene: SKScene, AVAudioPlayerDelegate {
    
    var circle = SKShapeNode(circleOfRadius: 30)
    private var backgroundSound: AVAudioPlayer?
    private let steps = SKAudioNode(fileNamed: "coin.mp3")
    
    
    var background = SKSpriteNode(imageNamed: "DelegaciaDelegacia")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        self.backgroundColor = UIImage(named: "DelegaciaDelegacia")!
        
        addChild(background)
        
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .yellow
        circle.strokeColor = .yellow
        addChild(circle)
        addChild(steps)
        steps.run(.stop())
        
        print("x: \(circle.position.x), y: \(circle.position.y)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        steps.run(.play())

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            circle.position.x = location.x
            circle.position.y = location.y
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        steps.run(.stop())
    }
    

    
}
