import SpriteKit

class SKToggleNode: SKButtonNode {
    
    var state: Bool
    var ttsOn: String
    var ttsOff: String
    var secondaryAction: (() -> Void)?
    
    init(tts: String, state: Bool = true) {
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
        if state {
            guard let secondaryAction = secondaryAction else { return }
            secondaryAction()
        } else {
            guard let action = action else { return }
            action()
        }
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
