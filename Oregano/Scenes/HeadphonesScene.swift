import SpriteKit
import AVFAudio

class HeadphonesScene: SKScene {
    
    let headphonesImage = SKSpriteNode(texture: SKTexture(imageNamed: "􀑈"))
    let warningLabel = SKLabelNode()
    
    let loopSpeech: String = "Sussurros é um audio game. Utilize fones de ouvido para que tenha uma melhor experiência."

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 34/255, green: 32/255, blue: 53/255, alpha: 1)
        
        SpeechSynthesizer.shared.synthesizer.delegate = self
        
        addChild(headphonesImage)
        addChild(warningLabel)
        
        headphonesImage.position = CGPoint(x: 0, y: 70)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        warningLabel.attributedText = NSAttributedString(
                                    string: "Sussurros é um audiogame.\nUtilize fones de ouvido para que tenha uma melhor experiência.",
                                    attributes: [
                                        .foregroundColor: UIColor.white,
                                        .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                                        .paragraphStyle: paragraphStyle
                                    ])
        warningLabel.numberOfLines = 0
        warningLabel.preferredMaxLayoutWidth = 300
        warningLabel.position = CGPoint(x: 0, y: -70)
        
        SpeechSynthesizer.shared.speak(loopSpeech)
        
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        switch sender.numberOfTapsRequired {
            case 2:
                if let newView = self.view {
                    let scene = MenuScene(size: (self.view?.bounds.size)!)
                    scene.scaleMode = .resizeFill
                    newView.presentScene(scene, transition: .fade(with: .clear, duration: .zero))
                }
            default:
                break
        }
    }
    
}

extension HeadphonesScene: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        run(.wait(forDuration: 4)) { [self] in
            SpeechSynthesizer.shared.speak(loopSpeech)
        }
    }
}