//
//  SKButtonNode.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 15/09/21.
//

import Foundation
import SpriteKit



class SKButtonNode: SKNode {
    
    let shape: SKShapeNode
    var label = SKLabelNode()
    let action: (() -> Void)
    
    
    init(size: CGSize, color: UIColor, label: SKLabelNode, action: @escaping () -> Void ) {
        self.shape = SKShapeNode(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width , height: size.height), cornerRadius: 15.0)
        self.shape.fillColor = color
        self.shape.strokeColor = color
        
 
        
        self.label = label
        self.label.verticalAlignmentMode = .center
        self.label.attributedText = NSAttributedString(
            string: label.text!,
            attributes: [
                .foregroundColor: UIColor(red: 234/255, green: 219/255, blue: 207/255, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 32, weight: .semibold)
            ])
        
        self.action = action
        super.init()
        self.isUserInteractionEnabled = true
        
        self.addChild(shape)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action()
    }
    
    
    
}
