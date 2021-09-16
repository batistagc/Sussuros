import UIKit
import SpriteKit
import AVFoundation

class MenuViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            if isHeadsetPluggedIn() {
                let scene = MenuScene(size: view.bounds.size)
                scene.scaleMode = .resizeFill
                
                view.presentScene(scene)
            }
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
