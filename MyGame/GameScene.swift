//
//  GameScene.swift
//  MyGame
//
//  Created by Duy Pham on 7/23/18.
//  Copyright © 2018 Duy Pham. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Queue{
    
    var items:[CGPoint] = []
    
    mutating func enqueue(element: CGPoint)
    {
        items.append(element)
    }
    
    mutating func dequeue()
    {
        if !items.isEmpty {
            items.remove(at: 0)
        } else {
            print("Error info: Removing empty queue")
        }
    }
    
    mutating func peek() -> CGPoint? {
        if !items.isEmpty {
            return items.first
        }
        else{
            return nil
        }
    }
    
    mutating func isEmpty() -> Bool? {
        return items.isEmpty
    }
    
    mutating func array() -> [CGPoint]? {
        return items
    }
    
    mutating func update() {
        for var i in items {
            i.y -= 0.2
        }
    }
}

class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var touch:Bool = false
    private var touLeft:Bool = false
    private var hei:CGFloat = 0
    private var limitHei:CGFloat = 20
    private var blockHei:CGFloat = 0
    private let rate:CGFloat = 0.2
    private var queue = Queue()
    private var lLine:Array<CGPoint> = []
    private var left:SKShapeNode?
    private var dur:Int = 0
    private let BOTTOM_HEIGHT:CGFloat = -640
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        self.physicsWorld.contactDelegate = self
        view?.preferredFramesPerSecond = 100
        
        // Physical Node
        self.label = self.childNode(withName: "//node") as? SKSpriteNode
        label?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (label?.size.width)!,
                                                               height: (label?.size.height)!))
        label?.physicsBody?.usesPreciseCollisionDetection = true
        label?.physicsBody?.mass = 100
        label?.physicsBody?.affectedByGravity = true
        label?.physicsBody?.allowsRotation = false
        label?.physicsBody!.contactTestBitMask = label!.physicsBody!.collisionBitMask
        
        // The Ground
        var gLine = [CGPoint(x: self.frame.minX, y: BOTTOM_HEIGHT),
                            CGPoint(x: self.frame.maxX, y: BOTTOM_HEIGHT)]
        let ground = SKShapeNode(splinePoints: &gLine,
                                 count: gLine.count)
        ground.lineWidth = 6
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.7
        ground.physicsBody?.isDynamic = false
        self.addChild(ground)
        
        // Left, Right & Top Edge detecting contact
        let lLine = CGMutablePath()
        var ngang:CGFloat = self.frame.minX
        hei = BOTTOM_HEIGHT
        while hei < self.frame.maxY {
            hei += rate
            if blockHei < limitHei {
                blockHei += rate
                queue.enqueue(element: CGPoint(x: ngang, y: hei))
            } else {
                ngang += 20
                blockHei = 0
            }
        }
        lLine.addLines(between: (queue.array())!)
        left = SKShapeNode()
        left?.path = lLine
        left?.physicsBody = SKPhysicsBody(edgeChainFrom: (left?.path!)!)
        left?.physicsBody?.restitution = 1
        left?.physicsBody?.isDynamic = false
        left?.strokeColor = .white
        left?.lineWidth = 2
        self.addChild(left!)
        
        var rLine = [CGPoint(x: self.frame.maxX, y: BOTTOM_HEIGHT),
                     CGPoint(x: self.frame.maxX, y: self.frame.maxY)]
        let right = SKShapeNode(splinePoints: &rLine,
                               count: rLine.count)
        right.physicsBody = SKPhysicsBody(edgeChainFrom: right.path!)
        right.physicsBody?.restitution = 1
        right.physicsBody?.isDynamic = false
        self.addChild(right)
        
        var tLine = [CGPoint(x: self.frame.minX, y: self.frame.maxY),
                     CGPoint(x: self.frame.maxX, y: self.frame.maxY)]
        let top = SKShapeNode(splinePoints: &tLine,
                                count: tLine.count)
        top.physicsBody = SKPhysicsBody(edgeChainFrom: top.path!)
        top.physicsBody?.restitution = 1
        top.physicsBody?.isDynamic = false
        self.addChild(top)
        
        
        if let label = self.label {
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
        
        
        hei = self.frame.minY
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
        if let label = self.label {
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
        for t in touches {
            let location = t.location(in: self)
            if(location.x < -110){
                touch = true
                touLeft = true
                if let label = self.label {
                    label.physicsBody?.applyImpulse(CGVector(dx: -8000, dy: 90000.0))
                }
            }
            else if (location.x > 110){
                touch = true
                touLeft = false
                if let label = self.label {
                    label.physicsBody?.applyImpulse(CGVector(dx: 8000, dy: 90000.0))
                }
            } else {
                if let label = self.label {
                    let temp = (label.physicsBody?.velocity.dx)! * (-100)
                    label.physicsBody?.applyImpulse(CGVector(dx: temp, dy: 90000.0))
                }
            }
        }
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
        // Called before each frame is rendered
        
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
        
        queue.dequeue()
//        let random:CGFloat = CGFloat(arc4random_uniform(100) + 1);
//        queue.update()
//        queue.enqueue(element: CGPoint(x: self.frame.minX + random, y: self.frame.maxY - rate))
        left?.removeFromParent()
        let lLine = CGMutablePath()
        lLine.addLines(between: (queue.array())!)
        left = SKShapeNode()
        left?.path = lLine
        left?.physicsBody = SKPhysicsBody(edgeChainFrom: (left?.path!)!)
//        if dur == 300 {
//            left?.removeFromParent()
//            let lLine = CGMutablePath()
//            queue.dequeue()
//            queue.enqueue(element: CGPoint(x: self.frame.minX + 300, y: 0))
//
//            lLine.addLines(between: (queue.array())!)
//            left = SKShapeNode()
//            left?.path = lLine
//            left?.physicsBody = SKPhysicsBody(edgeChainFrom: (left?.path!)!)
//            left?.physicsBody?.restitution = 1
//            left?.physicsBody?.isDynamic = false
//            left?.strokeColor = .white
//            left?.lineWidth = 2
//            self.addChild(left!)
//        }
//        dur += 1
        
        
        
//        if(limitHei < 100) {
//            hei += rate
//            limitHei += rate
//            let a = SKSpriteNode(color: .cyan, size: CGRect(x: 50, y: 100, width: 150, height: rate).size)
//            a.anchorPoint = CGPoint( x: 0, y: rate)
//            a.position = CGPoint( x: self.frame.minX, y: hei)
//            self.addChild(a)
//            queue.enqueue(element: a)
//        } else {
//            if(!queue.isEmpty()!) {
//                queue.dequeue()?.removeFromParent()
//            }
//        }
        
        
//        if(touch) {
//            if(touLeft) {
//                if let label = self.label {
//                    label.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5000.0))
//                    label.physicsBody?.applyForce(CGVector(dx: -10000, dy: 0))
//                }
//            } else {
//                if let label = self.label {
//                    label.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5000.0))
//                    label.physicsBody?.applyForce(CGVector(dx: 10000, dy: 0))
//                }
//            }
//        }
    }
}
