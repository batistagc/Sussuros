import SpriteKit
import AVFAudio

class SKOreganoNode: SKNode {
    
    private let barkSfx: [SKAudioNode]
    
    override init() {
        barkSfx = [
            SKAudioNode(fileNamed: "SFXBark0"),
            SKAudioNode(fileNamed: "SFXBark1"),
            SKAudioNode(fileNamed: "SFXBark2"),
            SKAudioNode(fileNamed: "SFXBark3"),
            SKAudioNode(fileNamed: "SFXBark4"),
            SKAudioNode(fileNamed: "SFXBark5"),
            SKAudioNode(fileNamed: "SFXBark6"),
            SKAudioNode(fileNamed: "SFXBark7")
        ]
        
        super.init()
        
        barkSfx.forEach {
            $0.autoplayLooped = false
            addChild($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bark() {
        guard let bark = barkSfx.randomElement() else { return }
        bark.run(.play())
    }
    
    func connectAudio(audioEngine: AVAudioEngine, node: AVAudioEnvironmentNode) {
        barkSfx.forEach {
            audioEngine.connect($0.avAudioNode!, to: node, format: nil)
        }
    }
}
