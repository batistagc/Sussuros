import SpriteKit
import AVFAudio

class ChapterOneScene: SKScene, SKPhysicsContactDelegate {
    // User Defaults
    let defaults = UserDefaults.standard
    
    // System
    var singleTouch: UITouch?
    var isCutscene = false
    var isConversation = false
    var currentAudio: SKAudioNode?
    var nextAction: (() -> Void)?
    var objectiveComplete = false
    var isWalking = false
    
    // Nodes
    let playerNode = SKPlayerNode()
    let playerReachNode = SKNode()
    let oreganoNode = SKOreganoNode()
    let isabellaNode = SKNode()
    
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
    let cap1Narracao02Pimenta: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Narracao02Pimenta.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    
    // Voice
    let cap1Fala01Maya: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Fala01Maya.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let cap1Fala02Isabella: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Fala02Isabella.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let cap1Fala03Maya: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Fala03Maya.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    let cap1Fala04Isabella: SKAudioNode = {
        let skAudioNode = SKAudioNode(fileNamed: AudioNames.cap1Fala04Isabella.rawValue)
        skAudioNode.autoplayLooped = false
        return skAudioNode
    }()
    
    // Sounds
    let sfxCrowdTalking0 = SKAudioNode(fileNamed: AudioNames.sfxCrowdTalking0.rawValue)
    let sfxCrowdTalking1 = SKAudioNode(fileNamed: AudioNames.sfxCrowdTalking1.rawValue)
    let sfxCrowdTalking2 = SKAudioNode(fileNamed: AudioNames.sfxCrowdTalking2.rawValue)
    let sfxTypingKeyboard = SKAudioNode(fileNamed: AudioNames.sfxTypingKeyboard.rawValue)
    
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
        
        // Add nodes
        addChild(playerNode)
        playerNode.addChild(cap1Narracao02Pimenta)
        playerNode.addChild(cap1Fala01Maya)
        playerNode.addChild(cap1Fala03Maya)
        addChild(oreganoNode)
        addChild(isabellaNode)
        isabellaNode.addChild(cap1Fala02Isabella)
        isabellaNode.addChild(cap1Fala04Isabella)
        addChild(sfxTypingKeyboard)
        
        // Setups
        setUp3dAudio()
        setUpPhysicsBodies()
        
        // Configure Nodes
        playerNode.name = NodeNames.player.rawValue
        playerNode.position = CGPoint(x: 400, y: -20)
        playerNode.zRotation = .pi
        playerNode.physicsBody?.categoryBitMask = Masks.player.rawValue
        playerNode.physicsBody?.collisionBitMask = Masks.walls.rawValue
        playerNode.physicsBody?.contactTestBitMask = Masks.oregano.rawValue
        
        oreganoNode.name = NodeNames.oregano.rawValue
        oreganoNode.position = CGPoint(x: 400, y: -20)
        oreganoNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        oreganoNode.physicsBody?.categoryBitMask = Masks.oregano.rawValue
        oreganoNode.physicsBody?.collisionBitMask = Masks.none.rawValue
        
        isabellaNode.position = CGPoint(x: 765, y: -240)
        
        sfxTypingKeyboard.position = CGPoint(x: 392, y: -261)
        sfxTypingKeyboard.run(.changeVolume(to: 0.5, duration: 0))
        sfxTypingKeyboard.run(.play())
        
        switch defaults.string(forKey: Defaults.lastCheckpoint.rawValue) {
            case Checkpoints.conversationWithIsabella.rawValue:
                conversationWithIsabella()
            default:
                findingIsabella00()
        }
        
