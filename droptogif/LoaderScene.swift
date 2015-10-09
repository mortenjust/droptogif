//
//  LoaderScene.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/8/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import SpriteKit

class LoaderScene: SKScene {
    var REPEAT_ACTION = "repeatAction"
    var radial : SKFieldNode!
    
    func getAddSliceAction() -> SKAction {
        let x = size.width/2
        let y = size.height-1
        
        let action = SKAction.runBlock { () -> Void in
            self.addSlice(atLocation: CGPointMake(x, y))
        }
        
        return action
    }
    
    func addSlice(atLocation loc:CGPoint){

        let slice = SKSpriteNode(imageNamed: "slice")
        slice.alpha = 1
        
        slice.position = loc

        
        // TODO: Change to circle
        let random = (arc4random()+10) % 200;
        let randomScale:CGFloat = CGFloat(random)/100;
        
        slice.physicsBody = SKPhysicsBody(circleOfRadius: slice.size.height-8)
        addChild(slice)
        
        let scaleAction = SKAction.scaleBy(randomScale, duration: 0)
        slice.physicsBody?.affectedByGravity = true
        slice.runAction(scaleAction)
        slice.physicsBody?.dynamic = true
        slice.physicsBody?.density = 0.01
        slice.physicsBody?.restitution = 0.3
        slice.physicsBody?.charge = 0.02
    }
    
    func startLoading(){
        let waitAction = SKAction.waitForDuration(0.5);
        let addAndWait = SKAction.sequence([getAddSliceAction(), waitAction])
        let repeatAction = SKAction.repeatAction(addAndWait, count: 200)

        runAction(repeatAction, withKey: REPEAT_ACTION)
    }
    
    func showDragInvite(){

        // add a bunch of balls at random locations
        setInviteGravity()
        
        // then a force that will follow the mouse
        radial = SKFieldNode.radialGravityField()
        radial.strength = 0.5
        radial.falloff = 0
        radial.animationSpeed = 0.1
        radial.position = CGPointMake(size.width/2, size.height/2)
        addChild(radial)
        
        for(var i = 0; i<50; i++){
//            let height = UInt32(size.height);
//            let width = UInt32(size.width);
//            let x = CGFloat((arc4random()+(width/2)+5) % width/2);
//            let y = CGFloat((arc4random()+(height/2)+5) % height/2);

            
            let random = CGFloat(arc4random()%2)
            addSlice(atLocation: CGPointMake(size.width/2+random, size.height/2))
        }

        // stop gravity
    }
    
    func hideDragInvite(){
        setStandardGravity()
        removeAllChildren()
    }
    
    
    func prepareForDrop(){
        physicsWorld.gravity = CGVectorMake(0, 20)
        radial.animationSpeed = 1
        radial.position = CGPointMake(size.width, size.height+100)
        let scaleAction = SKAction.scaleTo(0, duration: 0.1)
        let opacityAction = SKAction.fadeAlphaTo(0.5, duration: 0.1)
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
        size = view.frame.size
        backgroundColor = SKColor.clearColor()

        setStandardGravity()
        
        let circleRect = CGRectMake(0, 0, view.frame.width, view.frame.width)
        let circlePath = CGPathCreateWithEllipseInRect(circleRect, nil)

        physicsBody = SKPhysicsBody(edgeLoopFromPath: circlePath)
        
    }
}
