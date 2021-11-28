import SpriteKit
import AVFAudio

class SKPlayerNode: SKNode {
    
    private let stepSfx: [SKAudioNode]
    
    override init() {
        stepSfx = [
            SKAudioNode(fileNamed: "SFXStep0"),
            SKAudioNode(fileNamed: "SFXStep1"),
            SKAudioNode(fileNamed: "SFXStep2"),
            SKAudioNode(fileNamed: "SFXStep3"),
            SKAudioNode(fileNamed: "SFXStep4"),
            SKAudioNode(fileNamed: "SFXStep5"),
            SKAudioNode(fileNamed: "SFXStep6"),
            SKAudioNode(fileNamed: "SFXStep7")
        ]
        
        super.init()
        
        stepSfx.forEach {
            $0.autoplayLooped = false
            addChild($0)
        }
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
        guard let step = stepSfx.randomElement() else { return }
        step.run(.play())
    }
    
    func connectAudio(audioEngine: AVAudioEngine, node: AVAudioEnvironmentNode) {
        stepSfx.forEach {
            audioEngine.connect($0.avAudioNode!, to: node, format: nil)
        }
    }
}
