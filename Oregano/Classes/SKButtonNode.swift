import SpriteKit

class SKButtonNode: SKNode {

    var tts: String
    let action: (() -> Void)
    
    init(tts: String, action: @escaping () -> Void = {}) {
        self.tts = tts
        self.action = action
        
        super.init()
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func announce() {
        SpeechSynthesizer.shared.speak(tts)
    }
}
