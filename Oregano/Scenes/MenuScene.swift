
import SpriteKit

class MenuScene: SKScene {
    
    let vitRegiaFlor = SKSpriteNode(imageNamed: "vitoriaRegiaFlor")
    let vitRegiaMedRight = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaMedLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaPeqLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaPeqBottom = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaBottom = SKSpriteNode(imageNamed: "halfVitoriaRegia")
    
    let newGameButton = SKButtonNode(image: .init(color: .blue, size: CGSize(width: 260.0, height: 70.0)), label: .init(text: "Novo jogo"), action: {print("Clicou!")})
    
    override func didMove(to view: SKView) {
        
        view.backgroundColor = .red
        
        addChild(vitRegiaFlor)
        vitRegiaFlor.position = CGPoint(x: frame.midX, y: 700.0)
        
        addChild(vitRegiaMedRight)
        vitRegiaMedRight.position = CGPoint(x: 440.0, y: 570.0)
        
        addChild(vitRegiaMedLeft)
        vitRegiaMedLeft.position = CGPoint(x: -20.0, y: 400.0)
        
        addChild(vitRegiaPeqLeft)
        vitRegiaPeqLeft.size = CGSize(width: (vitRegiaPeqLeft.size.width/2), height: (vitRegiaPeqLeft.size.height/2))
        vitRegiaPeqLeft.position = CGPoint(x: 0.0, y: 310.0)
        
        addChild(vitRegiaPeqBottom)
        vitRegiaPeqBottom.size = CGSize(width: (vitRegiaPeqBottom.size.width/2), height: (vitRegiaPeqBottom.size.height/2))
        vitRegiaPeqBottom.position = CGPoint(x: 250.0, y: 170.0)
        
        addChild(vitRegiaBottom)
        vitRegiaBottom.position = CGPoint(x: 270.0, y: 70.0)
        
        addChild(newGameButton)
        newGameButton.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    
}
