import UIKit
import SpriteKit
import AVFoundation

class MenuViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isHeadsetPluggedIn(){
            
            if let view = self.view as! SKView? {
                
                let scene = HeadScene(size: view.bounds.size)
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
                
            }
        }
        else {
            if let view = self.view as! SKView? {
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
