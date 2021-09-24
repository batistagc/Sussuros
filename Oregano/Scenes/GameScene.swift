import SpriteKit

class GameScene: SKScene {
    
    let analogStick = AnalogStick(stick: "stick-1", outline: "outline-1")
    var singleTouch: UITouch?
    
    let backgroundDelegacia = SKSpriteNode(imageNamed: "DelegaciaDelegacia")
    let delegacia = SKNode()
    let player = SKShapeNode(rectOf: CGSize(width: 20, height: 30))
    
    private let steps = SKAudioNode(fileNamed: "footsteps.mp3")
    private let pimenta1 = SKAudioNode(fileNamed: "Pimenta 1")
    private var soundOn = SKAudioNode(fileNamed: "Pimenta 1")
    private let oregano = SKAudioNode(fileNamed: "latido")
    
    var pausegame = false
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.gravity = .zero
        
        setUpCamera()
        
        camera!.addChild(backgroundDelegacia)
        camera!.addChild(analogStick.createStick(named: "AnalogStick"))
        addChild(player)
        addChild(delegacia)
        
        // Sons
        addChild(steps)
        steps.run(.stop())
        
        pimenta1.autoplayLooped = false
        addChild(pimenta1)
        pimenta1.run(.stop())
        
        soundOn.autoplayLooped = false
        addChild(soundOn)
        soundOn.run(.play())
        
        oregano.autoplayLooped = false
        addChild(oregano)
        oregano.run(.stop())
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 30))
                
        delegacia.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -900/2, y: -660/2, width: 900, height: 660))
        delegacia.physicsBody?.isDynamic = false
        
        addPinchGestureRecognizer()
        addTapGestureRecognizer()
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
                    // TODO: Coletar item, se possível
                }
            default:
                break
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.numberOfTapsRequired {
            case 1:
                oregano.run(.play())
            
            case 2:
                pausegame = !pausegame
                if (pausegame){
                    soundOn.run(.pause())
                } else{
                    soundOn.run(.play())
                }
            default:
                break
        }
    }
    
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
                steps.run(.play())
                let location = touch.location(in: camera!)
                analogStick.updateVector(for: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        steps.run(.stop())
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
        player.position.x += radius*cos(angle - CGFloat.pi/2)
        player.position.y += radius*sin(angle - CGFloat.pi/2)
        player.zRotation -= (analogStick.getVelocity().dx*analogStick.getVelocity().dx*analogStick.getVelocity().dx) / 800
        camera?.zRotation = player.zRotation
    }
}
