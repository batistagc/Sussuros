
import SpriteKit

class MenuScene: SKScene {
    
    let vitRegiaFlor = SKSpriteNode(imageNamed: "vitoriaRegiaFlor")
    let vitRegiaMedRight = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaMedLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaPeqLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaPeqBottom = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let vitRegiaBottom = SKSpriteNode(imageNamed: "halfVitoriaRegia")
    
    let buttonColor: UIColor = UIColor(red: 95/255, green: 143/255, blue: 153/255, alpha: 1.0)
 
    
    
    
    override func didMove(to view: SKView) {
        
        view.backgroundColor = .red
        
        let newGameButton = SKButtonNode(image: .init(color: buttonColor, size: CGSize(width: 260.0, height: 70.0)), label: .init(text: "Novo jogo"), action: {print("Clicou!")})
        let continueGameButton = SKButtonNode(image: .init(color: buttonColor, size: CGSize(width: 260.0, height: 70.0)), label: .init(text: "Continuar"), action: {print("Clicou!")})
        let configGameButton = SKButtonNode(image: .init(color: buttonColor, size: CGSize(width: 260.0, height: 70.0)), label: .init(text: "Configurações"), action: {print("Clicou!")})
        let helpGameButton = SKButtonNode(image: .init(color: buttonColor, size: CGSize(width: 260.0, height: 70.0)), label: .init(text: "Ajuda"), action: {print("Clicou!")})
        
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
        
        
        addChild(continueGameButton)
        continueGameButton.position = CGPoint(x: frame.midX, y: 500.0)
        
        addChild(newGameButton)
        newGameButton.position = CGPoint(x: frame.midX, y: 410.0)
        
        addChild(configGameButton)
        configGameButton.position = CGPoint(x: frame.midX, y: 320.0)
        
        addChild(helpGameButton)
        helpGameButton.position = CGPoint(x: frame.midX, y: 230.0)
        
    }
    
    
}
