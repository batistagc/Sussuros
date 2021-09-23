import SpriteKit

class SKButtonNode: SKNode {

    var tts: String
    var action: (() -> Void)?
    
    init(tts: String) {
        self.tts = tts
        action = nil
        
        super.init()
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func announce() {
        SpeechSynthesizer.shared.speak(tts)
    }
    
    func runAction() {
        guard let action = action else { return }
        action()
    }
}
