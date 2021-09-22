import SpriteKit
import UIKit
import AVFAudio

class MenuScene: SKScene {
    
    let lilypadFlower = SKSpriteNode(imageNamed: "vitoriaRegiaFlor")
    let lilypadRight = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadSmallLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadSmallBottom = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadBottom = SKSpriteNode(imageNamed: "halfVitoriaRegia")
    
    let continueGameButton: MenuNode<SKButtonNode>
    let newGameButton: MenuNode<SKButtonNode>
    let settingsButton: MenuNode<SKButtonNode>
    let helpButton: MenuNode<SKButtonNode>
    
    let vibrationsButton: MenuNode<SKButtonNode>
    let screenButton: MenuNode<SKButtonNode>
    
    let controlsMenu: MenuNode<SKButtonNode>
    let controlsGame: MenuNode<SKButtonNode>
    
    let mainMenu: MenuNode<SKButtonNode>
    var currentMenu: MenuNode<SKButtonNode>
    
    var nextSpeech: (() -> Void)?
    
    override init(size: CGSize) {
        mainMenu = MenuNode(SKButtonNode(tts: "Menu principal."))
        
        continueGameButton = MenuNode(SKButtonNode(tts: "Continuar jogo."))
        
        newGameButton = MenuNode(SKButtonNode(tts: "Novo jogo."))
        
        settingsButton = MenuNode(SKButtonNode(tts: "Configurações."))
        vibrationsButton = MenuNode(SKToggleNode(tts: "Vibrações."))
        screenButton = MenuNode(SKToggleNode(tts: "Tela."))
        
        helpButton = MenuNode(SKButtonNode(tts: "Ajuda."))
        controlsMenu = MenuNode(SKButtonNode(tts: "Controles do menu."))
        controlsGame = MenuNode(SKButtonNode(tts: "Controles do jogo."))
        
        mainMenu.add(child: continueGameButton)
        mainMenu.add(child: newGameButton)
        mainMenu.add(child: settingsButton)
        settingsButton.add(child: vibrationsButton)
        settingsButton.add(child: screenButton)
        mainMenu.add(child: helpButton)
        helpButton.add(child: controlsMenu)
        helpButton.add(child: controlsGame)
        
        currentMenu = mainMenu
        
        super.init(size: size)
        
        if let screen = screenButton.value as? SKToggleNode {
            screen.action = { [self] in
                let blackScreen = view?.subviews.filter { $0.tag == 1 }
                blackScreen![0].isHidden = false
            }
            screen.secondaryAction = { [self] in
                let blackScreen = view?.subviews.filter { $0.tag == 1 }
                blackScreen![0].isHidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 5/255, green: 31/255, blue: 30/255, alpha: 1.0)
        
        SpeechSynthesizer.shared.synthesizer.delegate = self
        
        // Background
        
        addChild(lilypadFlower)
        addChild(lilypadRight)
        addChild(lilypadLeft)
        addChild(lilypadSmallLeft)
        addChild(lilypadSmallBottom)
        addChild(lilypadBottom)
        
        lilypadFlower.position = CGPoint(x: 0.5, y: 300.0)
        lilypadRight.position = CGPoint(x: 200.0, y: 150.0)
        lilypadLeft.position = CGPoint(x: -205.0, y: 20.0)
        lilypadSmallLeft.size = CGSize(width: (lilypadSmallLeft.size.width/2), height: (lilypadSmallLeft.size.height/2))
        lilypadSmallLeft.position = CGPoint(x: -230.0, y: -70.0)
        lilypadSmallBottom.size = CGSize(width: (lilypadSmallBottom.size.width/2), height: (lilypadSmallBottom.size.height/2))
        lilypadSmallBottom.position = CGPoint(x: 60.0, y: -260.0)
        lilypadBottom.position = CGPoint(x: 70.0, y: -340.0)
        
        currentMenu.value.announce()
        nextSpeech = { [self] in
            mainMenu.children[mainMenu.select].value.announce()
        }
        
        // Gestures Recognizers
        
        addSwipeGestureRecognizer()
        addTapGestureRecognizer()
    }
    
    func addSwipeGestureRecognizer() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .right, .down, .left]
        for gestureDirection in gestureDirections{
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureRecognizer.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func addTapGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.scene?.view?.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
            case .up:
                if let parent = currentMenu.parent {
                    currentMenu = parent
                    currentMenu.value.announce()
                    nextSpeech = { [self] in
                        currentMenu.children[currentMenu.select].value.announce()
                    }
                }
            case .left:
                currentMenu.select = mod(currentMenu.select - 1, currentMenu.children.count)
                currentMenu.children[currentMenu.select].value.announce()
            case .right:
                currentMenu.select = mod(currentMenu.select + 1, currentMenu.children.count)
                currentMenu.children[currentMenu.select].value.announce()
            default:
                break
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        switch sender.numberOfTapsRequired {
            case 1:
                currentMenu.children[currentMenu.select].value.announce()
            case 2:
                if currentMenu.children[currentMenu.select].children.count > 0 {
                    currentMenu.children[currentMenu.select].value.announce()
                    currentMenu = currentMenu.children[currentMenu.select]
                    currentMenu.select = 0
                    nextSpeech = { [self] in
                        currentMenu.children[currentMenu.select].value.announce()
                    }
                } else if let toggle = currentMenu.children[currentMenu.select].value as? SKToggleNode {
                    toggle.toggle()
                    currentMenu.children[currentMenu.select].value.announce()
                } else {
                    if let newView = self.view {
                        let scene = NewGameScene(size: (self.view?.bounds.size)!)
                        scene.scaleMode = .resizeFill
                        newView.presentScene(scene, transition: .fade(with: .clear, duration: .zero))
                    }
                }
            default:
                break
        }
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
}

extension MenuScene: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let nextSpeech = nextSpeech {
            nextSpeech()
            self.nextSpeech = nil
        }
    }
}
