//
//  SKButtonNode.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 15/09/21.
//

import Foundation
import SpriteKit

class SKButtonNode: SKNode {
    
    var image: SKSpriteNode?
    var label: SKLabelNode?
    var action: (() -> Void)?
    
    init(image: SKSpriteNode, label: SKLabelNode, action: @escaping () -> Void ) {
        self.image = image
        self.label = label
        self.action = action
        super.init()
        self.isUserInteractionEnabled = true
        
        self.addChild(image)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action?()
    }
    
    
    
}
