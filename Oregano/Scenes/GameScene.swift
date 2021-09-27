import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let analogStick = AnalogStick(stick: "stick-1", outline: "outline-1")
    var singleTouch: UITouch?
    
    let backgroundDelegacia = SKSpriteNode(imageNamed: "Delegacia")
    let delegacia = SKNode()
    let player = SKNode()
    
    let soundNode = SKShapeNode(circleOfRadius: 30)
    let sound = SKAudioNode(fileNamed: "Pimenta1")
    var soundMix: AVAudioEnvironmentNode!
    
    var soundMixAttenuationRefDistance: Float = 50
    var soundMixAttenuationMaxDistance: Float = 300
    
//    var pausegame = false
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.gravity = .zero
        
        setUpCamera()
        camera!.addChild(backgroundDelegacia)
        camera!.addChild(analogStick.createStick(named: "AnalogStick"))
        
        addChild(delegacia)
        delegacia.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -900/2, y: -660/2, width: 900, height: 660))
        delegacia.physicsBody?.isDynamic = false
        
        addChild(soundNode)
        soundNode.position = CGPoint(x: 200, y: 200)
        soundNode.zPosition = .infinity
        
        sound.isPositional = true
//        sound.autoplayLooped = false
        soundNode.addChild(sound)
        sound.run(.play())
        
        addChild(player)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 20))
        
        soundMix = AVAudioEnvironmentNode()
        audioEngine.attach(soundMix)
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(sound.avAudioNode!, to: soundMix, format: nil)
        audioEngine.connect(soundMix, to: mainMixer, format: nil)
        
        soundMix.distanceAttenuationParameters.distanceAttenuationModel = .linear
        soundMix.distanceAttenuationParameters.referenceDistance = soundMixAttenuationRefDistance
        soundMix.distanceAttenuationParameters.maximumDistance = soundMixAttenuationMaxDistance
        soundMix.outputType = .headphones
        soundMix.renderingAlgorithm = .auto
        
        addPinchGestureRecognizer()
//        addTapGestureRecognizer()
    }
    
    func setUpCamera() {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        guard let camera = camera else { return }
        camera.zPosition = .infinity
        let playerConstraint = SKConstraint.distance(SKRange(constantValue: 0), to: player)
        camera.constraints = [playerConstraint]
        addChild(camera)
    }
    
    func addPinchGestureRecognizer() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.view?.addGestureRecognizer(pinch)
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
    
//    func addTapGestureRecognizer() {
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        self.scene?.view?.addGestureRecognizer(singleTap)
//
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        doubleTap.numberOfTapsRequired = 2
//        self.scene?.view?.addGestureRecognizer(doubleTap)
//
//        singleTap.require(toFail: doubleTap)
//    }
//
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        switch sender.numberOfTapsRequired {
//            case 1:
//                oregano.run(.play())
//            case 2:
//                pausegame = !pausegame
//                if (pausegame){
//                    soundOn.run(.pause())
//                } else{
//                    soundOn.run(.play())
//                }
//            default:
//                break
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if singleTouch == nil {
                singleTouch = touch
                let location = touch.location(in: camera!)
                analogStick.changeState(for: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == singleTouch {
                let location = touch.location(in: camera!)
                analogStick.updateVector(for: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == singleTouch {
                analogStick.resetStick()
                singleTouch = nil
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == singleTouch {
                analogStick.resetStick()
                singleTouch = nil
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let angle = player.zRotation
        let radius: CGFloat = -analogStick.getVelocity().dy
        player.position.x += cos(angle - CGFloat.pi / 2) * radius
        player.position.y += sin(angle - CGFloat.pi / 2) * radius
        player.zRotation -= (analogStick.getVelocity().dx*analogStick.getVelocity().dx*analogStick.getVelocity().dx) / 400
        camera?.zRotation = player.zRotation
        soundMix.listenerPosition = AVAudio3DPoint(x: Float(player.position.x), y: Float(player.position.y), z: 0)
        soundMix.listenerAngularOrientation.roll = -Float(player.zRotation) * 180 / Float.pi
        print(player.zRotation)
    }
}
