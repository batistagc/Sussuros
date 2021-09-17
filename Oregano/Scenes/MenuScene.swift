import SpriteKit

class MenuScene: SKScene {
    
    let lilypadFlower = SKSpriteNode(imageNamed: "vitoriaRegiaFlor")
    let lilypadRight = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadSmallLeft = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadSmallBottom = SKSpriteNode(imageNamed: "vitoriaRegiaInteira")
    let lilypadBottom = SKSpriteNode(imageNamed: "halfVitoriaRegia")
    
    let continueGameButton: SKButtonNode
    let newGameButton: SKButtonNode
    let settingsButton: SKButtonNode
    let helpButton: SKButtonNode
    
    let vibrationsButton: SKButtonNode
    let screenButton: SKButtonNode
    
    let controlsMenu: SKButtonNode
    let controlsGame: SKButtonNode
    
    let audioMenu: [SKButtonNode]
    var selectedButton: Int
    
    override init(size: CGSize) {        
        continueGameButton = SKButtonNode(audio: "ContinueGame.mp3",
                                          action: { })
        newGameButton = SKButtonNode(audio: "NewGame.mp3",
                                     action: { })
        settingsButton = SKButtonNode(audio: "Settings.mp3",
                                      action: { })
        helpButton = SKButtonNode(audio: "Help.mp3",
                                  action: { })
        
        vibrationsButton = SKButtonNode(audio: "DeactivateVibrations.mp3",
                                        action: { })
        screenButton = SKButtonNode(audio: "DeactivateScreen.mp3",
                                    action: { })
        
        controlsMenu = SKButtonNode(audio: "ControlsMenu.mp3",
                                    action: { })
        controlsGame = SKButtonNode(audio: "ControlsGame.mp3",
                                    action: { })
        
        audioMenu = [
            continueGameButton,
            newGameButton,
            settingsButton,
                vibrationsButton,
                screenButton,
            helpButton,
                controlsMenu,
                controlsGame
        ]
        
        vibrationsButton.isHidden = true
        screenButton.isHidden = true
        
        controlsMenu.isHidden = true
        controlsGame.isHidden = true
                
        selectedButton = 0
        
        let menu = SKAudioNode(fileNamed: "Menu.mp3")
        menu.run(.play())
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 5/255, green: 31/255, blue: 30/255, alpha: 1.0)
        
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
        
        // Menu Buttons
        
        addChild(continueGameButton)
        addChild(newGameButton)
        addChild(settingsButton)
        settingsButton.addChild(vibrationsButton)
        settingsButton.addChild(screenButton)
        addChild(helpButton)
        helpButton.addChild(controlsMenu)
        helpButton.addChild(controlsGame)
        
        continueGameButton.position = CGPoint(x: 0, y: 100.0)
        newGameButton.position = CGPoint(x: 0, y: 10.0)
        settingsButton.position = CGPoint(x: 0, y: -80.0)
        helpButton.position = CGPoint(x: 0, y: -170.0)
        
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
                print("Para cima")
            case .left:
                let menuItems = audioMenu.filter { $0.isHidden == false }
                selectedButton = mod(selectedButton + 1, menuItems.count)
                menuItems[selectedButton].audio.run(.play())
                print(selectedButton)
            case .down:
                print("Baixo")
            case .right:
                let menuItems = audioMenu.filter { $0.isHidden == false }
                selectedButton = mod(selectedButton - 1, menuItems.count)
                menuItems[selectedButton].audio.run(.play())
                print(selectedButton)
            default:
                print("Sem swipe")
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        switch sender.numberOfTapsRequired {
            case 1:
                print("FOI 1")
            case 2:
                print("FOI 2")
            default:
                print("Sem toque")
        }
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
}
