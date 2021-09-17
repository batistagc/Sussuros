//
//  SKButtonNode.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 15/09/21.
//

import SpriteKit

class SKButtonNode: SKNode {

    let action: (() -> Void)
    let audio: SKAudioNode
    
    init(audio: String, action: @escaping () -> Void) {
        self.action = action
        
        self.audio = SKAudioNode(fileNamed: audio)
        self.audio.autoplayLooped = false
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.addChild(self.audio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
