//
//  LoaderScene.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/8/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import SpriteKit

class LoaderScene: SKScene, SKPhysicsContactDelegate {
    var REPEAT_ACTION = "repeatAction"
    var radial : SKFieldNode!
    var ballCategory:UInt32 = 0x1 << 0;
    
    func getAddSliceAction() -> SKAction {
        let x = size.width/2
        let y = size.height-1
        
        let action = SKAction.runBlock { () -> Void in
            self.addSlice(atLocation: CGPointMake(x, y))
        }
        
        return action
    }
    
    func addSlice(atLocation loc:CGPoint? = nil, isProgressFeedback:Bool=false){
        let slice = SKSpriteNode(imageNamed: "slice")
        slice.alpha = 1
        
        if let location = loc {
            slice.position = location
        } else {
            slice.position = CGPointMake(size.width/2, size.height-1)
        }
        
        
        let random = (arc4random()+10) % 30;
        let randomScale:CGFloat = CGFloat(random)/100;
        
        slice.physicsBody = SKPhysicsBody(circleOfRadius: slice.size.height-20)
        addChild(slice)
        
        let scaleAction = SKAction.scaleBy(randomScale, duration: 0)
        slice.physicsBody?.affectedByGravity = true
        slice.runAction(scaleAction)
        slice.physicsBody?.dynamic = true
        slice.physicsBody?.density = 0.01
        slice.physicsBody?.restitution = 0.3
        slice.physicsBody?.charge = 0.02
        slice.physicsBody?.collisionBitMask = ballCategory;
        slice.physicsBody?.contactTestBitMask = ballCategory;
        slice.physicsBody?.categoryBitMask = ballCategory;
        
        let randomHue = CGFloat(Int.random(263...354))/360
        

        
        if isProgressFeedback {
            slice.color = SKColor(hue: randomHue, saturation: 50/100, brightness: 100/100, alpha: 1.0)
        } else {
            slice.color = SKColor(hue: randomHue, saturation: 50/100, brightness: 60/100, alpha: 1.0)
            }

        slice.colorBlendFactor = 1

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
    //    var secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
        //    secondBody = contact.bodyB
            
            let firstNode = firstBody.node! as! SKSpriteNode
     //       let secondNode = secondBody.node! as! SKSpriteNode

            let newColor = NSColor(hue: firstNode.color.hueComponent,
                saturation: firstNode.color.saturationComponent,
                brightness: firstNode.color.brightnessComponent,
                alpha: firstNode.color.alphaComponent)
            
            let colorAction = SKAction.colorizeWithColor(newColor, colorBlendFactor: 1.0, duration: 1)
            
            let scaleTo = CGFloat( Int.random(5...30) )/100 // scale between 5 and 30%
            
            let scaleAction = SKAction.scaleTo(scaleTo, duration: 0.5)
            
//            let squishIn = SKAction.scaleXTo(0.9, duration: 0.2)
//            let squishOut = SKAction.scaleXTo(1, duration: 0.2)
//            let squish = SKAction.group([squishIn, squishOut])
            
            let actions = SKAction.group([scaleAction, colorAction])
            
            firstNode.runAction(actions)

        }
        else // collission with scene
        {
            firstBody = contact.bodyB
         //   secondBody = contact.bodyA
//            print("contact B to A")

        }
        
        
    }
    
    
    func startLoading(){
        let waitAction = SKAction.waitForDuration(0.4);
            let addAndWait = SKAction.sequence([getAddSliceAction(), waitAction])
                let repeatAction = SKAction.repeatAction(addAndWait, count: 200)

        runAction(repeatAction, withKey: REPEAT_ACTION)
    }
    
    func showDragInvite(fileSize:UInt64){ // shown onMoiseOver
        print("showDragInvite")
        removeAllChildren()
        useCircleBody()
        let balls = Int(fileSize/100000)
        
        // add a bunch of balls at random locations
        setInviteGravity()
        
        // then a force that will follow the mouse
        radial = SKFieldNode.radialGravityField()
        radial.strength = 3.5
        radial.falloff = 0.01
        radial.animationSpeed = 10.1
        radial.position = CGPointMake(size.width/2, size.height/2)
        addChild(radial)
        

        let add = SKAction.runBlock { () -> Void in
            let random = CGFloat(arc4random()%2)
            self.addSlice(atLocation: CGPointMake(self.size.width/2+random, self.size.height/2))
        }
        
        let wait = SKAction.waitForDuration(0.005)
        let addThenWait = SKAction.group([add, wait])
        let addAll = SKAction.repeatAction(addThenWait, count: balls)
        runAction(addAll)
    }
    
    func enterDragOverState(){
        setStandardGravity()
        removeAllChildren()
    }
    
    
    func prepareForDrop(){
        physicsWorld.gravity = CGVectorMake(0, 20)
        radial.animationSpeed = 10
        radial.position = CGPointMake(size.width, size.height+100)
        let scaleAction = SKAction.scaleTo(0, duration: 0.1)
        let opacityAction = SKAction.fadeAlphaTo(0.9, duration: 0.1)
        let goAwayAction = SKAction.group([scaleAction, opacityAction])
        
        for child in children{
            child.runAction(goAwayAction, completion: { () -> Void in
                self.setStandardGravity()
            })
        }
    }
    
    func updateDragPosition(location:CGPoint){
        if radial != nil {
            radial.position = location;
        }
    }
    
    
    func stopLoading(){
        // todo: do something sexier here
        removeAllChildren()
        removeActionForKey(REPEAT_ACTION)
    }
    
    
    func setInviteGravity(){
        physicsWorld.gravity = CGVectorMake(0, 0)
    }
    
    func setStandardGravity(){
        physicsWorld.gravity = CGVectorMake(0, -20)
    }
    
    override func didMoveToView(view: SKView) {
        print("didMoveToView")
        size = view.frame.size
        backgroundColor = SKColor.clearColor()
        setStandardGravity()
    }
    
    func enterInviteState(){
        print("enterInviteState")
        removeAllChildren()
        setStandardGravity()
        useArrowBody()
        let addBall = SKAction.runBlock { () -> Void in
            self.addSlice(atLocation: CGPointMake(self.size.width/2, self.size.height/2), isProgressFeedback: false)
        }
        
        let wait = SKAction.waitForDuration(0.01)
        let showtime = SKAction.group([addBall, wait])
        let multipleBalls = SKAction.repeatAction(showtime, count: 60)
        runAction(multipleBalls)
    }
    
    func enterInactiveState(){ // save cpu
        print("enterInactiveState (noop)")
//        removeAllChildren()
    }
    
    
    func useArrowBody(){
        print("useArrowBody")
            self.physicsBody = SKPhysicsBody(edgeLoopFromPath: getArrowPath())
    }
    
    func useCircleBody(){
        print("useCircleBody")
        let circleRect = CGRectMake(0, 0, view!.frame.width, view!.frame.width)
        let circlePath = CGPathCreateWithEllipseInRect(circleRect, nil)
        self.physicsBody = SKPhysicsBody(edgeLoopFromPath: circlePath)
    }
    
    
    func getArrowPath() -> CGPath {
        let offsetX = self.size.width * self.anchorPoint.x
        let offsetY = self.size.height * self.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        
        CGPathMoveToPoint(path, nil, 75 - offsetX, 173 - offsetY)
        CGPathAddLineToPoint(path, nil, 139 - offsetX, 171 - offsetY)
        CGPathAddLineToPoint(path, nil, 139 - offsetX, 110 - offsetY)
        CGPathAddLineToPoint(path, nil, 164 - offsetX, 107 - offsetY)
        CGPathAddLineToPoint(path, nil, 107 - offsetX, 40 - offsetY)
        CGPathAddLineToPoint(path, nil, 49 - offsetX, 107 - offsetY)
        CGPathAddLineToPoint(path, nil, 75 - offsetX, 109 - offsetY)
        CGPathAddLineToPoint(path, nil, 73 - offsetX, 172 - offsetY)

        
        CGPathCloseSubpath(path)
        
        return path
//        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
    }
    
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}


