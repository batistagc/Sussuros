import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let defaults = UserDefaults.standard
    
    // Graphics
    let analogStick = AnalogStick(stick: "stick-1", outline: "outline-1")
    let backgroundDelegacia = SKSpriteNode(imageNamed: "Delegacia")
    
    // System
    var singleTouch: UITouch?
    var gameStarted = false
    
    let delegacia = SKNode()
    let oregano = OreganoNode()
    let player = SKNode()
    
    // Speech Synthesizer
    let instructions: [String] = [
        "Encoste na tela e deslize para cima para andar pra frente.",
        "Deslize para os lados para virar para a esquerda e para a direita.",
        "Deslize para baixo para andar para trás.",
        "Toque uma vez na tela para o Orégano latir.",
        "Para pausar o jogo, toque duas vezes na tela."
    ]
    
    // Narration
    let cap1Narracao01Pimenta = SKAudioNode(fileNamed: "Cap1Narracao01Pimenta")
    let cap1Narracao02Pimenta = SKAudioNode(fileNamed: "Cap1Narracao02Pimenta")
    
    // Sounds
    let sfxCrowdTalking0 = SKAudioNode(fileNamed: "SFXCrowdTalking0")
    let sfxCrowdTalking1 = SKAudioNode(fileNamed: "SFXCrowdTalking1")
    let sfxCrowdTalking2 = SKAudioNode(fileNamed: "SFXCrowdTalking2")
    let sfxTypingKeyboard = SKAudioNode(fileNamed: "SFXTypingKeyboard")
    
    // 3D Sound Mixer
    let audioMix = AVAudioEnvironmentNode()
    let audioMixAttenuationRefDistance: Float = 50
    let audioMixAttenuationMaxDistance: Float = 300
    
//    var array: [SKAudioNode] = []
//    var nextSpeech: [String] = []
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.gravity = .zero
        
        SpeechSynthesizer.shared.synthesizer.delegate = self
        
//        array = [cap1PimentaIntrodução, cap1PimentaFinal]
//        defaults.set(1, forKey: "chapter")
//        if defaults.integer(forKey: "chapter") == 1 {
//            array[0].run(.play())
//        } else if defaults.integer(forKey: "chapter") == 2{
//            array[1].run(.play())
//        }
        
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(audioMix)
        
        player.position = CGPoint(x: 400, y: -20)
        player.zRotation = .pi
        player.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        addChild(player)
        
        cap1Narracao01Pimenta.autoplayLooped = false
        player.addChild(cap1Narracao01Pimenta)
        audioEngine.connect(cap1Narracao01Pimenta.avAudioNode!, to: audioMix, format: nil)
        cap1Narracao01Pimenta.run(.play())
        run(.wait(forDuration: 85)) { [self] in
            SpeechSynthesizer.shared.speak(instructions[0])
            
            setUpCamera()
            camera!.addChild(backgroundDelegacia)
            camera!.addChild(analogStick.createStick(named: "AnalogStick"))
            
            addPhysicsBodies()
            
            addChild(oregano)
            oregano.connectAudio(audioEngine: audioEngine, node: audioMix)
            
            sfxTypingKeyboard.position = CGPoint(x: 392, y: -261)
            addChild(sfxTypingKeyboard)
            audioEngine.connect(sfxTypingKeyboard.avAudioNode!, to: audioMix, format: nil)
            sfxTypingKeyboard.run(.play())
            
            gameStarted = true
        }
        
        // MARK: AVAudioEnvironmentNode
        audioEngine.connect(audioMix, to: mainMixer, format: nil)
        audioMix.distanceAttenuationParameters.distanceAttenuationModel = .linear
        audioMix.distanceAttenuationParameters.referenceDistance = audioMixAttenuationRefDistance
        audioMix.distanceAttenuationParameters.maximumDistance = audioMixAttenuationMaxDistance
        audioMix.outputType = .headphones
        audioMix.renderingAlgorithm = .HRTFHQ
        audioMix.sourceMode = .spatializeIfMono
        
        addPinchGestureRecognizer()
        addTapGestureRecognizer()
    }
    
    func setUpCamera() {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        guard let camera = camera else { return }
        let playerConstraint = SKConstraint.distance(SKRange(constantValue: 0), to: player)
        camera.constraints = [playerConstraint]
        camera.zPosition = .infinity
        addChild(camera)
    }
    
    // MARK: Map Physics
    func addPhysicsBodies() {
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
        
        singleTap.require(toFail: doubleTap)
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
            case .recognized:
                if sender.scale < 1.0 {
                    print("Item coletado!")
                    // TODO: Coletar item
                }
            default:
                break
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.numberOfTapsRequired {
            case 1:
                oregano.bark()
            case 2:
                if let view = self.view {
                    let newScene = MenuScene(size: view.bounds.size)
                    newScene.scaleMode = .aspectFill
                    view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
                    view.presentScene(newScene, transition: .fade(with: .clear, duration: .zero))
                }
            default:
                break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    let location = touch.location(in: camera!)
                    analogStick.updateVector(for: location)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            for touch in touches {
                if touch == singleTouch {
                    analogStick.resetStick()
                    singleTouch = nil
                }
            }
        }
    }
    
    func updatePlayer() {
        let angle = player.zRotation
        let radius: CGFloat = -analogStick.getVelocity().dy
        player.position.x += cos(angle - CGFloat.pi / 2) * radius
        player.position.y += sin(angle - CGFloat.pi / 2) * radius
        player.zRotation -= (analogStick.getVelocity().dx*analogStick.getVelocity().dx*analogStick.getVelocity().dx) / 400
    }
    
    func updateCamera() {
        camera?.zRotation = player.zRotation
    }
    
    func updateListener() {
        audioMix.listenerPosition = AVAudio3DPoint(x: Float(player.position.x), y: Float(player.position.y), z: 0)
        audioMix.listenerAngularOrientation.roll = -Float(player.zRotation) * 180 / Float.pi
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        updatePlayer()
        updateCamera()
        updateListener()
    }
}

extension GameScene: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        if nextSpeech.count > 0 {
//            SpeechSynthesizer.shared.speak(nextSpeech[0])
//            nextSpeech.remove(at: 0)
//        }
    }
}
