import SpriteKit
import AVFAudio

class MenuScene: SKScene {
    // User Defaults
    let defaults = UserDefaults.standard
    
    // System
    var currentMenu: MenuNode<SKButtonNode>
    var cont: Int = 0
    
    // Background Images
    let lilypadFlower = SKSpriteNode(imageNamed: ImageNames.lilypadFlower.rawValue)
    let lilypadRight = SKSpriteNode(imageNamed: ImageNames.lilypad.rawValue)
    let lilypadLeft = SKSpriteNode(imageNamed: ImageNames.lilypad.rawValue)
    let lilypadSmallLeft = SKSpriteNode(imageNamed: ImageNames.lilypad.rawValue)
    let lilypadSmallBottom = SKSpriteNode(imageNamed: ImageNames.lilypad.rawValue)
    let lilypadBottom = SKSpriteNode(imageNamed: ImageNames.lilypadHalf.rawValue)
    
    // Menu Options
    let mainMenu: MenuNode<SKButtonNode>
    let continueGameOption: MenuNode<SKButtonNode>
    let newGameOption: MenuNode<SKButtonNode>
    let newGameOverwriteOption: MenuNode<SKButtonNode>
    let settingsOption: MenuNode<SKButtonNode>
//    let toggleVibrationsOption: MenuNode<SKButtonNode>
    let toggleScreenOption: MenuNode<SKButtonNode>
    let helpOption: MenuNode<SKButtonNode>
    let speakMenuControlsOption: MenuNode<SKButtonNode>
    let speakGameControlsOption: MenuNode<SKButtonNode>
   
    
    // MARK: init
    override init(size: CGSize) {
        // Set Up Options
        // Main Menu
        mainMenu = MenuNode(SKButtonNode(tts: "Menu principal."))
        mainMenu.value.name = OptionNames.mainMenu.rawValue
        // Continue Game
        continueGameOption = MenuNode(SKButtonNode(tts: "Continuar jogo."))
        continueGameOption.value.name = OptionNames.continueGame.rawValue
        // New Game
        newGameOption = MenuNode(SKButtonNode(tts: "Novo jogo."))
        newGameOption.value.name = OptionNames.newGame.rawValue
        // New Game Overwrite Warning
        newGameOverwriteOption = MenuNode(SKButtonNode(tts: "Tem certeza que quer iniciar um novo jogo? Todo o progresso do jogo anterior será perdido."))
        newGameOverwriteOption.value.name = OptionNames.newGameOverwrite.rawValue
        // Settings
        settingsOption = MenuNode(SKButtonNode(tts: "Configurações."))
        settingsOption.value.name = OptionNames.settings.rawValue
        // Toggle Vibrations
//        toggleVibrationsOption = MenuNode(SKToggleNode(tts: "Vibrações."))
        // Toggle Screen
        toggleScreenOption = MenuNode(SKToggleNode(tts: "Tela.", state: !defaults.bool(forKey: Defaults.toggleScreen.rawValue)))
        toggleScreenOption.value.name = OptionNames.toggleScreen.rawValue
        // Help
        helpOption = MenuNode(SKButtonNode(tts: "Ajuda."))
        helpOption.value.name = OptionNames.help.rawValue
        // Speak Menu Controls
        speakMenuControlsOption = MenuNode(SKButtonNode(tts: "Controles do menu."))
        speakMenuControlsOption.value.name = OptionNames.speakMenuControls.rawValue
        speakMenuControlsOption.value.action = {
            SpeechSynthesizer.shared.speak("Para selecionar uma opção, dê dois toques na tela. Para navegar entre as opções do menu, deslize para os lados. Para voltar para as opções anteriores, deslize para cima. Se quiser voltar ao menu principal a partir do jogo, dê dois toques na tela com dois dedos.")
        }
        // Speak Game Controls
        speakGameControlsOption = MenuNode(SKButtonNode(tts: "Controles do jogo."))
        speakMenuControlsOption.value.name = OptionNames.speakGameControls.rawValue
        speakGameControlsOption.value.action = {
            SpeechSynthesizer.shared.speak("Para andar para frente, encoste na tela e deslize para cima. Para virar para a esquerda e direita, deslize para os lados. Para andar para trás, deslize para baixo. Toque uma vez na tela para o Orégano latir. Para voltar ao menu principal, toque duas vezes na tela com dois dedos. Caso queira ouvir novamente os comandos, agite o celular.")
        }
        
        // Set Up Main Menu
        if defaults.string(forKey: Defaults.lastCheckpoint.rawValue) != nil {
            mainMenu.add(child: continueGameOption)
        }
        mainMenu.add(child: newGameOption)
        if defaults.string(forKey: Defaults.lastCheckpoint.rawValue) != nil {
            newGameOption.add(child: newGameOverwriteOption)
        }
        mainMenu.add(child: settingsOption)
        settingsOption.add(child: toggleScreenOption)
        mainMenu.add(child: helpOption)
        helpOption.add(child: speakMenuControlsOption)
        helpOption.add(child: speakGameControlsOption)
        
        currentMenu = mainMenu
        
        super.init(size: size)
        
        // Set Up Actions
        // Continue Game
        continueGameOption.value.action = { [self] in
            presentGame()
        }
        // New Game
        if defaults.string(forKey: Defaults.lastCheckpoint.rawValue) == nil {
            newGameOption.value.action = { [self] in
                presentGame()
            }
        }
        // New Game Overwrite Warning
        newGameOverwriteOption.value.action = { [self] in
            resetGame()
            presentGame()
        }
        // Toggle Screen
        if let screen = toggleScreenOption.value as? SKToggleNode {
            screen.action = { [self] in
                defaults.set(true, forKey: Defaults.toggleScreen.rawValue)
                let blackScreen = view?.subviews.filter { $0.tag == 1 }
                blackScreen![0].isHidden = false
            }
            screen.secondaryAction = { [self] in
                defaults.set(false, forKey: Defaults.toggleScreen.rawValue)
                let blackScreen = view?.subviews.filter { $0.tag == 1 }
                blackScreen![0].isHidden = true
            }
        }
        
        // Disable Screen Locking
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: didMove
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(red: 5/255, green: 31/255, blue: 30/255, alpha: 1.0)
        
        SpeechSynthesizer.shared.synthesizer.delegate = self
        
        // Add Background
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
        
        // Speak controls if first time opening game
        SpeechSynthesizer.shared.speak("Bem vindo ao jogo Sussurros.")
        if !defaults.bool(forKey: Defaults.IsOldUser.rawValue) {
            SpeechSynthesizer.shared.addNextSpeech("Para selecionar uma opção, dê dois toques na tela. Para ver as opções do menu, deslize para cima. Para ver as outras opções do menu, deslize para os lados. Se quiser voltar ao menu principal a partir do jogo, dê dois toques na tela com dois dedos.")
            SpeechSynthesizer.shared.addNextSpeech(currentMenu.value.tts)
            SpeechSynthesizer.shared.addNextSpeech(mainMenu.children[mainMenu.select].value.tts)
        } else {
            SpeechSynthesizer.shared.addNextSpeech(currentMenu.value.tts)
            SpeechSynthesizer.shared.addNextSpeech(mainMenu.children[mainMenu.select].value.tts)
            // Gestures Recognizers
            addSwipeGestureRecognizer()
            addTapGestureRecognizer()
        }
    }
    
