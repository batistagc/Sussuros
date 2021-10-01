import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    // UserDefaults
    let defaults = UserDefaults.standard
    
    // System
    var singleTouch: UITouch?
    var gameStarted = false
    var currentAudio: SKAudioNode?
    var nextAction: (() -> Void)?
    var isNarrating = false
    var isTutorial = false
    var isTutorialRotation = false
    var isTutorialSingleTap = false
    var objectiveComplete = false
    var currentPlayerRotation: CGFloat = 0
    var isWalking = false
    var currentPlayerPosition: CGPoint = CGPoint.zero
    
    // Actions
    var actionWalk = SKAction()
    
    // Graphics
    let analogStick = AnalogStick(stick: "stick-1", outline: "outline-1")
    let backgroundDelegacia = SKSpriteNode(imageNamed: "Delegacia")
    
    // Narration
    let cap1Narracao01Pimenta: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "Cap1Narracao01Pimenta")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let cap1Narracao02Pimenta: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "Cap1Narracao02Pimenta")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    
    // Sounds
    let sfxCrowdTalking0: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "SFXCrowdTalking0")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let sfxCrowdTalking1: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "SFXCrowdTalking1")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let sfxCrowdTalking2: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "SFXCrowdTalking2")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let sfxTypingKeyboard: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: "SFXTypingKeyboard")
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    
    // 3D Sound Mixer
    let audioMix = AVAudioEnvironmentNode()
    let audioMixAttenuationRefDistance: Float = 50
    let audioMixAttenuationMaxDistance: Float = 300
    
    // Nodes
    let playerNode = SKPlayerNode()
    let playerReachNode = SKNode()
    let oreganoNode = SKOreganoNode()
    
    override func didMove(to view: SKView) {
        UIApplication.shared.isIdleTimerDisabled = true
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        SpeechSynthesizer.shared.speak("")
        
        // Actions
        actionWalk = .repeatForever(.sequence([
            .wait(forDuration: 0.5),
            .customAction(withDuration: 0, actionBlock: { [self] _, _ in
                playerNode.walk()
            })
        ]))
        
        setUpCamera()
        camera!.addChild(backgroundDelegacia)
        camera!.addChild(analogStick.createStick(named: "AnalogStick"))
        
        // Add player node to scene
        addChild(playerNode)
        
        // Add audio nodes to scene
        addChild(oreganoNode)
        addChild(sfxTypingKeyboard)
        
        // Add narration nodes to player
        playerNode.addChild(cap1Narracao01Pimenta)
        playerNode.addChild(cap1Narracao02Pimenta)
        
        setUpPhysicsBodies()
        setUp3dAudio()
        
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
        
//        sfxTypingKeyboard.position = CGPoint(x: 392, y: -261)
//        sfxTypingKeyboard.run(.play())
        
        switch defaults.integer(forKey: "gamePart") {
            case 1:
                gamePart01()
            case 2:
                gamePart06()
            default:
                gamePart00()
        }
        
        addPinchGestureRecognizer()
        addTapGestureRecognizer()
        addLongPressGestureRecognizer()
    }
    
    func gamePart00() {
        defaults.set(0, forKey: "gamePart")
        nextAction = gamePart01
        cap1Narracao01Pimenta.run(.play())
        isNarrating = true
        currentAudio = cap1Narracao01Pimenta
        run(.wait(forDuration: 87)) { [self] in
            guard let nextAction = nextAction else { return }
            nextAction()
        }
    }
    
    func gamePart01() {
        defaults.set(1, forKey: "gamePart")
        gameStarted = true
        isNarrating = false
        isTutorial = true
        SpeechSynthesizer.shared.speak("Para andar para frente, toque na tela e arraste para cima. Você continuará andando enquanto mantiver pressionado.")
        objectiveComplete = false
        nextAction = gamePart02
    }
    
    func gamePart02() {
        playerNode.removeAction(forKey: "playerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 0
        SpeechSynthesizer.shared.speak("Deslize para os lados para virar para a esquerda e direita.")
        isTutorialRotation = true
        objectiveComplete = false
        nextAction = gamePart03
    }
    
    func gamePart03() {
        playerNode.removeAction(forKey: "playerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 0
        SpeechSynthesizer.shared.speak("Deslize para baixo para andar para trás.")
        objectiveComplete = false
        nextAction = gamePart04
    }
    
    func gamePart04() {
        playerNode.removeAction(forKey: "playerWalk")
        analogStick.resetStick()
        singleTouch = nil
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = 90*CGFloat.pi/180
        SpeechSynthesizer.shared.speak("Toque uma vez na tela para o Orégano latir.")
        isTutorialSingleTap = true
        objectiveComplete = false
        nextAction = gamePart05
    }
    
    func gamePart05() {
        run(.wait(forDuration: 1)) {
            SpeechSynthesizer.shared.speak("O latido do Orégano irá indicar para qual direção você deve seguir. Assim que você chegar lá, o Orégano irá para a próxima direção até que se chegue no objetivo final.")
        }
        isTutorial = false
        objectiveComplete = false
        nextAction = gamePart06
    }
    
    func gamePart06() {
        defaults.set(2, forKey: "gamePart")
        SpeechSynthesizer.shared.speak("Obrigado por testar o audio game Sussurros!")
        nextAction = nil
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
        audioEngine.connect(cap1Narracao01Pimenta.avAudioNode!, to: audioMix, format: nil)
        
        playerNode.connectAudio(audioEngine: audioEngine, node: audioMix)
        oreganoNode.connectAudio(audioEngine: audioEngine, node: audioMix)
        audioEngine.connect(sfxTypingKeyboard.avAudioNode!, to: audioMix, format: nil)
        
        audioEngine.connect(audioMix, to: mainMixer, format: nil)
        
        // Audio Settings
        audioMix.distanceAttenuationParameters.distanceAttenuationModel = .linear
        audioMix.distanceAttenuationParameters.referenceDistance = audioMixAttenuationRefDistance
        audioMix.distanceAttenuationParameters.maximumDistance = audioMixAttenuationMaxDistance
        audioMix.outputType = .headphones
        audioMix.renderingAlgorithm = .HRTFHQ
        audioMix.sourceMode = .spatializeIfMono
    }
    
    // MARK: Map Physics
    func setUpPhysicsBodies() {
        let delegacia = SKNode()
        delegacia.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -660, width: 900, height: 660))
        delegacia.physicsBody?.isDynamic = false
        addChild(delegacia)
        
        // MARK: Cells
        let cellsWall0 = SKNode()
        cellsWall0.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 0, y: -245, width: 230, height: 8), transform: nil))
        cellsWall0.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall0)
        let cellsWall1 = SKNode()
        cellsWall1.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 222, y: -600, width: 8, height: 355), transform: nil))
        cellsWall1.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall1)
        let cellsWall2 = SKNode()
        cellsWall2.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 0, y: -328, width: 140, height: 8), transform: nil))
        cellsWall2.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall2)
        let cellsWall3 = SKNode()
        cellsWall3.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 0, y: -411, width: 140, height: 8), transform: nil))
        cellsWall3.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall3)
        let cellsWall4 = SKNode()
        cellsWall4.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 0, y: -494, width: 140, height: 8), transform: nil))
        cellsWall4.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall4)
        let cellsWall5 = SKNode()
        cellsWall5.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 0, y: -577, width: 140, height: 8), transform: nil))
        cellsWall5.physicsBody?.isDynamic = false
        delegacia.addChild(cellsWall5)
        
        // MARK: Equipment Room
        let equipmentRoomWall0 = SKNode()
        equipmentRoomWall0.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 652, y: -221, width: 8, height: 221), transform: nil))
        equipmentRoomWall0.physicsBody?.isDynamic = false
        delegacia.addChild(equipmentRoomWall0)
        let equipmentRoomWall1 = SKNode()
        equipmentRoomWall1.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 660, y: -196, width: 90, height: 8), transform: nil))
        equipmentRoomWall1.physicsBody?.isDynamic = false
        delegacia.addChild(equipmentRoomWall1)
        let equipmentRoomWall2 = SKNode()
        equipmentRoomWall2.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 810, y: -196, width: 90, height: 8), transform: nil))
        equipmentRoomWall2.physicsBody?.isDynamic = false
        delegacia.addChild(equipmentRoomWall2)
        
        // MARK: Investigator Room
        let investigatorRoomWall0 = SKNode()
        investigatorRoomWall0.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 652, y: -660, width: 8, height: 379), transform: nil))
        investigatorRoomWall0.physicsBody?.isDynamic = false
        delegacia.addChild(investigatorRoomWall0)
        let investigatorRoomWall1 = SKNode()
        investigatorRoomWall1.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 660, y: -314, width: 90, height: 8), transform: nil))
        investigatorRoomWall1.physicsBody?.isDynamic = false
        delegacia.addChild(investigatorRoomWall1)
        let investigatorRoomWall2 = SKNode()
        investigatorRoomWall2.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 810, y: -314, width: 90, height: 8), transform: nil))
        investigatorRoomWall2.physicsBody?.isDynamic = false
        delegacia.addChild(investigatorRoomWall2)
        
        // MARK: Police Cheif Room
        let policeChiefRoomWall0 = SKNode()
        policeChiefRoomWall0.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 411, y: -660, width: 8, height: 220), transform: nil))
        policeChiefRoomWall0.physicsBody?.isDynamic = false
        delegacia.addChild(policeChiefRoomWall0)
        let policeChiefRoomWall1 = SKNode()
        policeChiefRoomWall1.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 411, y: -448, width: 181, height: 8), transform: nil))
        policeChiefRoomWall1.physicsBody?.isDynamic = false
        delegacia.addChild(policeChiefRoomWall1)
        
        // MARK: Communication Area
        let communicationAreaWall0 = SKNode()
        communicationAreaWall0.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 351, y: -204, width: 200, height: 8), transform: nil))
        communicationAreaWall0.physicsBody?.isDynamic = false
        delegacia.addChild(communicationAreaWall0)
        let communicationAreaWall1 = SKNode()
        communicationAreaWall1.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 447, y: -246, width: 8, height: 50), transform: nil))
        communicationAreaWall1.physicsBody?.isDynamic = false
        delegacia.addChild(communicationAreaWall1)
        let communicationAreaWall2 = SKNode()
        communicationAreaWall2.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 447, y: -344, width: 8, height: 50), transform: nil))
        communicationAreaWall2.physicsBody?.isDynamic = false
        delegacia.addChild(communicationAreaWall2)
        let communicationAreaWall3 = SKNode()
        communicationAreaWall3.physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: CGRect(x: 351, y: -344, width: 200, height: 8), transform: nil))
        communicationAreaWall3.physicsBody?.isDynamic = false
        delegacia.addChild(communicationAreaWall3)
    }
    
    func addPinchGestureRecognizer() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.view?.addGestureRecognizer(pinch)
    }
    
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
    
    func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1
        self.scene?.view?.addGestureRecognizer(longPress)
    }
    
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.numberOfTouchesRequired {
            case 1:
                switch sender.numberOfTapsRequired {
                    case 1:
                        print("oneSingleTap")
                        if gameStarted && !isTutorial {
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
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        print("longPress")
        if isNarrating {
            guard let currentAudio = currentAudio else { return }
            currentAudio.run(.stop())
            self.currentAudio = nil
            removeAllActions()
            guard let nextAction = nextAction else { return }
            nextAction()
        }
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if gameStarted {
            for touch in touches {
                if singleTouch == nil {
                    singleTouch = touch
                    let location = touch.location(in: camera!)
                    analogStick.changeState(for: location)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    if playerNode.action(forKey: "playerWalk") == nil {
                        playerNode.run(actionWalk, withKey: "playerWalk")
                    }
                    let location = touch.location(in: camera!)
                    analogStick.updateVector(for: location)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    isWalking = false
                    playerNode.removeAction(forKey: "playerWalk")
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    isWalking = false
                    playerNode.removeAction(forKey: "playerWalk")
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    func updatePlayer() {
        let angle = playerNode.zRotation
        let radius: CGFloat = -analogStick.getVelocity().dy
        playerNode.position.x += cos(angle - CGFloat.pi / 2) * radius
        playerNode.position.y += sin(angle - CGFloat.pi / 2) * radius
        playerNode.zRotation -= (analogStick.getVelocity().dx*analogStick.getVelocity().dx*analogStick.getVelocity().dx) / 50
    }
    
    func updateCamera() {
        camera?.zRotation = playerNode.zRotation
    }
    
    func updateListener() {
        audioMix.listenerPosition = AVAudio3DPoint(x: Float(playerNode.position.x), y: Float(playerNode.position.y), z: 0)
        audioMix.listenerAngularOrientation.roll = -Float(playerNode.zRotation) * 180 / Float.pi
    }
    
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
            if abs(playerNode.zRotation-currentPlayerRotation) > 60*CGFloat.pi/180 {
                objectiveComplete = true
                isTutorialRotation = false
            }
        }
        if currentPlayerPosition.x != playerNode.position.x || currentPlayerPosition.y != playerNode.position.y {
            isWalking = true
            currentPlayerPosition = playerNode.position
        }
    }
}
