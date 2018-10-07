//
//  GameScene.swift
//  MyGame
//
//  Created by Duy Pham on 7/23/18.
//  Copyright © 2018 Duy Pham. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene ,SKPhysicsContactDelegate, Alerts {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var touch:Bool = false
    private var touLeft:Bool = false
    private var hei:CGFloat = 0
    private var limitHei:CGFloat = 20
    private var blockHei:CGFloat = 0
    private let rate:CGFloat = 0.2
    private var queue = Queue()
    private var point:CGFloat = 0
    private var time:Int32 = 0
    private var show:Bool = false
//    private var lLine:Array<CGPoint> = []
//    private var left:SKShapeNode?
    
    private var dur:Int = 0
    private let BOTTOM_HEIGHT:CGFloat = -640
    private var fra:Bool = false
    
    private var lastUpdateTime : TimeInterval = 0
    private var rocket : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    private var cam: SKCameraNode?
    let highestScoreKey = "highestScore"
    private var highestScore:Int = 0
    
    public var viewController: UIViewController!
    
//    @IBAction func someButtonPressed(sender: UIButton) {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let popupVC = storyboard.instantiateViewControllerWithIdentifier("hello") as! popupViewController
//        popupVC.modalPresentationStyle = .Popover
//        popupVC.preferredContentSize = CGSizeMake(300, 300)
//        let pVC = popupVC.popoverPresentationController
//        pVC?.permittedArrowDirections = .Any
//        pVC?.delegate = self
//        pVC?.sourceView = sender
//        pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
//        popupVC.modalPresentationStyle = .OverCurrentContext
//        popupVC.modalTransitionStyle = .CrossDissolve
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init() {
        super.init()
        setup()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }
    
    func setup()
    {
        self.physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx:0, dy: -0.4)
        view?.preferredFramesPerSecond = 100
        
        // INITIALIZE CAMERA
        self.camera = self.childNode(withName: "//cam") as? SKCameraNode
        
        // INITIALIZE PLAYER NODE  ---
        setUpRocket()
        
        // INITIALIZE GROUND & LEFT
        setUpGround()
        setUpLeftWall()
        highestScore = readHighestScore()
    }
    
    
    override func sceneDidLoad() {
//        customView.isHidden = true
        if let label = self.rocket {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            print("Show")
        }
  
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
//        hei = self.frame.minY
//        while hei < self.frame.maxY {
//            let a = SKSpriteNode(color: .cyan, size: CGRect(x: 50, y: 100, width: 150, height: rate).size)
//            a.anchorPoint = CGPoint( x: 0, y: rate)
//            a.position = CGPoint( x: self.frame.minX, y: hei)
//            a.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: rate))
//            a.physicsBody?.isDynamic = false
//            a.physicsBody?.restitution = 1
//            self.addChild(a)
//            queue.enqueue(element: a)
//            hei += rate
//        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let label = self.rocket {
            label.color = .green
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.rocket {
//            label.physicsBody?.applyImpulse(CGVector(dx: 8000, dy: 90000.0))
            label.physicsBody?.applyImpulse(CGVector(dx: 8000, dy: 9000.0))
        }
        
        
//        for t in touches {
//            let location = t.location(in: self)
//            if(location.x < -110){
//                touch = true
//                touLeft = true
//                if let label = self.label {
//                    label.physicsBody?.applyImpulse(CGVector(dx: -8000, dy: 90000.0))
//                }
//            }
//            else if (location.x > 110){
//                touch = true
//                touLeft = false
//                if let label = self.label {
//                    label.physicsBody?.applyImpulse(CGVector(dx: 8000, dy: 90000.0))
//                }
//            } else {
//                if let label = self.label {
//                    let temp = (label.physicsBody?.velocity.dx)! * (-100)
//                    label.physicsBody?.applyImpulse(CGVector(dx: temp, dy: 90000.0))
//                }
//            }
//        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            touch = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
//        self.camera?.position.x = (self.label?.position.x)!
//        updateLeft()
        
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
//        updateGroundMovement()
    }
    
    override func didFinishUpdate() {
        self.camera?.position = (self.rocket?.position)!
        if(show == false) {
            if (ceil(Double((self.rocket?.physicsBody?.velocity.dy)!)) == 0 || ceil(Double((self.rocket?.physicsBody?.velocity.dy)!)) == 1.0) {
                time += 1
                if (time == 10) {
                    point += ((rocket?.frame.origin.y)! + 2*self.frame.maxY)
                    print(point)
                    show = true
                    if (Int(point) > highestScore) {
                        showActionSheet(title: point.description, message: "New Highest Score")
                        writeHighestScore(score: Int(point))
                    } else {
                        showActionSheet(title: point.description, message: "Your Highest Score is \(highestScore)")
                    }
                }
            } else {
                time = 0
            }
        }
    }
    
    func setUpRocket() {
//        self.rocket = self.childNode(withName: "//node") as? SKSpriteNode
        let birdTexture = SKTexture(imageNamed: "stork")
        let texturedBird = SKSpriteNode(texture: birdTexture)
        self.rocket = texturedBird
        self.rocket?.physicsBody = SKPhysicsBody(texture: birdTexture, size: CGSize(width: texturedBird.size.width,
                                                height: texturedBird.size.height))
//        self.rocket = SKSpriteNode(imageNamed: "stork")
        self.rocket?.position = CGPoint(x: 100, y: 100)
        rocket?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (rocket?.size.width)!, height: (rocket?.size.height)!))
        rocket?.physicsBody?.usesPreciseCollisionDetection = true
        rocket?.physicsBody?.mass = 100
        rocket?.physicsBody?.affectedByGravity = true
        rocket?.physicsBody?.allowsRotation = false
        rocket?.physicsBody!.contactTestBitMask = rocket!.physicsBody!.collisionBitMask
        rocket?.physicsBody?.angularDamping = 0.05
        self.addChild(self.rocket!)
    }
    
    func setUpGround() {
        var x:CGFloat = self.frame.minX
        var oldHei = BOTTOM_HEIGHT
        queue.enqueue(element: CGPoint(x: self.frame.minX, y: BOTTOM_HEIGHT))
        var ran:UInt32 = 0
        while x < 10000 {
            ran = arc4random_uniform(4)
            if( ran == 1 ) {
                x += (CGFloat(arc4random_uniform(15)) + 5)
                oldHei += (CGFloat(arc4random_uniform(100)) - 50)
                queue.enqueue(element: CGPoint(x: x, y: oldHei))
            } else {
                x += 3
                queue.enqueue(element: CGPoint(x: x, y: oldHei))
            }
        }
        var gLine = queue.array()
        let ground = SKShapeNode(points: &gLine, count: gLine.count)
        ground.lineWidth = 1
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.6
        ground.physicsBody?.isDynamic = false
        ground.name = "ground"
        ground.isAntialiased = false
        ground.physicsBody?.friction = 1
        self.addChild(ground)
        
//        setUpBackgrounds()
    }
    
    func setUpLeftWall() {
        var lLine = [CGPoint(x: self.frame.minX, y: BOTTOM_HEIGHT),
                     CGPoint(x: self.frame.minX, y: self.frame.maxY)]
        var left = SKShapeNode()
        left = SKShapeNode(splinePoints: &lLine, count: lLine.count)
        left.physicsBody = SKPhysicsBody(edgeChainFrom: (left.path!))
        left.physicsBody?.restitution = 1
        left.physicsBody?.isDynamic = false
        left.strokeColor = .white
        left.lineWidth = 2
        left.name = "left"
        self.addChild(left)
    }
    
    func updateLeft() {
        queue.dequeue()
//        let random:CGFloat = CGFloat(arc4random_uniform(100) + 1);
//        queue.update()
//        queue.enqueue(element: CGPoint(x: self.frame.minX + random, y: self.frame.maxY - rate))
//        left?.removeFromParent()
//        enumerateChildNodes(withName: "left", using: { (le,stop) in
//            let a = le as! SKShapeNode
//            let lLine = CGMutablePath()
//            lLine.addLines(between: (self.queue.array())!)
//            a.path = lLine
//            a.physicsBody = SKPhysicsBody(edgeChainFrom: (a.path!))
//        })
//        let lLine = CGMutablePath()
//        lLine.addLines(between: (queue.array())!)
    }
    
    var backgroundSpeed: CGFloat = 80.0
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    func setUpBackgrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(color: UIColor.white, size: CGSize(width: 1, height: 2))
            ground.anchorPoint = CGPoint(x: 0, y: 0)
            ground.size = CGSize(width: self.size.width, height: ground.size.height)
            ground.position = CGPoint(x: CGFloat(i) * size.width, y: 0)
            ground.zPosition = 1
            ground.name = "ground"
            self.addChild(ground)
        }
    }

    func updateGroundMovement() {
        self.enumerateChildNodes(withName: "ground") { (node, stop) in
            
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -back.size.width {
                    back.position += CGPoint(x: 0, y: 100)
                }
            }
        }
    }
    
    func readHighestScore() -> Int {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: highestScoreKey) == nil {
            return 0
        } else {
            let score = preferences.integer(forKey: highestScoreKey)
            return score
        }
    }
    
    func writeHighestScore(score: Int) {
        let preferences = UserDefaults.standard
        _ = preferences.set(score, forKey: highestScoreKey)
        let saving = preferences.synchronize()
        if !saving {
            print("Can't save highest score")
        }
    }
}



public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

