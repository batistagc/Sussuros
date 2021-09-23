import SpriteKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "DelegaciaDelegacia")
    let analogStick = AnalogStick(stick: "", outline: "")
    let delegacia = SKNode()
    let player = SKShapeNode(circleOfRadius: 30)
    
    private let steps = SKAudioNode(fileNamed: "coin.mp3")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.gravity = .zero
        
        setUpCamera()
        
        camera!.addChild(background)
        camera!.addChild(analogStick.createStick(named: "AnalogStick"))
        addChild(player)
        addChild(delegacia)
        
        player.zPosition = 1
        player.position = .zero
        player.fillColor = .yellow
        player.lineWidth = 0
        
        delegacia.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 900, height: 660))
        delegacia.physicsBody?.isDynamic = false
        
        addPinchGestureRecognizer()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            analogStick.resetStick()
        }
        for touch in touches {
            let location = touch.location(in: camera!)
            analogStick.changeState(for: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            analogStick.resetStick()
        }
        for touch in touches {
            let location = touch.location(in: camera!)
            analogStick.updateVector(for: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        analogStick.resetStick()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        player.position.x = (player.position.x + analogStick.getVelocity().dx)
        player.position.y = (player.position.y + analogStick.getVelocity().dy)
    }
}
