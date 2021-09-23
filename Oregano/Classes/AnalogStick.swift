import SpriteKit

class AnalogStick {
    
    private let stick: SKSpriteNode
    private let outline: SKSpriteNode
    private var isUsing: Bool
    private var velocityX: CGFloat
    private var velocityY: CGFloat
    private var isStatic: Bool
    private var position: CGPoint
    
    init(stick: String, outline: String, position: CGPoint = .zero) {
        self.stick = SKSpriteNode(imageNamed: stick)
        self.outline = SKSpriteNode(imageNamed: outline)
        self.outline.alpha = 0.5
        isUsing = false
        velocityX = 0
        velocityY = 0
        isStatic = position == .zero ? false : true
        self.position = position
    }
    
    func createStick(named: String) -> SKSpriteNode {
        
        stick.name = named
        stick.isHidden = !isStatic
        stick.zPosition = 1
        
        outline.name = named
        outline.isHidden = !isStatic
        outline.position = position
        outline.zPosition = 1
        outline.addChild(stick)
        
        return outline
    }
    
    public func changeState(for location: CGPoint) {
        if !isUsing {
            isUsing = true
            if !isStatic {
                outline.run(.unhide())
                stick.run(.unhide())
                outline.position = location
            }
        }
    }
    
    public func updateVector(for location: CGPoint) {
        if isUsing {
            let vector = CGVector(dx: location.x - outline.position.x, dy: location.y - outline.position.y)
            let angle = atan2(vector.dy, vector.dx)
            let outlineRadius: CGFloat = 192
            let distanceX: CGFloat = sin(angle - CGFloat.pi/2) * outlineRadius
            let distanceY: CGFloat = cos(angle - CGFloat.pi/2) * outlineRadius
            
            if abs(vector.dx) < abs(distanceX) || abs(vector.dy) < abs(distanceY) {
                stick.position.x = vector.dx
                stick.position.y = vector.dy
            } else {
                stick.position = CGPoint(x: -distanceX, y: distanceY)
            }
            
            velocityX = (stick.position.x) / 50
            velocityY = (stick.position.y) / 50
            
//            player.zRotation = angle
        }
    }
    
    public func getVelocity() -> CGVector {
        return CGVector(dx: velocityX, dy: velocityY)
    }
    
    public func getStickPosition() -> CGPoint {
        return stick.position
    }
    
    public func resetStick() {
        if isUsing {
            stick.position = .zero
            if !isStatic {
                outline.run(.hide())
                stick.run(.hide())
            }
            velocityX = 0
            velocityY = 0
            isUsing = false
        }
    }
}
