//
//  SKButtonNode.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 15/09/21.
//

import SpriteKit

class SKButtonNode: SKNode {
    
    let shape: SKShapeNode
    var label: SKLabelNode
    let action: (() -> Void)
    let audio: SKAudioNode
    
    init(size: CGSize, color: UIColor, label: String, audio: String, action: @escaping () -> Void) {
        shape = SKShapeNode(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width , height: size.height), cornerRadius: 15.0)
        shape.fillColor = color
        shape.strokeColor = color
        
        self.label = SKLabelNode(attributedText: NSAttributedString(
                                    string: label,
                                    attributes: [
                                        .foregroundColor: UIColor(red: 234/255, green: 219/255, blue: 207/255, alpha: 1.0),
                                        .font: UIFont.systemFont(ofSize: 32, weight: .semibold)
                                    ]))
        self.label.verticalAlignmentMode = .center
        
        self.action = action
        
        self.audio = SKAudioNode(fileNamed: audio)
        self.audio.autoplayLooped = false
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.addChild(shape)
        self.addChild(self.label)
        self.addChild(self.audio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
