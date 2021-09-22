import UIKit
import SpriteKit
import AVFAudio

class MenuViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isAccessibilityElement = true
        view.accessibilityTraits = .allowsDirectInteraction
        
        if let view = view as! SKView? {
            var scene: SKScene
            if isHeadsetPluggedIn() {
                scene = MenuScene(size: view.bounds.size)
            } else {
                scene = HeadphonesScene(size: view.bounds.size)
            }
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
    }
    
    func isHeadsetPluggedIn() -> Bool {
        let route: AVAudioSessionRouteDescription = AVAudioSession.sharedInstance().currentRoute
        for desc in route.outputs {
            if desc.portType == AVAudioSession.Port.headphones {
                return true
            }
        }
        return false
    }
}
