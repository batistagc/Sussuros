
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
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 5/255, green: 31/255, blue: 30/255, alpha: 1.0)
        
        let continueGameButton = SKButtonNode(size: CGSize(width: 260.0, height: 70.0), color: buttonColor,  label: .init(text: "Continuar"), action: {print("Clicou!")})
        let newGameButton = SKButtonNode(size: CGSize(width: 260.0, height: 70.0), color: buttonColor,  label: .init(text: "Novo jogo"), action: {print("Clicou!")})
        let configGameButton = SKButtonNode(size: CGSize(width: 260.0, height: 70.0), color: buttonColor,  label: .init(text: "Configurações"), action: {print("Clicou!")})
        let helpGameButton = SKButtonNode(size: CGSize(width: 260.0, height: 70.0), color: buttonColor,  label: .init(text: "Ajuda"), action: {print("Clicou!")})
        
        addChild(vitRegiaFlor)
        vitRegiaFlor.position = CGPoint(x: 0.5, y: 300.0)
        
        addChild(vitRegiaMedRight)
        vitRegiaMedRight.position = CGPoint(x: 200.0, y: 150.0)
        
        addChild(vitRegiaMedLeft)
        vitRegiaMedLeft.position = CGPoint(x: -205.0, y: 20.0)
        
        addChild(vitRegiaPeqLeft)
        vitRegiaPeqLeft.size = CGSize(width: (vitRegiaPeqLeft.size.width/2), height: (vitRegiaPeqLeft.size.height/2))
        vitRegiaPeqLeft.position = CGPoint(x: -230.0, y: -70.0)
        
        addChild(vitRegiaPeqBottom)
        vitRegiaPeqBottom.size = CGSize(width: (vitRegiaPeqBottom.size.width/2), height: (vitRegiaPeqBottom.size.height/2))
        vitRegiaPeqBottom.position = CGPoint(x: 60.0, y: -260.0)
        
        addChild(vitRegiaBottom)
        vitRegiaBottom.position = CGPoint(x: 70.0, y: -340.0)
        
        
        addChild(continueGameButton)
        continueGameButton.position = CGPoint(x: 0, y: 100.0)
        
        addChild(newGameButton)
        newGameButton.position = CGPoint(x: 0, y: 10.0)
        
        addChild(configGameButton)
        configGameButton.position = CGPoint(x: 0, y: -80.0)
        
        addChild(helpGameButton)
        helpGameButton.position = CGPoint(x: 0, y: -170.0)
        
    }
    
    
}
