//
//  HeadScene.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 17/09/21.
//

import Foundation
import SpriteKit

class HeadScene: SKScene {
    

    let headImageView = SKSpriteNode(texture: SKTexture(imageNamed: "􀑈"))
    let warningLabel = SKLabelNode()

    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 34/255, green: 32/255, blue: 53/255, alpha: 1)
        
        
        addChild(headImageView)
        addChild(warningLabel)
        
        
        
        headImageView.position = CGPoint(x: 0, y: 70)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        warningLabel.attributedText = NSAttributedString(
                                    string: "Snaps é um audiogame.\nUtilize fones para que tenha uma melhor experiência.",
                                    attributes: [
                                        .foregroundColor: UIColor.white,
                                        .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                                        .paragraphStyle: paragraphStyle
                                    ])
        warningLabel.numberOfLines = 0
        warningLabel.preferredMaxLayoutWidth = 300
        warningLabel.position = CGPoint(x: 0, y: -70)
        

        
        
        addTapGestureRecognizer()
        
    }
    
    func addTapGestureRecognizer() {
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        self.scene?.view?.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(doubleTap)
        
//        singleTap.require(toFail: doubleTap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        switch sender.numberOfTapsRequired {
            case 2:
                if let newView = self.view {
                    let scene = MenuScene(size: (self.view?.bounds.size)!)
                    scene.scaleMode = .resizeFill
                    newView.presentScene(scene, transition: .fade(with: .clear, duration: .zero))
                }
            default:
                break
        }
    }
    
}
