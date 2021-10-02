import SpriteKit

class LoadingScene: SKScene {
    // User Defaults
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        SpeechSynthesizer.shared.clearNextSpeeches()
        SpeechSynthesizer.shared.speak("")
        
        if let view = self.view {
            let newScene: SKScene
            
            switch defaults.string(forKey: Defaults.lastCheckpoint.rawValue) {
                case Checkpoints.tutorial.rawValue:
                    newScene = TutorialScene(size: view.bounds.size)
                case Checkpoints.enteringPoliceStation.rawValue:
                    newScene = ChapterOneScene(size: view.bounds.size)
                case Checkpoints.conversationWithIsabella.rawValue:
                    newScene = ChapterOneScene(size: view.bounds.size)
                default:
                    newScene = TutorialScene(size: view.bounds.size)
            }
            
            newScene.scaleMode = .aspectFill
            view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
            view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
        }
    }
}
