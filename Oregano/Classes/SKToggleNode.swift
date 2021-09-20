import SpriteKit

class SKToggleNode: SKButtonNode {
    var activated: Bool
    
    override init(tts: String, action: @escaping () -> Void = {}) {
        activated = false
        super.init(tts: tts, action: action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        activated.toggle()
    }
    
    override func announce() {
        if activated {
            tts = "Desativar " + tts
        } else {
            tts = "Ativar " + tts
        }
        self.announce()
    }
}