        addPinchGestureRecognizer()
        addTapGestureRecognizer()
        addLongPressGestureRecognizer()
    }
    
    func findingIsabella00() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 600, y: -60), duration: 3)) { [self] in
            objectiveComplete = false
            oreganoNode.bark()
            nextAction = findingIsabella01
        }
    }
    
    func findingIsabella01() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 600, y: -246), duration: 3)) { [self] in
            objectiveComplete = false
            oreganoNode.bark()
            nextAction = findingIsabella02
        }
    }
    
    func findingIsabella02() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 690, y: -246), duration: 1)) { [self] in
            objectiveComplete = false
            oreganoNode.bark()
            nextAction = conversationWithIsabella
        }
    }
    
    func conversationWithIsabella() {
        playerNode.removeAction(forKey: "PlayerWalk")
        analogStick.resetStick()
        singleTouch = nil
        defaults.set(Checkpoints.conversationWithIsabella.rawValue, forKey: Defaults.lastCheckpoint.rawValue)
        playerNode.position = CGPoint(x: 690, y: -246)
        oreganoNode.position = playerNode.position
        objectiveComplete = false
        isConversation = true
        nextAction = carpoolWithIsabella00
        run(.sequence([
            .customAction(withDuration: 5.75, actionBlock: { [self] _, _ in
                cap1Fala01Maya.run(.changeVolume(to: 0.8, duration: 0))
                cap1Fala01Maya.run(.play())
            }),
            .customAction(withDuration: 5, actionBlock: { [self] _, _ in
                cap1Fala01Maya.run(.stop())
                cap1Fala02Isabella.run(.play())
            }),
            .customAction(withDuration: 4, actionBlock: { [self] _, _ in
                cap1Fala02Isabella.run(.stop())
                cap1Fala03Maya.run(.changeVolume(to: 0.8, duration: 0))
                cap1Fala03Maya.run(.play())
            }),
            .customAction(withDuration: 2.5, actionBlock: { [self] _, _ in
                cap1Fala03Maya.run(.stop())
                cap1Fala04Isabella.run(.play())
            }),
            .run { [self] in
                cap1Fala04Isabella.run(.stop())
                isConversation = false
                objectiveComplete = true
            }
        ]))
    }
    
    func carpoolWithIsabella00() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 600, y: -246), duration: 1)) { [self] in
            oreganoNode.bark()
            objectiveComplete = false
            nextAction = carpoolWithIsabella01
        }
    }
    
    func carpoolWithIsabella01() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 600, y: -60), duration: 3)) { [self] in
            oreganoNode.bark()
            objectiveComplete = false
            nextAction = carpoolWithIsabella02
        }
    }
    
    func carpoolWithIsabella02() {
        objectiveComplete = false
        oreganoNode.bark()
        oreganoNode.run(.move(to: CGPoint(x: 400, y: -20), duration: 3)) { [self] in
            oreganoNode.bark()
            objectiveComplete = false
            nextAction = thanksForTesting
        }
    }
    
    func thanksForTesting() {
        sfxTypingKeyboard.run(.changeVolume(to: 0, duration: 2))
        playerNode.removeAction(forKey: "PlayerWalk")
        analogStick.resetStick()
        singleTouch = nil
        oreganoNode.position = .zero
        objectiveComplete = false
        cap1Narracao02Pimenta.run(.play())
        currentAudio = cap1Narracao02Pimenta
        nextAction = { [self] in
            SpeechSynthesizer.shared.speak("Obrigado por participar do teste do audio game Sussurros!")
            run(.wait(forDuration: 6)) {
                objectiveComplete = true
                nextAction = {
                    if let view = self.view {
                        let newScene = MenuScene(size: view.bounds.size)
                        newScene.scaleMode = .aspectFill
                        view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
                        view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
                    }
                }
            }
        }
        let waitAction: SKAction = .sequence([
            .wait(forDuration: 9),
            .customAction(withDuration: 0, actionBlock: { [self] _, _ in
                guard let nextAction = nextAction else { return }
                nextAction()
            })
        ])
        run(waitAction, withKey: "WaitAction")
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
        audioEngine.connect(cap1Narracao02Pimenta.avAudioNode!, to: audioMix, format: nil)
        audioEngine.connect(cap1Fala01Maya.avAudioNode!, to: audioMix, format: nil)
        audioEngine.connect(cap1Fala02Isabella.avAudioNode!, to: audioMix, format: nil)
        audioEngine.connect(cap1Fala03Maya.avAudioNode!, to: audioMix, format: nil)
        audioEngine.connect(cap1Fala04Isabella.avAudioNode!, to: audioMix, format: nil)
        audioEngine.connect(sfxTypingKeyboard.avAudioNode!, to: audioMix, format: nil)
        
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
                        if !isConversation {
                            oreganoNode.bark()
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
                if !isConversation {
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
    }
}
