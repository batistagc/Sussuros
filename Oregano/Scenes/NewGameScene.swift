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
    let joystick = AnalogStick(stick: "", outline: "")
    
    
    var background = SKSpriteNode(imageNamed: "DelegaciaDelegacia")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(background)
        
//        circle.position = CGPoint(x: frame.midX, y: frame.midY)
//        circle.fillColor = .yellow
//        circle.strokeColor = .yellow
//        addChild(circle)
     //   addChild(steps)
      //  steps.run(.stop())
        addChild(joystick.createStick(named: ""))
        
        print("x: \(circle.position.x), y: \(circle.position.y)")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view)
            joystick.changeState(for: location)
           // steps.run(.play())
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            joystick.updateVector(for: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            joystick.resetStick()
          //  steps.run(.stop())
        }
    }
    


}
