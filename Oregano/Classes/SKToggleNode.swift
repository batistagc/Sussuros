import SpriteKit

class SKToggleNode: SKButtonNode {
    
    var state: Bool
    var ttsOn: String
    var ttsOff: String
    
    init(tts: String, state: Bool = true, action: @escaping () -> Void = {}) {
        self.state = state
        ttsOn = "Desativar " + tts
        ttsOff = "Ativar " + tts
        super.init(tts: tts)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        state.toggle()
    }
    
    override func announce() {
        if state {
            tts = ttsOn
        } else {
            tts = ttsOff
        }
        super.announce()
    }
}