    // MARK: Mod Function
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    // MARK: Present Game
    func presentGame() {
        if let view = self.view {
            let newScene = LoadingScene(size: view.bounds.size)
            newScene.scaleMode = .aspectFill
            view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
            view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
        }
    }
    
    // MARK: Reset Game
    func resetGame() {
        defaults.set(nil, forKey: Defaults.lastCheckpoint.rawValue)
    }
    
    // MARK: Swipe Gesture Recognizer
    func addSwipeGestureRecognizer() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .right, .down, .left]
        for gestureDirection in gestureDirections{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipe.direction = gestureDirection
            self.view?.addGestureRecognizer(swipe)
        }
    }
    
    // MARK: Tap Gesture Recognizer
    func addTapGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.scene?.view?.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    // MARK: Handle Swipe
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
            case .up:
                if let parent = currentMenu.parent {
                    currentMenu = parent
                    currentMenu.value.announce()
                    SpeechSynthesizer.shared.addNextSpeech(currentMenu.children[currentMenu.select].value.tts)
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
    
    // MARK: Handle Tap
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        SpeechSynthesizer.shared.clearNextSpeeches()
        switch sender.numberOfTapsRequired {
            case 1:
                currentMenu.children[currentMenu.select].value.announce()
            case 2:
                if currentMenu.children[currentMenu.select].children.count > 0 {
                    if currentMenu.children[currentMenu.select].value.name == OptionNames.newGame.rawValue {
                        SpeechSynthesizer.shared.speak("")
                    } else {
                        currentMenu.children[currentMenu.select].value.announce()
                    }
                    currentMenu = currentMenu.children[currentMenu.select]
                    currentMenu.select = 0
                    SpeechSynthesizer.shared.addNextSpeech(currentMenu.children[currentMenu.select].value.tts)
                } else if let toggle = currentMenu.children[currentMenu.select].value as? SKToggleNode {
                    toggle.toggle()
                    currentMenu.children[currentMenu.select].value.announce()
                } else {
                    let action = currentMenu.children[currentMenu.select].value
                    action.runAction()
                }
            default:
                break
        }
    }
}

// MARK: AVSpeechSynthesizerDelegate
extension MenuScene: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        SpeechSynthesizer.shared.speakNextSpeech()
        
        if (!defaults.bool(forKey: Defaults.IsOldUser.rawValue) && cont == 2){
            defaults.set(true, forKey: Defaults.IsOldUser.rawValue)
            addTapGestureRecognizer()
            addSwipeGestureRecognizer()
        }
        cont += 1
    }
}
