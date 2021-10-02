import SpriteKit
import AVFAudio

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    // User Defaults
    let defaults = UserDefaults.standard
    
    // System
    var singleTouch: UITouch?
    var isCutscene = false
    var currentAudio: SKAudioNode?
    var nextAction: (() -> Void)?
    var objectiveComplete = false
    var isWalking = false
    var isTutorial = false
    var isTutorialRotation = false
    var isTutorialSingleTap = false
    var currentPlayerRotation: CGFloat = 0
    
    // Nodes
    let playerNode = SKPlayerNode()
    let playerReachNode = SKNode()
    let oreganoNode = SKOreganoNode()
    let audioPlayer = SKNode()
    
    // Graphics
    let analogStick = AnalogStick(stick: "stick-1", outline: "outline-1")
    let backgroundDelegacia = SKSpriteNode(imageNamed: ImageNames.backgroundDelegacia.rawValue)
    
    // Actions
    var playerWalkAction: SKAction!
    
    // 3D Sound Mixer
    let audioMix = AVAudioEnvironmentNode()
    let audioMixAttenuationRefDistance: Float = 50
    let audioMixAttenuationMaxDistance: Float = 300
    
    // Narration
    let cap1Narracao01Pimenta: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Narracao01Pimenta.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    
    // MARK: init
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        // Actions
        playerWalkAction = .repeatForever(.sequence([
            .wait(forDuration: 0.5),
            .customAction(withDuration: 0, actionBlock: { [self] _, _ in
                playerNode.walk()
            })
        ]))
        
        // Disable Screen Locking
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: didMove
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setUpCamera()
        camera!.addChild(backgroundDelegacia)
        camera!.addChild(analogStick.createStick(named: "AnalogStick"))
        
        addChild(playerNode)
        playerNode.addChild(cap1Narracao01Pimenta)
        addChild(oreganoNode)
        
        // Setups
        setUp3dAudio()
        
        // Configure Nodes
        playerNode.name = NodeNames.player.rawValue
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = .pi
        playerNode.physicsBody?.categoryBitMask = Masks.player.rawValue
        playerNode.physicsBody?.collisionBitMask = Masks.walls.rawValue
        playerNode.physicsBody?.contactTestBitMask = Masks.oregano.rawValue
        
        oreganoNode.name = NodeNames.oregano.rawValue
        oreganoNode.position = CGPoint(x: 400, y: -120)
        oreganoNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        oreganoNode.physicsBody?.categoryBitMask = Masks.oregano.rawValue
        oreganoNode.physicsBody?.collisionBitMask = Masks.none.rawValue
        
        switch defaults.string(forKey: Defaults.lastCheckpoint.rawValue) {
            case Checkpoints.tutorial.rawValue:
                gameTutorial00()
            default:
                gameIntroduction()
        }
        
        addPinchGestureRecognizer()
        addTapGestureRecognizer()
        addLongPressGestureRecognizer()
    }
    
    func gameIntroduction() {
        defaults.set(nil, forKey: Defaults.lastCheckpoint.rawValue)
        cap1Narracao01Pimenta.run(.play())
        isCutscene = true
        currentAudio = cap1Narracao01Pimenta
        nextAction = gameTutorial00
        let waitAction: SKAction = .sequence([
            .wait(forDuration: 87),
            .customAction(withDuration: 0, actionBlock: { [self] _, _ in
                guard let nextAction = nextAction else { return }
                nextAction()
            })
        ])
        run(waitAction, withKey: "WaitAction")
    }
    
    func gameTutorial00() {
        defaults.set(Checkpoints.tutorial.rawValue, forKey: Defaults.lastCheckpoint.rawValue)
        isCutscene = false
        isTutorial = true
        SpeechSynthesizer.shared.speak("Para andar para frente, toque na tela e deslize para cima. Você continuará andando enquanto mantiver pressionado.")
        objectiveComplete = false
        nextAction = gameTutorial01
    }
    
    func gameTutorial01() {
        playerNode.removeAction(forKey: "PlayerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 0
        SpeechSynthesizer.shared.speak("Deslize para os lados para virar para a esquerda e para a direita. Você continuará virando enquanto mantiver pressionado.")
        isTutorialRotation = true
        objectiveComplete = false
        nextAction = gameTutorial02
    }
    
    func gameTutorial02() {
        playerNode.removeAction(forKey: "PlayerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 0
        SpeechSynthesizer.shared.speak("Para andar para trás, toque na tela e deslize para baixo. Você continuará andando enquanto mantiver pressionado.")
        objectiveComplete = false
        nextAction = gameTutorial03
    }
    
    func gameTutorial03() {
        playerNode.removeAction(forKey: "PlayerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 90*CGFloat.pi/180
        SpeechSynthesizer.shared.speak("Toque uma vez na tela para seu cão-guia chamado Orégano latir.")
        isTutorialSingleTap = true
        objectiveComplete = false
        nextAction = gameTutorialEnd
    }
    
    func gameTutorialEnd() {
        run(.wait(forDuration: 1)) {
            SpeechSynthesizer.shared.speak("O latido do Orégano irá indicar para qual direção você deve seguir. Assim que você chegar lá, o Orégano irá para a próxima direção até que se chegue no objetivo final.")
        }
        SpeechSynthesizer.shared.addNextSpeech("Vá até o Orégano para entrar na delegacia.")
        isTutorial = false
        objectiveComplete = false
        nextAction = enteringPoliceStation
    }
    
    func enteringPoliceStation() {
        defaults.set(Checkpoints.enteringPoliceStation.rawValue, forKey: Defaults.lastCheckpoint.rawValue)
        nextAction = {
            if let view = self.view {
                let newScene = LoadingScene(size: view.bounds.size)
                newScene.scaleMode = .aspectFill
                view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
                view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
            }
        }
    }
    
    // MARK: Camera Setup
    func setUpCamera() {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        guard let camera = camera else { return }
        let playerConstraint = SKConstraint.distance(SKRange(constantValue: 0), to: playerNode)
        camera.constraints = [playerConstraint]
        camera.zPosition = .infinity
        addChild(camera)
    }
    
    // MARK: AVAudioEnvironmentNode
    func setUp3dAudio() {
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(audioMix)
        
        // Connect Nodes
        playerNode.connectAudio(audioEngine: audioEngine, node: audioMix)
        oreganoNode.connectAudio(audioEngine: audioEngine, node: audioMix)
        audioEngine.connect(cap1Narracao01Pimenta.avAudioNode!, to: audioMix, format: nil)
        
        // Connect Audio Mix to Main Mixer
        audioEngine.connect(audioMix, to: mainMixer, format: nil)
        
        // Audio Settings
        audioMix.distanceAttenuationParameters.distanceAttenuationModel = .linear
        audioMix.distanceAttenuationParameters.referenceDistance = audioMixAttenuationRefDistance
        audioMix.distanceAttenuationParameters.maximumDistance = audioMixAttenuationMaxDistance
        audioMix.outputType = .headphones
        audioMix.renderingAlgorithm = .HRTFHQ
        audioMix.sourceMode = .spatializeIfMono
    }
    
    // MARK: Pinch Gesture Recognizer
    func addPinchGestureRecognizer() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.view?.addGestureRecognizer(pinch)
    }
    
    // MARK: Tap Gesture Recognizer
    func addTapGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.scene?.view?.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(doubleTap)
        
        let twoSingleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        twoSingleTap.numberOfTouchesRequired = 2
        self.scene?.view?.addGestureRecognizer(twoSingleTap)
        
        let twoDoubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        twoDoubleTap.numberOfTouchesRequired = 2
        twoDoubleTap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(twoDoubleTap)
        
        singleTap.require(toFail: doubleTap)
        twoSingleTap.require(toFail: twoDoubleTap)
    }
    
    // MARK: Long Press Gesture Recognizer
    func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1
        self.scene?.view?.addGestureRecognizer(longPress)
    }
    
    // MARK: Handle Pinch
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
            case .recognized:
                if sender.scale < 1.0 {
                    print("downscalingPinch")
                    // TODO: Coletar item
                }
            default:
                break
        }
    }
    
    // MARK: Handle Tap
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.numberOfTouchesRequired {
            case 1:
                switch sender.numberOfTapsRequired {
                    case 1:
                        print("oneSingleTap")
                        if !isCutscene && !isTutorial {
                            oreganoNode.bark()
                        }
                        if isTutorialSingleTap {
                            oreganoNode.bark()
                            objectiveComplete = true
                            isTutorialSingleTap = false
                        }
                    case 2:
                        print("oneDoubleTap")
                    default:
                        break
                }
            case 2:
                switch sender.numberOfTapsRequired {
                    case 1:
                        print("twoSingleTap")
                    case 2:
                        print("twoDoubleTap")
                        if let view = self.view {
                            let newScene = MenuScene(size: view.bounds.size)
                            newScene.scaleMode = .aspectFill
                            view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
                            view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
                        }
                    default:
                        break
                }
            default:
                break
        }
    }
    
    // MARK: Handle Long Press
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        print("longPress")
        if isCutscene {
            guard let currentAudio = currentAudio else { return }
            currentAudio.run(.stop())
            self.currentAudio = nil
            removeAction(forKey: "WaitAction")
            guard let nextAction = nextAction else { return }
            nextAction()
        }
    }
    
    // MARK: Physics Bodies Contact
    func contactBetween(_ player: SKNode, _ node: SKNode) {
        switch node.name {
            case NodeNames.oregano.rawValue:
                if !isTutorialRotation && !isTutorialSingleTap {
                    objectiveComplete = true
                }
            default:
                break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == NodeNames.player.rawValue {
            contactBetween(nodeA, nodeB)
        } else if nodeB.name == NodeNames.player.rawValue {
            contactBetween(nodeB, nodeA)
        }
    }
    
    // MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isCutscene {
            for touch in touches {
                if singleTouch == nil {
                    singleTouch = touch
                    let location = touch.location(in: camera!)
                    analogStick.changeState(for: location)
                }
            }
        }
    }
    
    // MARK: touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if !isCutscene {
            for touch in touches {
                if touch == singleTouch {
                    if playerNode.action(forKey: "PlayerWalk") == nil {
                        playerNode.run(playerWalkAction, withKey: "PlayerWalk")
                    }
                    let location = touch.location(in: camera!)
                    analogStick.updateVector(for: location)
                }
            }
        }
    }
    
    // MARK: touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isCutscene {
            for touch in touches {
                if touch == singleTouch {
                    playerNode.removeAction(forKey: "PlayerWalk")
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    // MARK: touchesCancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if !isCutscene {
            for touch in touches {
                if touch == singleTouch {
                    playerNode.removeAction(forKey: "PlayerWalk")
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    // MARK: updatePlayer
    func updatePlayer() {
        let angle = playerNode.zRotation
        let radius: CGFloat = -analogStick.getVelocity().dy
        playerNode.position.x += cos(angle - CGFloat.pi / 2) * radius
        playerNode.position.y += sin(angle - CGFloat.pi / 2) * radius
        playerNode.zRotation -= (analogStick.getVelocity().dx*analogStick.getVelocity().dx*analogStick.getVelocity().dx) / 100
    }
    
    // MARK: updateCamera
    func updateCamera() {
        camera?.zRotation = playerNode.zRotation
    }
    
    // MARK: updateListener
    func updateListener() {
        audioMix.listenerPosition = AVAudio3DPoint(x: Float(playerNode.position.x), y: Float(playerNode.position.y), z: 0)
        audioMix.listenerAngularOrientation.roll = -Float(playerNode.zRotation) * 180 / Float.pi
    }
    
    // MARK: update
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        updatePlayer()
        updateCamera()
        updateListener()
        if objectiveComplete {
            guard let nextAction = nextAction else { return }
            nextAction()
        }
        if isTutorialRotation {
            if abs(playerNode.zRotation-currentPlayerRotation) > 90*CGFloat.pi/180 {
                objectiveComplete = true
                isTutorialRotation = false
            }
        }
    }
}
