import UIKit
import SpriteKit
import AVFAudio

class ViewController: UIViewController {
    
    let blackView = SKView(frame: UIScreen.main.bounds)
    
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let blackScene = SKScene(size: blackView.frame.size)
        blackScene.backgroundColor = .black
        blackView.presentScene(blackScene)
        
        blackView.isHidden = true
        blackView.tag = 1
        blackView.backgroundColor = .black
        view.addSubview(blackView)
        
        view.isAccessibilityElement = true
        view.accessibilityTraits = .allowsDirectInteraction
        
        if let view = self.view as! SKView? {
            var scene: SKScene
            if isHeadsetPluggedIn() {
                scene = MenuScene(size: view.bounds.size)
            } else {
                scene = HeadphonesScene(size: view.bounds.size)
            }
//            scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
//            view.showsPhysics = true
            view.isMultipleTouchEnabled = true
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
