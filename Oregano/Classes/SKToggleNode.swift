import SpriteKit

class SKToggleNode: SKButtonNode {
    
    var activated: Bool
    var ttsOn: String
    var ttsOff: String
    
    override init(tts: String, state: Bool = true, action: @escaping () -> Void = {}) {
        activated = state
        ttsOn = "Desativar " + tts
        ttsOff = "Ativar " + tts
        super.init(tts: tts)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        activated.toggle()
    }
    
    override func announce() {
        if activated {
            tts = ttsOn
        } else {
            tts = ttsOff
        }
        super.announce()
    }
}
