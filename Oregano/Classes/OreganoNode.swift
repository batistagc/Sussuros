import SpriteKit
import AVFAudio

class OreganoNode: SKNode {
    
    private let barkSounds: [SKAudioNode]
    
    override init() {
        barkSounds = [
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
        
        barkSounds.forEach {
            $0.autoplayLooped = false
            addChild($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bark() {
        guard let bark = barkSounds.randomElement() else { return }
        bark.run(.play())
    }
    
    func connectAudio(audioEngine: AVAudioEngine, node: AVAudioEnvironmentNode) {
        barkSounds.forEach {
            audioEngine.connect($0.avAudioNode!, to: node, format: nil)
        }
    }
}
